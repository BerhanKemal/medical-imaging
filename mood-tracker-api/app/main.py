"""
Mood Tracker API -- main application entry point.

Run with:
    uvicorn app.main:app --reload

Interactive docs available at:
    http://127.0.0.1:8000/docs     (Swagger UI)
    http://127.0.0.1:8000/redoc    (ReDoc)
"""

from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.database import Base, engine
from app.routers import auth_router, mood_router


# ---------------------------------------------------------------------------
# Application lifespan (startup / shutdown)
# ---------------------------------------------------------------------------

@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Code before `yield` runs on startup; code after runs on shutdown.

    On startup we create all database tables that do not yet exist.
    This is convenient for development -- in production you would
    typically use a migration tool such as Alembic.
    """
    # Startup: create tables.
    Base.metadata.create_all(bind=engine)
    print("Database tables created (if they did not exist).")

    yield  # Application runs here.

    # Shutdown: cleanup (nothing needed for SQLite).
    print("Application shutting down.")


# ---------------------------------------------------------------------------
# FastAPI application instance
# ---------------------------------------------------------------------------

app = FastAPI(
    title="Mood Tracker API",
    description=(
        "REST API backend for the Mood Tracker mobile application. "
        "Built as a reference implementation for the "
        "'Mobile Apps for Healthcare' course at AGH UST."
    ),
    version="1.0.0",
    lifespan=lifespan,
)


# ---------------------------------------------------------------------------
# CORS middleware
# ---------------------------------------------------------------------------
# During development the Flutter app may run on localhost with a
# different port, on an Android emulator (10.0.2.2), or on a physical
# device. We allow all origins here for convenience; tighten this in
# production.

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production: list specific origins.
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ---------------------------------------------------------------------------
# Route registration
# ---------------------------------------------------------------------------

app.include_router(auth_router.router)
app.include_router(mood_router.router)


# ---------------------------------------------------------------------------
# Health check
# ---------------------------------------------------------------------------

@app.get("/", tags=["Health"])
def health_check() -> dict:
    """
    Simple health-check endpoint.

    Use this to verify that the API is running.
    """
    return {"status": "ok", "message": "Mood Tracker API is running"}
