"""
Mood Tracking API — Starter Template
=====================================
Multiplatform Mobile Software Engineering in Practice, Week 2

Build a simple REST API that tracks mood entries.
Follow the lab instructions to fill in each TODO section.

Run with:
    uvicorn main:app --reload

Then open http://localhost:8000/docs to explore the API.
"""

from fastapi import FastAPI

app = FastAPI(title="Mood API", description="A simple mood tracking API")

# TODO: Import BaseModel from pydantic and create a MoodEntry model
#       with two fields:
#         - score: int
#         - note: str


# TODO: Create an in-memory list to store mood entries
#       (just a plain Python list)


# TODO: GET /health endpoint
#       Should return {"status": "healthy"}


# TODO: POST /mood endpoint
#       Should accept a MoodEntry in the request body,
#       append it to the list, and return the entry


# TODO: GET /moods endpoint
#       Should return the full list of mood entries
