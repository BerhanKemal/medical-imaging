# Week 8 Lab: Networking & API Integration

> **Course:** Mobile Apps for Healthcare
> **Duration:** ~2 hours
> **Prerequisites:** Week 7 Local Data (working Mood Tracker with SQLite persistence)

---

## Learning Objectives

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
- **The mood-tracker-api server running locally.** Verify by running:
  ```bash
  curl http://localhost:8000/health
  ```
  You should receive a JSON response confirming the server is up. If the server is not running, follow the setup instructions provided by the instructor.
- **The starter project** loaded in your IDE:
  ```
  week-08-networking-api/lab/starter/mood_tracker/
  ```
  Open this folder and run `flutter pub get` to resolve dependencies. Verify the app builds and launches before starting the exercises.

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
| `lib/providers/` | State management from Week 6 (no changes needed) |
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

---

## Part 1: Connecting to the API Server (~15 min)

This part is a warm-up exercise that does not involve any TODOs. You will register a test user on the API server and obtain an authentication token. This connects back to the `curl` skills you practiced in Week 2.

### 1.1 Why a hardcoded token?

The `mood-tracker-api` requires a Bearer token for all authenticated endpoints. Proper authentication (login flows, token refresh, secure storage) is a significant topic that you will cover in **Week 9**. For now, you will use a temporary hardcoded token so you can focus on networking fundamentals without the complexity of auth.

### 1.2 Register a test user

Open a terminal and register a test user on the API:

```bash
# Register a test user
curl -X POST http://localhost:8000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email": "student@test.com", "username": "student", "password": "test123"}'
```

You should receive a JSON response confirming the user was created. If you get an error that the email already exists, that is fine -- proceed to the next step.

### 1.3 Login and get a token

```bash
# Login and get token
curl -X POST http://localhost:8000/auth/login \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=student@test.com&password=test123"
```

The response will contain an `access_token` field. Copy the token value (the long string, without the quotes).

### 1.4 Paste the token into config.dart

Open `lib/config.dart`. You will see a placeholder for `tempAuthToken`. Replace the placeholder string with the token you just copied:

```dart
const String tempAuthToken = 'paste-your-token-here';
```

Verify that `apiBaseUrl` is set to `http://localhost:8000` (or whatever address your API server is running on).

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

Before your app can send and receive data over the network, your model class needs to know how to convert itself to and from JSON.

### 2.1 TODO 1: Implement toJson() and fromJson()

Open `lib/models/mood_entry.dart`. Find the `TODO 1` comment block.

You need to implement two methods:

1. **`Map<String, dynamic> toJson()`** -- Converts a `MoodEntry` instance into a JSON-compatible map:
   ```dart
   Map<String, dynamic> toJson() {
     return {
       'id': id,
       'score': score,
       'note': note,
       'created_at': createdAt.toIso8601String(),
     };
   }
   ```

2. **`factory MoodEntry.fromJson(Map<String, dynamic> json)`** -- Creates a `MoodEntry` from a JSON map received from the API:
   ```dart
   factory MoodEntry.fromJson(Map<String, dynamic> json) {
     return MoodEntry(
       id: json['id'] as String,
       score: json['score'] as int,
       note: json['note'] as String?,
       createdAt: DateTime.parse(json['created_at'] as String),
     );
   }
   ```

> **Key insight:** The field names in JSON (`created_at` with an underscore) may differ from the Dart property names (`createdAt` in camelCase). This is common when the API uses a different naming convention. The `toJson()` and `fromJson()` methods handle this translation.

---

### Self-Check: Part 2

- [ ] `toJson()` returns a `Map<String, dynamic>` with keys matching the API contract.
- [ ] `fromJson()` is a factory constructor that parses each field from the JSON map.
- [ ] You handle the `created_at` / `createdAt` naming difference correctly.
- [ ] `DateTime` is serialized as an ISO 8601 string and parsed back with `DateTime.parse()`.

---

## Part 3: Building the API Client (~25 min)

The API client is a reusable class that handles the low-level details of making HTTP requests -- constructing URLs, attaching headers, and checking response status codes.

### 3.1 TODO 2: Implement the GET method

Open `lib/services/api_client.dart`. Find the `TODO 2` comment block.

Implement the `get(String endpoint)` method:

1. **Construct the full URL** by combining `apiBaseUrl` from `config.dart` with the endpoint:
   ```dart
   final url = Uri.parse('$baseUrl$endpoint');
   ```

2. **Add headers** including the authorization token:
   ```dart
   final headers = {
     'Content-Type': 'application/json',
     'Authorization': 'Bearer $token',
   };
   ```

3. **Make the HTTP call** using `http.get()`:
   ```dart
   final response = await http.get(url, headers: headers);
   ```

4. **Check the status code** and return the response body:
   ```dart
   if (response.statusCode == 200) {
     return response.body;
   } else {
     throw Exception('GET $endpoint failed: ${response.statusCode}');
   }
   ```

### 3.2 TODO 3: Implement the POST method

Find the `TODO 3` comment block in the same file.

Implement the `post(String endpoint, Map<String, dynamic> body)` method:

1. **Construct the URL and headers** (same as GET).

2. **Make the HTTP call** using `http.post()` with `jsonEncode(body)`:
   ```dart
   final response = await http.post(
     url,
     headers: headers,
     body: jsonEncode(body),
   );
   ```

3. **Check the status code** (typically 200 or 201 for successful creation) and return the response body.

> **Key insight:** The `Content-Type: application/json` header tells the server that the request body is JSON. Without this header, the server may reject the request or misinterpret the data. The `Authorization: Bearer <token>` header is how the server identifies who is making the request.

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

1. **Call the API client** to GET the `/moods` endpoint:
   ```dart
   final responseBody = await apiClient.get('/moods');
   ```

2. **Decode the JSON** response into a list:
   ```dart
   final List<dynamic> jsonList = jsonDecode(responseBody);
   ```

3. **Map each JSON object** to a `MoodEntry` using your `fromJson()` factory:
   ```dart
   return jsonList.map((json) => MoodEntry.fromJson(json)).toList();
   ```

### 4.2 TODO 5: Implement createMood() and deleteMood()

Find the `TODO 5` comment block in the same file.

1. **`createMood(int score, String? note)`** -- POST to `/moods`:
   ```dart
   final responseBody = await apiClient.post('/moods', {
     'score': score,
     'note': note,
   });
   return MoodEntry.fromJson(jsonDecode(responseBody));
   ```

2. **`deleteMood(String id)`** -- DELETE `/moods/{id}`. This follows the same pattern as GET but uses the `delete()` method on the API client:
   ```dart
   await apiClient.delete('/moods/$id');
   ```

> **Note:** The `delete()` method on the API client is provided for you. You only need to call it with the correct endpoint path.

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

Wrap the HTTP calls in your `get()` and `post()` methods with try-catch blocks:

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

You need to handle:

1. **`SocketException`** -- Thrown when there is no network connection (e.g., airplane mode, server unreachable). Import it from `dart:io`.
2. **General exceptions** -- Any other unexpected error during the HTTP call.
3. **Non-success status codes** -- Already handled by your status code check, but make sure it is inside the try block.

Apply the same pattern to the `post()` method.

> **Healthcare consideration:** In a production mHealth app, you would also implement retry logic, request timeouts, and detailed error logging. For a clinical trial app, you might queue failed requests and retry them when connectivity is restored to ensure no data is lost.

---

### Self-Check: Part 5

- [ ] Both `get()` and `post()` methods are wrapped in try-catch blocks.
- [ ] `SocketException` is caught separately with a user-friendly message.
- [ ] `dart:io` is imported for `SocketException`.
- [ ] You understand why different error types need different handling.

---

## Part 6: Online/Offline Strategy (~20 min)

This is where everything comes together. The mood repository will try the API first and fall back to the local SQLite database if the network is unavailable.

### 6.1 TODO 7: Update the mood repository

Open `lib/data/mood_repository.dart`. Find the `TODO 7` comment block.

Update the repository methods to follow this pattern:

1. **Try the API first.**
2. **If the API call succeeds**, optionally sync the data to the local database.
3. **If the API call fails** (e.g., network error), fall back to the local SQLite database.

For `getMoods()`:

```dart
Future<List<MoodEntry>> getMoods() async {
  try {
    // Try API first
    final moods = await moodApiService.getMoods();
    return moods;
  } catch (e) {
    // Fall back to local database
    print('API unavailable, using local data: $e');
    return await databaseHelper.getMoods();
  }
}
```

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

> **Key insight:** This "try API, fall back to local" pattern is sometimes called an **online-first strategy**. The API is the source of truth when available, but the app remains functional offline. In a production app, you would add synchronization logic to push locally-created entries to the server when connectivity returns.

---

### Self-Check: Part 6

- [ ] `getMoods()` tries the API first and falls back to `databaseHelper.getMoods()`.
- [ ] `addMood()` tries the API first, saves to local DB on success, and creates a local-only entry on failure.
- [ ] `deleteMood()` tries the API first and deletes locally regardless.
- [ ] You understand the trade-offs of the online-first strategy.

---

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
6. Stop the API server (Ctrl+C in the server terminal).
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

## What Comes Next

In **Week 9**, you will replace the hardcoded token with proper **JWT authentication**:

- A login screen where users enter their credentials.
- Secure token storage using `flutter_secure_storage`.
- Automatic token refresh when the access token expires.
- Protected routes that redirect unauthenticated users to the login screen.

The networking foundation you built today -- the API client, service layer, and error handling -- will remain at the core of the app throughout.

---

## Further Reading

- [http package on pub.dev](https://pub.dev/packages/http)
- [Flutter networking cookbook](https://docs.flutter.dev/cookbook/networking)
- [REST API design best practices](https://restfulapi.net/)
- [JSON serialization in Dart](https://docs.flutter.dev/data-and-backend/serialization/json)
