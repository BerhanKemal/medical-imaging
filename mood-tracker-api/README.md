# Mood Tracker API

REST API backend for the **Mood Tracker** mobile application, built as a reference implementation for the *Mobile Apps for Healthcare* course at AGH UST.

## Tech Stack

- **FastAPI** -- modern Python web framework with automatic OpenAPI docs
- **SQLAlchemy** -- ORM for database access
- **SQLite** -- lightweight file-based database (no setup required)
- **JWT** -- stateless authentication with access and refresh tokens
- **bcrypt** -- secure password hashing

## Project Structure

```
mood-tracker-api/
├── requirements.txt        # Python dependencies
├── README.md               # This file
└── app/
    ├── __init__.py
    ├── main.py             # FastAPI application entry point
    ├── config.py           # Configuration (env vars, defaults)
    ├── database.py         # SQLAlchemy engine & session setup
    ├── models.py           # ORM models (User, MoodEntry)
    ├── schemas.py          # Pydantic request/response schemas
    ├── auth.py             # Password hashing, JWT, dependencies
    └── routers/
        ├── __init__.py
        ├── auth_router.py  # /auth/* endpoints
        └── mood_router.py  # /moods/* endpoints
```

## Setup

### 1. Create a virtual environment

```bash
cd mood-tracker-api
python3 -m venv venv
source venv/bin/activate   # macOS / Linux
# venv\Scripts\activate    # Windows
```

### 2. Install dependencies

```bash
pip install -r requirements.txt
```

### 3. Run the server

```bash
uvicorn app.main:app --reload
```

The API will be available at **http://127.0.0.1:8000**.

Interactive documentation:
- Swagger UI: http://127.0.0.1:8000/docs
- ReDoc: http://127.0.0.1:8000/redoc

## Environment Variables

| Variable                     | Default                                | Description                          |
|------------------------------|----------------------------------------|--------------------------------------|
| `SECRET_KEY`                 | `dev-secret-key-change-me-in-production` | JWT signing key                    |
| `DATABASE_URL`               | `sqlite:///./mood_tracker.db`          | SQLAlchemy database URL              |
| `ACCESS_TOKEN_EXPIRE_MINUTES`| `30`                                   | Access token lifetime (minutes)      |
| `REFRESH_TOKEN_EXPIRE_DAYS`  | `7`                                    | Refresh token lifetime (days)        |

## API Endpoints

### Health Check

| Method | Path | Description         |
|--------|------|---------------------|
| GET    | `/`  | Health check        |

### Authentication (`/auth`)

| Method | Path              | Description              | Auth Required |
|--------|-------------------|--------------------------|---------------|
| POST   | `/auth/register`  | Create a new account     | No            |
| POST   | `/auth/login`     | Login, get JWT tokens    | No            |
| POST   | `/auth/refresh`   | Refresh access token     | No            |
| GET    | `/auth/me`        | Get current user profile | Yes           |

### Mood Entries (`/moods`)

| Method | Path                  | Description                | Auth Required |
|--------|-----------------------|----------------------------|---------------|
| POST   | `/moods`              | Create a mood entry        | Yes           |
| GET    | `/moods`              | List entries (filterable)  | Yes           |
| GET    | `/moods/stats/summary`| Get mood statistics        | Yes           |
| GET    | `/moods/{id}`         | Get a specific entry       | Yes           |
| PUT    | `/moods/{id}`         | Update an entry            | Yes           |
| DELETE | `/moods/{id}`         | Delete an entry            | Yes           |

## Example curl Commands

Below are example commands to test every endpoint. Replace `$TOKEN` with an actual access token obtained from the login endpoint.

### Health Check

```bash
curl http://127.0.0.1:8000/
```

### Register a New User

```bash
curl -X POST http://127.0.0.1:8000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "student@agh.edu.pl",
    "username": "student1",
    "password": "secret123"
  }'
```

### Login

```bash
curl -X POST http://127.0.0.1:8000/auth/login \
  -d "username=student@agh.edu.pl&password=secret123"
```

> Note: The login endpoint uses form data (`application/x-www-form-urlencoded`), not JSON. The `username` field should contain the email address.

Save the returned `access_token` for subsequent requests:

```bash
export TOKEN="paste-your-access-token-here"
```

### Refresh Token

```bash
curl -X POST "http://127.0.0.1:8000/auth/refresh?refresh_token=YOUR_REFRESH_TOKEN"
```

### Get Current User

```bash
curl http://127.0.0.1:8000/auth/me \
  -H "Authorization: Bearer $TOKEN"
```

### Create a Mood Entry

```bash
curl -X POST http://127.0.0.1:8000/moods \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "score": 8,
    "note": "Had a great day at the lab!"
  }'
```

### List Mood Entries

```bash
# All entries
curl http://127.0.0.1:8000/moods \
  -H "Authorization: Bearer $TOKEN"

# With date filter
curl "http://127.0.0.1:8000/moods?date_from=2026-01-01&date_to=2026-12-31" \
  -H "Authorization: Bearer $TOKEN"

# With pagination
curl "http://127.0.0.1:8000/moods?skip=0&limit=10" \
  -H "Authorization: Bearer $TOKEN"
```

### Get a Specific Entry

```bash
curl http://127.0.0.1:8000/moods/1 \
  -H "Authorization: Bearer $TOKEN"
```

### Update an Entry

```bash
curl -X PUT http://127.0.0.1:8000/moods/1 \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "score": 9,
    "note": "Actually, it was even better than I thought!"
  }'
```

### Delete an Entry

```bash
curl -X DELETE http://127.0.0.1:8000/moods/1 \
  -H "Authorization: Bearer $TOKEN"
```

### Get Mood Statistics

```bash
curl http://127.0.0.1:8000/moods/stats/summary \
  -H "Authorization: Bearer $TOKEN"
```

## Connecting from Flutter

When running the API on your local machine and the Flutter app on:

- **iOS Simulator / desktop**: use `http://127.0.0.1:8000`
- **Android Emulator**: use `http://10.0.2.2:8000`
- **Physical device**: use your computer's LAN IP, e.g. `http://192.168.1.42:8000`, and start the server with `uvicorn app.main:app --host 0.0.0.0 --reload`

## License

Educational material for the Mobile Apps for Healthcare course at AGH UST.
