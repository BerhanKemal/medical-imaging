"""
Pydantic schemas (data-transfer objects).

These schemas separate the *API contract* from the *database models*.
FastAPI uses them for:
    1. Request body validation and parsing.
    2. Response serialization (what the client sees).
    3. Automatic OpenAPI / Swagger documentation.
"""

from datetime import datetime
from pydantic import BaseModel, EmailStr, Field


# ---------------------------------------------------------------------------
# Auth / User schemas
# ---------------------------------------------------------------------------

class UserCreate(BaseModel):
    """Schema for the registration request body."""
    email: EmailStr
    username: str = Field(..., min_length=3, max_length=100)
    password: str = Field(..., min_length=6, max_length=128)


class UserResponse(BaseModel):
    """Schema returned whenever user data is sent to the client."""
    id: int
    email: EmailStr
    username: str
    created_at: datetime

    model_config = {"from_attributes": True}


class Token(BaseModel):
    """Schema returned after a successful login or token refresh."""
    access_token: str
    refresh_token: str
    token_type: str = "bearer"


class TokenData(BaseModel):
    """
    Internal schema extracted from a decoded JWT.
    Not returned to the client directly.
    """
    user_id: int | None = None


# ---------------------------------------------------------------------------
# Mood schemas
# ---------------------------------------------------------------------------

class MoodCreate(BaseModel):
    """Schema for creating or updating a mood entry."""
    score: int = Field(..., ge=1, le=10, description="Mood score from 1 (worst) to 10 (best)")
    note: str | None = Field(None, max_length=2000, description="Optional journal note")


class MoodResponse(BaseModel):
    """Schema returned for a single mood entry."""
    id: int
    score: int
    note: str | None
    created_at: datetime

    model_config = {"from_attributes": True}


class MoodList(BaseModel):
    """Paginated list wrapper for mood entries."""
    entries: list[MoodResponse]
    total: int


class MoodStats(BaseModel):
    """Summary statistics for a user's mood entries."""
    total_entries: int
    average_score: float | None
    min_score: int | None
    max_score: int | None
    date_from: datetime | None
    date_to: datetime | None
