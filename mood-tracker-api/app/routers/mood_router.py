"""
Mood entry endpoints (CRUD + statistics).

All routes require authentication via a Bearer access token.

Routes:
    POST   /moods              -- create a new mood entry.
    GET    /moods              -- list the user's entries (with optional date filter).
    GET    /moods/stats/summary -- aggregate statistics.
    GET    /moods/{id}         -- retrieve a single entry.
    PUT    /moods/{id}         -- update an entry.
    DELETE /moods/{id}         -- delete an entry.
"""

from datetime import date, datetime, time, timezone

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import func
from sqlalchemy.orm import Session

from app.auth import get_current_user
from app.database import get_db
from app.models import MoodEntry, User
from app.schemas import MoodCreate, MoodList, MoodResponse, MoodStats

router = APIRouter(prefix="/moods", tags=["Mood Entries"])


# ---------------------------------------------------------------------------
# Helper: fetch an entry that belongs to the current user, or 404.
# ---------------------------------------------------------------------------

def _get_user_entry(
    entry_id: int,
    user: User,
    db: Session,
) -> MoodEntry:
    """
    Retrieve a mood entry by ID. Raises 404 if not found or if the
    entry belongs to a different user.
    """
    entry = db.query(MoodEntry).filter(MoodEntry.id == entry_id).first()

    if entry is None or entry.user_id != user.id:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Mood entry not found",
        )
    return entry


# ---------------------------------------------------------------------------
# POST /moods
# ---------------------------------------------------------------------------

@router.post(
    "",
    response_model=MoodResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create a mood entry",
)
def create_mood(
    mood_in: MoodCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> MoodEntry:
    """
    Record a new mood entry for the authenticated user.

    - **score**: integer from 1 (very bad) to 10 (excellent).
    - **note**: optional free-text journal note (max 2000 chars).
    """
    entry = MoodEntry(
        user_id=current_user.id,
        score=mood_in.score,
        note=mood_in.note,
    )
    db.add(entry)
    db.commit()
    db.refresh(entry)

    return entry


# ---------------------------------------------------------------------------
# GET /moods
# ---------------------------------------------------------------------------

@router.get(
    "",
    response_model=MoodList,
    summary="List mood entries",
)
def list_moods(
    date_from: date | None = Query(None, description="Filter: entries on or after this date (YYYY-MM-DD)"),
    date_to: date | None = Query(None, description="Filter: entries on or before this date (YYYY-MM-DD)"),
    skip: int = Query(0, ge=0, description="Number of entries to skip (for pagination)"),
    limit: int = Query(50, ge=1, le=200, description="Max entries to return"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> dict:
    """
    Return the authenticated user's mood entries, newest first.

    Supports optional **date range filtering** and **pagination**.
    """
    query = db.query(MoodEntry).filter(MoodEntry.user_id == current_user.id)

    # Apply optional date filters.
    if date_from is not None:
        # Convert date to datetime at start of day (UTC).
        dt_from = datetime.combine(date_from, time.min, tzinfo=timezone.utc)
        query = query.filter(MoodEntry.created_at >= dt_from)

    if date_to is not None:
        # Convert date to datetime at end of day (UTC).
        dt_to = datetime.combine(date_to, time.max, tzinfo=timezone.utc)
        query = query.filter(MoodEntry.created_at <= dt_to)

    total = query.count()
    entries = (
        query
        .order_by(MoodEntry.created_at.desc())
        .offset(skip)
        .limit(limit)
        .all()
    )

    return {"entries": entries, "total": total}


# ---------------------------------------------------------------------------
# GET /moods/stats/summary
#
# IMPORTANT: This route must be defined BEFORE /moods/{mood_id}
# so that FastAPI does not interpret "stats" as a mood ID.
# ---------------------------------------------------------------------------

@router.get(
    "/stats/summary",
    response_model=MoodStats,
    summary="Get mood statistics",
)
def mood_stats(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> dict:
    """
    Return aggregate statistics for all mood entries of the
    authenticated user: total count, average / min / max scores,
    and the date range.
    """
    base = db.query(MoodEntry).filter(MoodEntry.user_id == current_user.id)

    total = base.count()

    if total == 0:
        return {
            "total_entries": 0,
            "average_score": None,
            "min_score": None,
            "max_score": None,
            "date_from": None,
            "date_to": None,
        }

    stats = db.query(
        func.avg(MoodEntry.score),
        func.min(MoodEntry.score),
        func.max(MoodEntry.score),
        func.min(MoodEntry.created_at),
        func.max(MoodEntry.created_at),
    ).filter(MoodEntry.user_id == current_user.id).one()

    return {
        "total_entries": total,
        "average_score": round(float(stats[0]), 2) if stats[0] else None,
        "min_score": stats[1],
        "max_score": stats[2],
        "date_from": stats[3],
        "date_to": stats[4],
    }


# ---------------------------------------------------------------------------
# GET /moods/{mood_id}
# ---------------------------------------------------------------------------

@router.get(
    "/{mood_id}",
    response_model=MoodResponse,
    summary="Get a mood entry by ID",
)
def get_mood(
    mood_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> MoodEntry:
    """
    Retrieve a single mood entry by its ID.

    Returns 404 if the entry does not exist or belongs to another user.
    """
    return _get_user_entry(mood_id, current_user, db)


# ---------------------------------------------------------------------------
# PUT /moods/{mood_id}
# ---------------------------------------------------------------------------

@router.put(
    "/{mood_id}",
    response_model=MoodResponse,
    summary="Update a mood entry",
)
def update_mood(
    mood_id: int,
    mood_in: MoodCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> MoodEntry:
    """
    Update the score and/or note of an existing mood entry.

    Returns 404 if the entry does not exist or belongs to another user.
    """
    entry = _get_user_entry(mood_id, current_user, db)

    entry.score = mood_in.score
    entry.note = mood_in.note

    db.commit()
    db.refresh(entry)

    return entry


# ---------------------------------------------------------------------------
# DELETE /moods/{mood_id}
# ---------------------------------------------------------------------------

@router.delete(
    "/{mood_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Delete a mood entry",
)
def delete_mood(
    mood_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> None:
    """
    Permanently delete a mood entry.

    Returns 404 if the entry does not exist or belongs to another user.
    """
    entry = _get_user_entry(mood_id, current_user, db)

    db.delete(entry)
    db.commit()
