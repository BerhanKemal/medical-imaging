"""
SQLAlchemy ORM models.

Each class maps to a table in the database.  SQLAlchemy will create
the tables automatically when `Base.metadata.create_all()` is called
at application startup (see main.py).
"""

from datetime import datetime, timezone

from sqlalchemy import (
    Column,
    DateTime,
    ForeignKey,
    Integer,
    String,
    Text,
)
from sqlalchemy.orm import relationship

from app.database import Base


class User(Base):
    """
    Represents a registered user.

    Columns:
        id              -- primary key, auto-incremented.
        email           -- unique email address used for login.
        username        -- display name (unique).
        hashed_password -- bcrypt hash; the plain-text password is
                           never stored.
        created_at      -- timestamp of registration (UTC).
    """

    __tablename__ = "users"

    id: int = Column(Integer, primary_key=True, index=True)
    email: str = Column(String(255), unique=True, index=True, nullable=False)
    username: str = Column(String(100), unique=True, index=True, nullable=False)
    hashed_password: str = Column(String(255), nullable=False)
    created_at: datetime = Column(
        DateTime, default=lambda: datetime.now(timezone.utc), nullable=False
    )

    # One-to-many relationship: a user has many mood entries.
    mood_entries = relationship(
        "MoodEntry", back_populates="owner", cascade="all, delete-orphan"
    )


class MoodEntry(Base):
    """
    A single mood journal entry belonging to a user.

    Columns:
        id         -- primary key, auto-incremented.
        user_id    -- foreign key to `users.id`.
        score      -- integer from 1 (very bad) to 10 (excellent).
        note       -- optional free-text note.
        created_at -- when the entry was recorded (UTC).
    """

    __tablename__ = "mood_entries"

    id: int = Column(Integer, primary_key=True, index=True)
    user_id: int = Column(
        Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    score: int = Column(Integer, nullable=False)
    note: str | None = Column(Text, nullable=True)
    created_at: datetime = Column(
        DateTime, default=lambda: datetime.now(timezone.utc), nullable=False
    )

    # Back-reference to the owning user.
    owner = relationship("User", back_populates="mood_entries")
