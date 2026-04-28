"""
Authentication endpoints.

Routes:
    POST /auth/register  -- create a new user account.
    POST /auth/login     -- authenticate and receive JWT tokens.
    POST /auth/refresh   -- exchange a refresh token for a new pair.
    GET  /auth/me        -- return the current authenticated user.
"""

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session

from app.auth import (
    create_access_token,
    create_refresh_token,
    decode_token,
    get_current_user,
    hash_password,
    verify_password,
)
from app.database import get_db
from app.models import User
from app.schemas import Token, UserCreate, UserResponse

router = APIRouter(prefix="/auth", tags=["Authentication"])


# ---------------------------------------------------------------------------
# POST /auth/register
# ---------------------------------------------------------------------------

@router.post(
    "/register",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Register a new user",
)
def register(user_in: UserCreate, db: Session = Depends(get_db)) -> User:
    """
    Create a new user account.

    - **email** must be unique.
    - **username** must be unique (3-100 chars).
    - **password** must be at least 6 characters.

    Returns the created user (without the password).
    """
    # Check if email is already taken.
    if db.query(User).filter(User.email == user_in.email).first():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered",
        )

    # Check if username is already taken.
    if db.query(User).filter(User.username == user_in.username).first():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Username already taken",
        )

    # Create the user with a hashed password.
    user = User(
        email=user_in.email,
        username=user_in.username,
        hashed_password=hash_password(user_in.password),
    )
    db.add(user)
    db.commit()
    db.refresh(user)  # Reload to get the auto-generated id and created_at.

    return user


# ---------------------------------------------------------------------------
# POST /auth/login
# ---------------------------------------------------------------------------

@router.post(
    "/login",
    response_model=Token,
    summary="Login and receive JWT tokens",
)
def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db),
) -> dict:
    """
    Authenticate with **email** (passed as `username` field in the form)
    and **password**.

    Returns an access token and a refresh token.

    > Note: FastAPI's `OAuth2PasswordRequestForm` uses the field name
    > `username` by convention, but we treat it as the email address.
    """
    user = db.query(User).filter(User.email == form_data.username).first()

    if user is None or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    return {
        "access_token": create_access_token(user.id),
        "refresh_token": create_refresh_token(user.id),
        "token_type": "bearer",
    }


# ---------------------------------------------------------------------------
# POST /auth/refresh
# ---------------------------------------------------------------------------

@router.post(
    "/refresh",
    response_model=Token,
    summary="Refresh access token",
)
def refresh_token(refresh_token: str, db: Session = Depends(get_db)) -> dict:
    """
    Exchange a valid **refresh token** for a brand-new token pair.

    Send the refresh token as a query parameter or JSON body field.
    """
    # Decode the refresh token (validates expiry and type).
    token_data = decode_token(refresh_token, expected_type="refresh")

    # Make sure the user still exists.
    user = db.query(User).filter(User.id == token_data.user_id).first()
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found",
        )

    return {
        "access_token": create_access_token(user.id),
        "refresh_token": create_refresh_token(user.id),
        "token_type": "bearer",
    }


# ---------------------------------------------------------------------------
# GET /auth/me
# ---------------------------------------------------------------------------

@router.get(
    "/me",
    response_model=UserResponse,
    summary="Get current user profile",
)
def get_me(current_user: User = Depends(get_current_user)) -> User:
    """
    Return the profile of the currently authenticated user.

    Requires a valid **Bearer** access token in the `Authorization` header.
    """
    return current_user
