# Week 8 Lab: Networking & API Integration

<div class="lab-meta" markdown>
<div class="lab-meta__row"><span class="lab-meta__label">Course</span> Mobile Apps for Healthcare</div>
<div class="lab-meta__row"><span class="lab-meta__label">Duration</span> ~2 hours</div>
<div class="lab-meta__row"><span class="lab-meta__label">Prerequisites</span> Week 7 Local Data (working Mood Tracker with SQLite persistence)</div>
</div>

<div class="grid cards" markdown>

- :material-target:{ .lg .middle } **Learning Objectives**

    ---

    By the end of this lab, you will be able to:

    - [ ] Connect your app to a REST API with proper JSON serialization
    - [ ] Implement an offline-first strategy with local fallback
    - [ ] Handle network errors gracefully with user-facing feedback
    - [ ] Authenticate API requests using Bearer tokens

- :material-clock-outline:{ .lg .middle } **Time Estimate**

    ---

    | Section | Duration |
    |---------|----------|
    | Part 1-2: JSON serialization | ~15 min |
    | Part 3-4: API client (GET/POST) | ~25 min |
    | Part 5: DELETE + error handling | ~15 min |
    | Part 6-7: Repository + fallback | ~25 min |
    | Self-check & reflection | ~10 min |

</div>

!!! abstract "What you already know"
    **From Week 7:** Your mood entries persist in SQLite — the app works offline and data survives restarts. **The limitation:** Data is trapped on one device. A user who logs moods on their phone can't see them on their tablet. **This week's upgrade:** Connect to a REST API so data lives on a server, with your SQLite database as an offline fallback. The repository pattern from Week 7 makes this almost seamless.

---

## Detailed Learning Objectives

By the end of this lab you will be able to:

1. Explain why mobile health apps need to communicate with remote servers.
2. Construct HTTP requests (GET, POST, DELETE) using the `http` package in Dart.
3. Implement JSON serialization (`toJson()`) and deserialization (`fromJson()`) on a model class.
4. Build a reusable API client that attaches headers and handles responses.
5. Implement a service layer that translates API responses into domain objects.
6. Handle network errors gracefully using try-catch and `SocketException`.
7. Implement an online/offline strategy where the API is the primary source and SQLite is the fallback.

---

## Prerequisites

Before you begin, make sure you have the following ready:

- **Flutter SDK** installed and on your PATH. Verify by running:
  ```bash
  flutter doctor
  ```
  All checks should pass (or show only minor warnings unrelated to your target platform).
- **An IDE** with Flutter support (VS Code recommended, or Android Studio).
- **A running device** -- emulator, simulator, or physical device.
- **The mood-tracker-api server running locally.** See the "API Server Setup" section below, then verify:
  ```bash
  curl http://localhost:8000/health
  ```
  You should receive a JSON response like `{"status": "healthy"}`.
- **The starter project** loaded in your IDE. Download it from the course materials:
  ```
  week-08-networking-api/lab/starter/mood_tracker/
  ```
  Copy the entire `mood_tracker` folder to your local machine, open it in your IDE, and run:
  ```bash
  cd mood_tracker
  flutter pub get
  flutter run
  ```
  Verify the app builds and launches before starting the exercises.

> **Tip:** If the starter project does not compile, check that `http` appears in `pubspec.yaml` and that `flutter pub get` completed without errors. Also make sure the API server is running on `localhost:8000`. Ask the instructor for help if needed.

---

## About the Starter Project

You are continuing to develop the **Mood Tracker** app from Weeks 6--7. The starter project is the completed Week 7 app (with SQLite persistence) plus several new stub files and TODOs. It already provides:

- A `MoodEntry` model with `id`, `score`, `note`, and `createdAt` fields
- SQLite persistence via `DatabaseHelper` (fully working from Week 7)
- Riverpod state management from Week 6
- Four screens: Home, Add Mood, Mood Detail, and Statistics

Your job in this lab is to connect the app to a remote REST API by completing 7 TODOs across 4 files. The local SQLite database remains as an offline fallback.

### Project structure

| File | Purpose |
|------|---------|
| `lib/config.dart` | API base URL + temporary auth token (provided) |
| `lib/models/mood_entry.dart` | TODO 1: JSON serialization (toJson/fromJson) |
| `lib/services/api_client.dart` | TODOs 2--3, 6: HTTP client with error handling |
| `lib/services/mood_api_service.dart` | TODOs 4--5: Mood endpoint calls |
| `lib/data/mood_repository.dart` | TODO 7: API + offline fallback |
| `lib/data/database_helper.dart` | SQLite from Week 7 (no changes needed) |
| `lib/providers/` | State management — will need updates (see Part 6) |
| `lib/screens/` | UI screens (no changes needed) |

---

> **Healthcare Context: Why Networking Matters in mHealth**
>
> In real mobile health applications, networking is what turns a local tool into a clinical-grade system. Consider:
> - **Remote patient monitoring** requires that health data collected on a phone or wearable is synced to a server where clinicians can review it in real time.
> - **Clinical trial data** must be collected on participant devices and transmitted reliably to central databases for analysis. Missing data points can compromise an entire study.
> - **Network failures are common on mobile** -- patients may be in areas with poor connectivity, in hospital basements, or on airplanes. An offline fallback is not a nice-to-have, it is essential for data integrity.
> - **Server-side storage** enables research analysis, clinical dashboards, and cross-device access -- capabilities that a local-only app cannot provide.
>
> The patterns you learn today -- HTTP communication, JSON serialization, and online/offline strategies -- are the same patterns used in production mHealth systems and FDA-regulated apps.
>
> For a deeper look at the regulatory landscape, see the [mHealth Regulations Overview](../../resources/MHEALTH_REGULATIONS.md) in the course resources.

---

## API Server Setup

The Mood Tracker API is a FastAPI (Python) backend that you will connect your Flutter app to. Follow these steps to get it running on your local machine.

!!! info "Two terminals needed"
    From this point on, you will need **two terminal windows** open simultaneously: one running the API server and one for your Flutter app (or for `curl` testing). The server must stay running while you work.

### Clone or copy the API server

The API server code is provided in the course materials at `mood-tracker-api/`. Copy it to a convenient location on your machine.

### Set up the Python virtual environment

=== "macOS / Linux"

    ```bash
    cd mood-tracker-api
    python3 -m venv venv
    source venv/bin/activate
    ```

=== "Windows (Git Bash)"

    ```bash
    cd mood-tracker-api
    python -m venv venv
    source venv/Scripts/activate
    ```

### Install dependencies and start the server

```bash
pip install -r requirements.txt
uvicorn app.main:app --reload
```

> **Note:** The command is `uvicorn app.main:app` (not `uvicorn main:app` like in Week 2). This is because the API server uses a package structure with `app/main.py` instead of a single `main.py` file.

You should see:

```
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
```

### Verify the server is running

Open a **second terminal** and run:

```bash
curl http://localhost:8000/health
```

You should receive `{"status":"healthy"}`. If so, the API is ready. Leave the server terminal running.

!!! tip "Connecting from different devices"
    - **iOS Simulator / desktop:** use `http://127.0.0.1:8000`
    - **Android Emulator:** use `http://10.0.2.2:8000` (this is how the emulator accesses your machine's localhost)
    - **Physical device:** use your computer's LAN IP (e.g., `http://192.168.1.42:8000`) and start the server with `--host 0.0.0.0`

---

!!! note "From `toMap()` to `toJson()` — same pattern, different target"
    In Week 7 you implemented `toMap()` and `fromMap()` to convert Dart objects to/from `Map<String, dynamic>` for SQLite. This week you will implement `toJson()` and `fromJson()` — the exact same pattern, but serializing for JSON (API communication) instead of SQLite column maps. If you understood `toMap()`/`fromMap()`, you already know how `toJson()`/`fromJson()` works.

### API Request Lifecycle

The following diagram shows how data flows through the app when fetching mood entries. The repository tries the API first and falls back to the local database if the network is unavailable.

```mermaid
sequenceDiagram
    participant App as Flutter App
    participant Repo as MoodRepository
    participant API as REST API
    participant DB as Local SQLite

    App->>Repo: getMoods()
    Repo->>API: GET /moods
    alt Online
        API-->>Repo: 200 OK + JSON
        Repo-->>App: List<MoodEntry>
    else Offline / Error
        Repo->>DB: getMoods()
        DB-->>Repo: Local data
        Repo-->>App: List<MoodEntry> (cached)
    end
```

## Part 1: Connecting to the API Server (~15 min)

This part is a warm-up exercise that does not involve any TODOs. You will register a test user on the API server and obtain an authentication token. This connects back to the `curl` skills you practiced in Week 2.

### 1.1 Why a hardcoded token?

The `mood-tracker-api` requires a Bearer token for all authenticated endpoints. Proper authentication (login flows, token refresh, secure storage) is a significant topic that you will cover in **Week 9**. For now, you will use a temporary hardcoded token so you can focus on networking fundamentals without the complexity of auth.

### 1.2 Register a test user

Open a terminal and register a test user on the API:

=== "macOS / Linux / Git Bash"

    ```bash
    # Register a test user
    curl -X POST http://localhost:8000/auth/register \
      -H "Content-Type: application/json" \
      -d '{"email": "student@test.com", "username": "student", "password": "test123"}'
    ```

=== "Windows (PowerShell)"

    ```powershell
    # Register a test user
    curl -X POST http://localhost:8000/auth/register `
      -H "Content-Type: application/json" `
      -d '{"email": "student@test.com", "username": "student", "password": "test123"}'
    ```

You should receive a JSON response confirming the user was created. If you get an error that the email already exists, that is fine -- proceed to the next step.

### 1.3 Login and get a token

=== "macOS / Linux / Git Bash"

    ```bash
    # Login and get token
    curl -X POST http://localhost:8000/auth/login \
      -H "Content-Type: application/x-www-form-urlencoded" \
      -d "username=student@test.com&password=test123"
    ```

=== "Windows (PowerShell)"

    ```powershell
    # Login and get token
    curl -X POST http://localhost:8000/auth/login `
      -H "Content-Type: application/x-www-form-urlencoded" `
      -d "username=student@test.com&password=test123"
    ```

The response will contain an `access_token` field. Copy the token value (the long string, without the quotes).

### 1.4 Paste the token into config.dart

Open `lib/config.dart`. You will see a placeholder for `tempAuthToken`. Replace the placeholder string with the token you just copied:

```dart
const String tempAuthToken = 'paste-your-token-here';
```

Verify that `apiBaseUrl` is set to `http://localhost:8000` (or whatever address your API server is running on). The file should look like this:

```dart
// lib/config.dart
const String apiBaseUrl = 'http://localhost:8000';  // or http://10.0.2.2:8000 for Android emulator
const String tempAuthToken = 'paste-your-token-here';
```

> **Important:** This hardcoded token approach is temporary and insecure. Never ship an app with hardcoded credentials. In Week 9 you will replace this with proper JWT authentication -- login screen, secure token storage, and automatic refresh.

---

### Self-Check: Part 1

Before continuing, make sure you can answer these questions:

- [ ] You can reach the API server with `curl http://localhost:8000/health`.
- [ ] You have registered a test user and obtained an access token.
- [ ] The token is pasted into `lib/config.dart`.
- [ ] You understand why the token is hardcoded for now and that this will be replaced in Week 9.

---

## Part 2: JSON Serialization (~15 min)

!!! note "From `toMap()`/`fromMap()` to `toJson()`/`fromJson()`"
    In Week 7, you wrote `toMap()` and `fromMap()` to convert `MoodEntry` to/from SQLite-compatible maps. This week's `toJson()` and `fromJson()` follow the **exact same pattern** — they convert between Dart objects and `Map<String, dynamic>`. The only difference is the target: SQLite column names vs. API JSON field names. In many apps, `toMap()` and `toJson()` are identical.

Before your app can send and receive data over the network, your model class needs to know how to convert itself to and from JSON.

### 2.1 TODO 1: Implement toJson() and fromJson()

Open `lib/models/mood_entry.dart`. Find the `TODO 1` comment block.

You need to implement two methods:

1. **`Map<String, dynamic> toJson()`** -- Converts a `MoodEntry` instance into a JSON-compatible map.
2. **`factory MoodEntry.fromJson(Map<String, dynamic> json)`** -- Creates a `MoodEntry` from a JSON map received from the API.

??? tip "Solution"

    ```dart
    Map<String, dynamic> toJson() { // (1)!
      return {
        'id': id,
        'score': score,
        'note': note,
        'created_at': createdAt.toIso8601String(), // (2)!
      };
    }
    ```

    1. Converts this Dart `MoodEntry` object into a `Map<String, dynamic>` — the format required for JSON serialization before sending data to the API.
    2. `DateTime` objects cannot be directly represented in JSON. `toIso8601String()` converts the date to a standardized string format (e.g., `"2026-02-26T14:30:00.000"`) that the API expects.

    ```dart
    factory MoodEntry.fromJson(Map<String, dynamic> json) { // (1)!
      return MoodEntry(
        id: json['id'] as String,
        score: json['score'] as int,
        note: json['note'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String), // (2)!
      );
    }
    ```

    1. A factory constructor that parses a JSON map (from the API response) into a strongly-typed `MoodEntry` Dart object. This is the inverse of `toJson()`.
    2. The API returns dates as ISO 8601 strings (e.g., `"2026-02-26T14:30:00Z"`). `DateTime.parse()` converts that string back into a Dart `DateTime` object so you can work with it programmatically.

    **Key insight:** The field names in JSON (`created_at` with an underscore) may differ from the Dart property names (`createdAt` in camelCase). This is common when the API uses a different naming convention. The `toJson()` and `fromJson()` methods handle this translation.

??? warning "Common mistake: JSON field name mismatch"
    ```dart
    // WRONG — Dart field name doesn't match API field name
    'createdAt': createdAt.toIso8601String(),

    // CORRECT — use the API's snake_case convention
    'created_at': createdAt.toIso8601String(),
    ```
    REST APIs typically use `snake_case` for JSON keys, while Dart uses `camelCase`. Your `toJson()` must output the API's expected keys, and `fromJson()` must read them. A single typo here causes silent data loss — the field is simply `null`.

---

### Self-Check: Part 2

- [ ] `toJson()` returns a `Map<String, dynamic>` with keys matching the API contract.
- [ ] `fromJson()` is a factory constructor that parses each field from the JSON map.
- [ ] You handle the `created_at` / `createdAt` naming difference correctly.
- [ ] `DateTime` is serialized as an ISO 8601 string and parsed back with `DateTime.parse()`.

??? question "Quick check: toJson vs toMap"
    What's the difference between `toJson()` (Week 8) and `toMap()` (Week 7)?

    ??? success "Answer"
        Functionally, they're almost identical — both convert a Dart object to `Map<String, dynamic>`. The difference is the **target**: `toMap()` produces keys matching SQLite column names, while `toJson()` produces keys matching API field names. In many apps, these are the same and you can use a single method.

---

### CRUD and HTTP Methods

Before building the API client, review how standard CRUD operations map to HTTP methods in a REST API:

```mermaid
graph LR
    subgraph "CRUD ↔ HTTP Methods"
        C["Create"] -->|POST| P["/moods"]
        R["Read"] -->|GET| G["/moods"]
        U["Update"] -->|PUT| PU["/moods/{id}"]
        D["Delete"] -->|DELETE| DE["/moods/{id}"]
    end
    style C fill:#e8f5e9,stroke:#4caf50
    style R fill:#e3f2fd,stroke:#2196f3
    style U fill:#fff3e0,stroke:#ff9800
    style D fill:#ffebee,stroke:#f44336
```

## Part 3: Building the API Client (~25 min)

The API client is a reusable class that handles the low-level details of making HTTP requests -- constructing URLs, attaching headers, and checking response status codes.

### 3.1 TODO 2: Implement the GET method

Open `lib/services/api_client.dart`. Find the `TODO 2` comment block.

Implement the `get(String endpoint)` method:

1. **Construct the full URL** by combining `apiBaseUrl` from `config.dart` with the endpoint.
2. **Add headers** including the authorization token.
3. **Make the HTTP call** using `http.get()`.
4. **Check the status code** and return the response body.

??? tip "Solution"

    ```dart
    final url = Uri.parse('$baseUrl$endpoint'); // (1)!

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // (2)!
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return response.body; // (3)!
    } else {
      throw Exception('GET $endpoint failed: ${response.statusCode}');
    }
    ```

    1. `baseUrl` holds the API server address (e.g., `http://localhost:8000`). All endpoints are relative paths appended to this base, so `/moods` becomes `http://localhost:8000/moods`.
    2. The **Bearer token authentication** pattern: the word `Bearer` followed by a space and the token string. The server extracts this token to identify which user is making the request.
    3. `response.body` is the raw HTTP response as a `String`. Callers will use `jsonDecode(response.body)` to parse this string into a Dart `Map` or `List` for further processing.

### 3.2 TODO 3: Implement the POST method

Find the `TODO 3` comment block in the same file.

Implement the `post(String endpoint, Map<String, dynamic> body)` method:

1. **Construct the URL and headers** (same as GET).
2. **Make the HTTP call** using `http.post()` with `jsonEncode(body)`.
3. **Check the status code** (typically 200 or 201 for successful creation) and return the response body.

??? tip "Solution"

    ```dart
    final url = Uri.parse('$baseUrl$endpoint');

    final headers = {
      'Content-Type': 'application/json', // (1)!
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body), // (2)!
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('POST $endpoint failed: ${response.statusCode}');
    }
    ```

    1. The `Content-Type: application/json` header tells the server that the request body is formatted as JSON. Without this header, the server may reject the request or try to parse the body as a different format (e.g., form data).
    2. `jsonEncode(body)` converts the Dart `Map<String, dynamic>` into a JSON string (e.g., `{"score": 4, "note": "Feeling good"}`) that can be transmitted over HTTP as the request body.

    ==Always set Content-Type to application/json when sending JSON request bodies.==

    **Key insight:** The `Content-Type: application/json` header tells the server that the request body is JSON. Without this header, the server may reject the request or misinterpret the data. The `Authorization: Bearer <token>` header is how the server identifies who is making the request.

??? warning "Common mistake: Forgetting Content-Type header"
    ```dart
    // WRONG — server doesn't know the body is JSON
    final response = await http.post(url, body: jsonEncode(data));

    // CORRECT — tell the server what you're sending
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    ```
    Without `Content-Type: application/json`, many servers treat the body as plain text or form data and return a 400 Bad Request or 422 Unprocessable Entity error. Always set this header for JSON requests.

---

### Self-Check: Part 3

- [ ] The `get()` method constructs a full URL, attaches headers, and returns the response body.
- [ ] The `post()` method encodes the body as JSON using `jsonEncode()`.
- [ ] Both methods check the response status code and throw exceptions for non-success codes.
- [ ] Both methods include `Content-Type` and `Authorization` headers.

---

## Part 4: Implementing the Mood API Service (~20 min)

The API service sits between the API client and the rest of the app. It knows the specific endpoints and how to translate between JSON and domain objects.

### 4.1 TODO 4: Implement getMoods()

Open `lib/services/mood_api_service.dart`. Find the `TODO 4` comment block.

Implement the `getMoods()` method that fetches all mood entries from the server:

1. **Call the API client** to GET the `/moods` endpoint.
2. **Decode the JSON** response into a list.
3. **Map each JSON object** to a `MoodEntry` using your `fromJson()` factory.

??? tip "Solution"

    ```dart
    final responseBody = await apiClient.get('/moods');
    final List<dynamic> jsonList = jsonDecode(responseBody);
    return jsonList.map((json) => MoodEntry.fromJson(json)).toList();
    ```

### 4.2 TODO 5: Implement createMood() and deleteMood()

Find the `TODO 5` comment block in the same file.

1. **`createMood(int score, String? note)`** -- POST to `/moods`.
2. **`deleteMood(String id)`** -- DELETE `/moods/{id}`. This follows the same pattern as GET but uses the `delete()` method on the API client.

??? tip "Solution"

    ```dart
    // createMood
    final responseBody = await apiClient.post('/moods', {
      'score': score,
      'note': note,
    });
    return MoodEntry.fromJson(jsonDecode(responseBody));
    ```

    ```dart
    // deleteMood
    await apiClient.delete('/moods/$id'); // (1)!
    ```

    1. RESTful URL pattern: `/moods/{id}` targets a **specific resource** by its unique identifier. `GET /moods` returns all moods, but `DELETE /moods/abc-123` deletes only the mood with ID `abc-123`. This convention applies to all single-resource operations (GET one, PUT/update, DELETE).

    **Note:** The `delete()` method on the API client is provided for you. You only need to call it with the correct endpoint path.

!!! note "Additional HTTP methods"
    The `ApiClient` class also includes pre-built `put()` and `delete()` methods that follow the same pattern as `get()` and `post()`. You will use `delete()` in TODO 5. The `put()` method is available for update operations — you will use it in Week 9 or your team project.

---

### Self-Check: Part 4

- [ ] `getMoods()` fetches JSON from `/moods`, decodes it, and returns a `List<MoodEntry>`.
- [ ] `createMood()` POSTs to `/moods` with score and note, and returns the created `MoodEntry`.
- [ ] `deleteMood()` sends a DELETE request to `/moods/{id}`.
- [ ] You understand the flow: API client handles HTTP, API service handles domain logic.

---

## Part 5: Network Error Handling (~15 min)

Network requests can fail for many reasons -- the server could be down, the user could lose connectivity, or the request could time out. Robust error handling is essential, especially in healthcare apps where silent data loss is unacceptable.

### 5.1 TODO 6: Add error handling to the API client

Open `lib/services/api_client.dart`. Find the `TODO 6` comment block.

Wrap the HTTP calls in your `get()` and `post()` methods with try-catch blocks. You need to handle:

1. **`SocketException`** -- Thrown when there is no network connection (e.g., airplane mode, server unreachable). Import it from `dart:io`.
2. **General exceptions** -- Any other unexpected error during the HTTP call.
3. **Non-success status codes** -- Already handled by your status code check, but make sure it is inside the try block.

Apply the same pattern to the `post()` method.

??? tip "Solution"

    ```dart
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('GET $endpoint failed: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Network error: $e');
    }
    ```

    **Healthcare consideration:** In a production mHealth app, you would also implement retry logic, request timeouts, and detailed error logging. For a clinical trial app, you might queue failed requests and retry them when connectivity is restored to ensure no data is lost.

---

### Self-Check: Part 5

- [ ] Both `get()` and `post()` methods are wrapped in try-catch blocks.
- [ ] `SocketException` is caught separately with a user-friendly message.
- [ ] `dart:io` is imported for `SocketException`.
- [ ] You understand why different error types need different handling.

---

!!! example "Real-world mHealth: Telemedicine API patterns"
    Telehealth apps like Teladoc and Amwell use this exact architecture. A patient records blood pressure readings on their phone, which syncs to the server via REST API. The physician's dashboard polls the same API to display trends. Critical design decisions mirror this lab: **What happens when the patient's phone is offline during a reading?** (offline fallback to local storage) **What if the server is down during sync?** (retry queue with exponential backoff) **How are readings authenticated?** (Bearer tokens — Week 9). Your `MoodRepository` with online-first fallback is the foundation of every clinical data sync system.

=== "Before: Local-Only Repository (Week 7)"

    ```dart
    class MoodRepository {
      final DatabaseHelper _db;

      Future<List<MoodEntry>> getAllMoods() async {
        return await _db.getMoods();  // SQLite only
      }

      Future<void> addMood(MoodEntry entry) async {
        await _db.insertMood(entry);  // Local only
      }
    }
    ```

=== "After: Online-First with Fallback (Week 8)"

    ```dart
    class MoodRepository {
      final ApiClient _api;
      final DatabaseHelper _db;

      Future<List<MoodEntry>> getAllMoods() async {
        try {
          final moods = await _api.getMoods();  // Try server
          await _db.cacheAll(moods);            // Update cache
          return moods;
        } catch (e) {
          return await _db.getMoods();           // Fallback
        }
      }
    }
    ```

## Part 6: Online/Offline Strategy (~20 min)

This is where everything comes together. The mood repository will try the API first and fall back to the local SQLite database if the network is unavailable.

==Online-first strategy: try the network first, fall back to local data on failure.==

### 6.1 TODO 7: Update the mood repository

Open `lib/data/mood_repository.dart`. Find the `TODO 7` comment block.

Update the repository methods to follow this pattern:

1. **Try the API first.**
2. **If the API call succeeds**, optionally sync the data to the local database.
3. **If the API call fails** (e.g., network error), fall back to the local SQLite database.

Implement `getMoods()`, `addMood(int score, String? note)`, and `deleteMood()`. Apply the same try-API-then-fallback pattern to all three methods.

> **Note:** In Week 7, the repository's `addMood()` took a `MoodEntry` object. This week, it changes to take `score` and `note` separately and returns the created `MoodEntry`. This is because the API server assigns the `id` and `created_at` timestamp — we send only the user's input and get back the complete entry.

??? tip "Solution"

    For `getMoods()`:

    ```dart
    Future<List<MoodEntry>> getMoods() async {
      try { // (1)!
        // Try API first
        final moods = await moodApiService.getMoods();
        return moods;
      } catch (e) {
        // Fall back to local database
        print('API unavailable, using local data: $e');
        return await databaseHelper.getMoods(); // (2)!
      }
    }
    ```

    1. The `try/catch` implements the **online-first strategy**: attempt the network call first, and only if it throws an exception (no connectivity, server error, timeout), execute the fallback path in `catch`.
    2. **Graceful degradation** in action: when the API is unreachable, the app seamlessly falls back to locally cached data from SQLite. The user may see slightly stale data, but the app remains fully functional instead of showing an error screen.

    For `addMood(int score, String? note)`:

    ```dart
    Future<MoodEntry> addMood(int score, String? note) async {
      try {
        // Try API first
        final entry = await moodApiService.createMood(score, note);
        // Also save locally for offline access
        await databaseHelper.insertMood(entry);
        return entry;
      } catch (e) {
        // Fall back to local-only
        print('API unavailable, saving locally: $e');
        final entry = MoodEntry(
          id: uuid.v4(),
          score: score,
          note: note,
          createdAt: DateTime.now(),
        );
        await databaseHelper.insertMood(entry);
        return entry;
      }
    }
    ```

    Apply the same pattern to `deleteMood()` -- try the API, then delete locally regardless.

    **Key insight:** This "try API, fall back to local" pattern is sometimes called an **online-first strategy**. The API is the source of truth when available, but the app remains functional offline. In a production app, you would add synchronization logic to push locally-created entries to the server when connectivity returns.

??? warning "Common mistake: Swallowing errors silently"
    ```dart
    // WRONG — hiding the error completely
    try {
      return await _api.getMoods();
    } catch (e) {
      return await _db.getMoods();  // User has no idea they're offline
    }

    // BETTER — log the error and notify the user
    try {
      return await _api.getMoods();
    } catch (e) {
      debugPrint('API failed, using local data: $e');
      // Consider setting an "offline mode" flag in your state
      return await _db.getMoods();
    }
    ```
    Silently falling back to local data can confuse users — they might edit stale data thinking it's current. In production, show a subtle "offline mode" indicator so users know they're seeing cached data.

!!! warning "Breaking change: MoodNotifier.addMood()"
    Your Week 6 `addMood(int score, String? note)` created a `MoodEntry` locally with a generated `id` and `DateTime.now()`. Now that the API assigns `id` and `created_at`, the method must change:

    1. Make `addMood` async: `Future<void> addMood(int score, String? note) async`
    2. Call the repository instead of creating locally: `final entry = await _repository.addMood(score, note);`
    3. Add the API-returned entry to state: `state = [...state, entry];`
    4. Update `AddMoodScreen._submitMood()` to `await` the notifier call

    The same applies to `deleteMood()` — it should call the repository and only remove from state on success.

---

### Self-Check: Part 6

- [ ] `getMoods()` tries the API first and falls back to `databaseHelper.getMoods()`.
- [ ] `addMood()` tries the API first, saves to local DB on success, and creates a local-only entry on failure.
- [ ] `deleteMood()` tries the API first and deletes locally regardless.
- [ ] You understand the trade-offs of the online-first strategy.

??? question "Quick check: Error handling strategies"
    What are the trade-offs between online-first, offline-first, and online-only strategies?

    ??? success "Answer"
        - **Online-first** (this lab): Simple to implement, always has latest data when connected, degrades gracefully offline. Risk: stale local data.
        - **Offline-first**: Best UX — app always works instantly. Complex: requires sync logic and conflict resolution.
        - **Online-only**: Simplest code, no sync issues. Worst UX: app is useless without internet.
        - **Healthcare consideration**: For critical patient data, offline-first is often required — a nurse can't wait for Wi-Fi to record vitals.

---

## Applying This to Your Team Project

Your team project will connect to a real API. Plan your integration:

- **Map your endpoints:** List every API endpoint your app needs (GET, POST, PUT, DELETE).
- **Offline strategy:** Will your app use online-first (like this lab), offline-first, or online-only? The choice depends on your use case.
- **Error handling:** What happens when the server is unreachable? What feedback does the user see?

!!! question "Discussion: API contract"
    Review your team's backend API documentation. For each endpoint, write the Dart method signature that will call it. Does your `MoodEntry`-equivalent model need `toJson()`/`fromJson()` methods?

## Part 7: Self-Check and Summary (~10 min)

### 7.1 End-to-end verification

Walk through this complete flow to verify everything works:

1. Make sure the API server is running (`curl http://localhost:8000/health`).
2. Launch the app. The home screen should load mood entries from the API (or local DB if the server was used previously).
3. Tap the **+** button. Set a score, type a note, and tap **Save Entry**.
4. Verify the new entry appears on the home screen.
5. Check the API server directly -- the entry should exist on the server:
   ```bash
   curl -H "Authorization: Bearer YOUR_TOKEN" http://localhost:8000/moods
   ```
6. Stop the API server (++ctrl+c++ in the server terminal).
7. Try adding another mood entry. It should succeed using the local SQLite fallback.
8. Restart the API server. The app should resume using the API on the next request.

If all 8 steps work correctly, you have completed the lab.

### 7.2 Summary

| TODO | File | What you did |
|------|------|-------------|
| 1 | `models/mood_entry.dart` | Implemented `toJson()` and `factory MoodEntry.fromJson()` for API serialization. |
| 2 | `services/api_client.dart` | Implemented `get()` -- construct URL, attach headers, call `http.get()`, check status. |
| 3 | `services/api_client.dart` | Implemented `post()` -- `http.post()` with `jsonEncode(body)` and JSON headers. |
| 4 | `services/mood_api_service.dart` | Implemented `getMoods()` -- GET `/moods`, decode JSON, map to `List<MoodEntry>`. |
| 5 | `services/mood_api_service.dart` | Implemented `createMood()` (POST `/moods`) and `deleteMood()` (DELETE `/moods/{id}`). |
| 6 | `services/api_client.dart` | Added try-catch error handling with `SocketException` for network failures. |
| 7 | `data/mood_repository.dart` | Updated methods to try API first with local SQLite as offline fallback. |

### 7.3 Key concepts learned

| Concept | Key Takeaway |
|---------|--------------|
| HTTP methods | GET retrieves data, POST creates data, DELETE removes data -- the standard CRUD verbs of REST APIs. |
| JSON serialization | `toJson()` converts Dart objects to maps; `fromJson()` factory constructors parse maps back into objects. |
| URI construction | Combine a base URL with an endpoint path using `Uri.parse()` to build request URLs. |
| Headers | `Content-Type` tells the server the body format; `Authorization: Bearer` identifies the user. |
| `http` package | Flutter's standard package for making HTTP requests -- `http.get()`, `http.post()`, `http.delete()`. |
| Error handling | Catch `SocketException` for connectivity issues; check status codes for server errors. |
| Online/offline strategy | Try the API first, fall back to local storage -- keeps the app functional without connectivity. |
| Service layer | Separates HTTP mechanics (API client) from domain logic (API service) for cleaner architecture. |
| Bearer tokens | A string sent in the Authorization header to prove the caller's identity (proper auth in Week 9). |

---

### Where You Are: Course Architecture Journey

```mermaid
graph LR
    W5["Week 5<br/>StatefulWidget<br/><i>Local state only</i>"] --> W6["Week 6<br/>Riverpod<br/><i>Centralized state</i>"]
    W6 --> W7["Week 7<br/>+ SQLite<br/><i>Persistent storage</i>"]
    W7 --> W8["Week 8<br/>+ REST API<br/><i>Server sync</i>"]
    W8 --> W9["Week 9<br/>+ Auth<br/><i>Secure access</i>"]
    style W8 fill:#e8f5e9,stroke:#4caf50,stroke-width:3px
    style W5 fill:#f5f5f5,stroke:#9e9e9e
    style W6 fill:#f5f5f5,stroke:#9e9e9e
    style W7 fill:#f5f5f5,stroke:#9e9e9e
    style W9 fill:#f5f5f5,stroke:#9e9e9e
```

## What Comes Next

In **Week 9**, you will replace the hardcoded token with proper **JWT authentication**:

- A login screen where users enter their credentials.
- Secure token storage using `flutter_secure_storage`.
- Automatic token refresh when the access token expires.
- Protected routes that redirect unauthenticated users to the login screen.

The networking foundation you built today -- the API client, service layer, and error handling -- will remain at the core of the app throughout.

!!! info "Grading"
    For detailed sprint review rubrics and grading criteria, see the [Project Grading Guide](../../resources/PROJECT_GRADING.md).

---

## Troubleshooting

??? question "`SocketException: Connection refused` when the app tries to reach the API"
    The API server is not running or the URL is wrong. Check: (1) The server terminal shows `Uvicorn running on http://127.0.0.1:8000`. (2) `lib/config.dart` has the correct URL. (3) If using an **Android emulator**, the URL must be `http://10.0.2.2:8000` (not `localhost`). (4) If using a **physical device**, use your computer's LAN IP and start the server with `--host 0.0.0.0`.

??? question "API returns `401 Unauthorized`"
    Your auth token is missing or expired. Check `lib/config.dart` — the `tempAuthToken` must be a valid token obtained from the `/auth/login` endpoint. Tokens expire after 30 minutes by default. Get a new one by running the login curl command again.

??? question "`FormatException: Unexpected character` when decoding JSON"
    The API response is not valid JSON. Common causes: (1) The server returned an HTML error page instead of JSON. (2) The response body is empty. Add `print(response.body)` before `jsonDecode()` to see what the server actually returned.

??? question "Mood entries save to the server but don't appear in the app"
    Check that `getMoods()` in your API service correctly decodes the JSON list and maps each item to a `MoodEntry` using `fromJson()`. Also verify the API returns entries for your user (try `curl -H "Authorization: Bearer $TOKEN" http://localhost:8000/moods`).

??? question "The app works with the server but crashes when offline"
    Your repository's try-catch is not catching the right exceptions. Make sure the `catch` block in `getMoods()` catches all exceptions (`catch (e)`), not just specific types. The fallback should call `databaseHelper.getMoods()`.

---

!!! question "End-of-Lab Reflection"
    Take 2 minutes to reflect on today's work:

    1. **What was the hardest concept today?** (JSON serialization? HTTP methods? Error handling? Offline fallback?)
    2. **What would happen if your team app had no offline fallback?** Think about your users' context — hospital Wi-Fi, rural areas, airplane mode.
    3. **For your team project:** List 3 API endpoints your app will need (method + path + purpose).

    Write your answers in your lab notebook or discuss with your neighbor.

---

## Further Reading

- [http package on pub.dev](https://pub.dev/packages/http)
- [Flutter networking cookbook](https://docs.flutter.dev/cookbook/networking)
- [REST API design best practices](https://restfulapi.net/)
- [JSON serialization in Dart](https://docs.flutter.dev/data-and-backend/serialization/json)
