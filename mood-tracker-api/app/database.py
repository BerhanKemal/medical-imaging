"""
Database engine and session setup (SQLAlchemy).

Key concepts for students:
- `engine`        -- the low-level connection pool to the database.
- `SessionLocal`  -- a factory that produces new database sessions.
- `Base`          -- declarative base class for ORM models.
- `get_db()`      -- FastAPI dependency that yields a session and
                     guarantees it is closed after the request.
"""

from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker
from typing import Generator

from app.config import DATABASE_URL

# For SQLite we need `check_same_thread=False` so that FastAPI's
# thread pool can reuse the connection across threads.
connect_args = {}
if DATABASE_URL.startswith("sqlite"):
    connect_args["check_same_thread"] = False

engine = create_engine(DATABASE_URL, connect_args=connect_args)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


class Base(DeclarativeBase):
    """Declarative base for all ORM models."""
    pass


def get_db() -> Generator:
    """
    FastAPI dependency that provides a database session.

    Usage in a route:
        @router.get("/items")
        def list_items(db: Session = Depends(get_db)):
            ...

    The `finally` block ensures the session is always closed,
    even if the request handler raises an exception.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
