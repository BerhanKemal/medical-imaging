"""
Authentication and authorization utilities.

This module provides:
    - Password hashing and verification via bcrypt.
    - JWT access & refresh token creation.
    - A FastAPI dependency (`get_current_user`) that extracts and
      validates the Bearer token from incoming requests.
"""

from datetime import datetime, timedelta, timezone

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from passlib.context import CryptContext
from sqlalchemy.orm import Session

from app.config import (
    ACCESS_TOKEN_EXPIRE_MINUTES,
    ALGORITHM,
    REFRESH_TOKEN_EXPIRE_DAYS,
    SECRET_KEY,
)
from app.database import get_db
from app.models import User
from app.schemas import TokenData

# ---------------------------------------------------------------------------
# Password hashing
# ---------------------------------------------------------------------------

# `CryptContext` abstracts the hashing algorithm. We use bcrypt, which
# is slow on purpose -- this makes brute-force attacks impractical.
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hash_password(password: str) -> str:
    """Return the bcrypt hash of a plain-text password."""
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Check a plain-text password against its stored hash."""
    return pwd_context.verify(plain_password, hashed_password)


# ---------------------------------------------------------------------------
# JWT token helpers
# ---------------------------------------------------------------------------

def create_access_token(user_id: int) -> str:
    """
    Create a short-lived access token.

    The payload ("claims") contains:
        - sub  : the user ID (as a string, per JWT convention).
        - exp  : expiration time.
        - type : "access" to distinguish from refresh tokens.
    """
    expire = datetime.now(timezone.utc) + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    payload = {
        "sub": str(user_id),
        "exp": expire,
        "type": "access",
    }
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)


def create_refresh_token(user_id: int) -> str:
    """
    Create a long-lived refresh token.

    Refresh tokens let the client obtain a new access token without
    asking the user to log in again.
    """
    expire = datetime.now(timezone.utc) + timedelta(days=REFRESH_TOKEN_EXPIRE_DAYS)
    payload = {
        "sub": str(user_id),
        "exp": expire,
        "type": "refresh",
    }
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)


def decode_token(token: str, expected_type: str = "access") -> TokenData:
    """
    Decode and validate a JWT.

    Raises `HTTPException(401)` if the token is invalid, expired,
    or of the wrong type.
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id_str: str | None = payload.get("sub")
        token_type: str | None = payload.get("type")

        if user_id_str is None or token_type != expected_type:
            raise credentials_exception

        return TokenData(user_id=int(user_id_str))

    except (JWTError, ValueError):
        raise credentials_exception


# ---------------------------------------------------------------------------
# FastAPI dependency -- extracts the current authenticated user
# ---------------------------------------------------------------------------

# `OAuth2PasswordBearer` tells FastAPI where to find the token.
# It also powers the "Authorize" button in the Swagger UI.
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")


def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db),
) -> User:
    """
    FastAPI dependency that returns the authenticated `User` object.

    Usage:
        @router.get("/protected")
        def protected_route(user: User = Depends(get_current_user)):
            ...
    """
    token_data = decode_token(token, expected_type="access")

    user = db.query(User).filter(User.id == token_data.user_id).first()
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return user
