"""
Mood Tracking API — Complete Solution
======================================
Multiplatform Mobile Software Engineering in Practice, Week 2

A minimal REST API that stores and retrieves mood entries.
This file is the COMPLETE solution. Students should build this
themselves by filling in main.py during the lab.

Run with:
    uvicorn solution:app --reload

Endpoints:
    GET  /health  — health check
    POST /mood    — create a mood entry
    GET  /moods   — list all mood entries
"""

from fastapi import FastAPI
from pydantic import BaseModel


# ---------------------------------------------------------------------------
# App instance
# ---------------------------------------------------------------------------

app = FastAPI(
    title="Mood API",
    description="A simple mood tracking API for the Week 2 lab exercise.",
)


# ---------------------------------------------------------------------------
# Data model
# ---------------------------------------------------------------------------

class MoodEntry(BaseModel):
    """A single mood entry submitted by the user.

    Attributes:
        score: An integer representing the mood level (e.g., 1-10).
        note:  A short free-text description of how the user feels.
    """

    score: int
    note: str


# ---------------------------------------------------------------------------
# In-memory storage
# ---------------------------------------------------------------------------

mood_entries: list[MoodEntry] = []


# ---------------------------------------------------------------------------
# Endpoints
# ---------------------------------------------------------------------------

@app.get("/health")
def health_check() -> dict:
    """Check if the API is running.

    Returns:
        A dictionary with a single key "status" set to "healthy".
    """
    return {"status": "healthy"}


@app.post("/mood")
def create_mood(entry: MoodEntry) -> MoodEntry:
    """Record a new mood entry.

    The entry is validated automatically by FastAPI/Pydantic. If the
    request body is missing required fields or has wrong types, a 422
    Unprocessable Entity response is returned.

    Args:
        entry: A MoodEntry parsed from the JSON request body.

    Returns:
        The mood entry that was just stored.
    """
    mood_entries.append(entry)
    return entry


@app.get("/moods")
def get_moods() -> list[MoodEntry]:
    """Retrieve all mood entries.

    Returns:
        A list of every mood entry recorded so far (in-memory, resets on
        server restart).
    """
    return mood_entries
