"""
Application configuration.

All settings are read from environment variables with sensible defaults
for local development. In production, override SECRET_KEY at minimum.
"""

import os


# ---- Security ---------------------------------------------------------------
# IMPORTANT: Change this in production! Generate a real key with:
#   python -c "import secrets; print(secrets.token_hex(32))"
SECRET_KEY: str = os.getenv(
    "SECRET_KEY",
    "dev-secret-key-change-me-in-production",
)
ALGORITHM: str = "HS256"

# Token lifetimes
ACCESS_TOKEN_EXPIRE_MINUTES: int = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "30"))
REFRESH_TOKEN_EXPIRE_DAYS: int = int(os.getenv("REFRESH_TOKEN_EXPIRE_DAYS", "7"))

# ---- Database ---------------------------------------------------------------
# SQLite by default; override for PostgreSQL / MySQL in production.
DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite:///./mood_tracker.db")
