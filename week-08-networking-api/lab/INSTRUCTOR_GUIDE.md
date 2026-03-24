# Week 8 Lab: Instructor Guide

**Course:** Multiplatform Mobile Software Engineering in Practice
**Lab Duration:** 2 hours
**Topic:** Networking & API Integration
**Audience:** Familiar with Flutter widgets, Riverpod, and SQLite from Weeks 4--7

> This document is for the **instructor only**. Students use the separate `README.md` workbook.

---

## Pre-Lab Checklist

Complete these **before students arrive**:

- [ ] Verify Flutter is installed on all lab machines (`flutter doctor`)
- [ ] **Start the mood-tracker-api server** and verify it is running:
  ```bash
  cd mood-tracker-api
  uvicorn main:app --reload
  curl http://localhost:8000/health
  ```
- [ ] Create a test user account and obtain a token via curl to verify the API works:
  ```bash
  curl -X POST http://localhost:8000/auth/register \
    -H "Content-Type: application/json" \
    -d '{"email": "test@test.com", "username": "testuser", "password": "test123"}'
  curl -X POST http://localhost:8000/auth/login \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "username=test@test.com&password=test123"
  ```
  The register should return `201`, the login should return a JSON with `access_token` and `refresh_token`.
- [ ] Open the **starter** project in an IDE and run `flutter pub get` -- confirm all dependencies resolve
- [ ] Build and launch the starter app on an emulator/simulator -- confirm it compiles and shows the mood list (data loads from local SQLite)
- [ ] Open the **finished** project and confirm it builds and connects to the API successfully (this is your reference)
- [ ] Verify the `http` package is present in `pubspec.yaml`
- [ ] Open the student workbook (`README.md`) on the projector
- [ ] Have the starter project open in a second IDE window for live coding demos
- [ ] Increase IDE/terminal font size to at least 18pt for projector readability
- [ ] Have a browser tab open to the API docs at `http://localhost:8000/docs` for quick reference

### Room Setup

- Projector showing your IDE with the starter project open
- Students should have the starter project loaded and running before you begin
- **The API server must be accessible** from every student's emulator/simulator
- For Android emulators: `10.0.2.2` maps to the host machine's localhost
- For iOS simulators: `127.0.0.1` works directly
- If students do not have the starter project, they can clone or copy it from the course repository

### If Dependencies Fail to Resolve

If `flutter pub get` fails:

1. Check internet connectivity (pub.dev must be reachable)
2. Try `flutter pub cache repair`
3. If the lab network is slow, have a pre-resolved project on USB drives (copy the entire project including `.dart_tool/` and `.packages`)
4. As a last resort, the `pubspec.lock` file in the starter project should work -- delete it and re-run `flutter pub get`

---

## Timing Overview

| Time | Duration | Activity | Type |
|------|----------|----------|------|
| 0:00--0:10 | 10 min | Welcome, context setting, verify setup | Instructor talk |
| 0:10--0:25 | 15 min | Part 1: Connecting to the API Server (curl warm-up) | Follow-along |
| 0:25--0:40 | 15 min | Part 2: JSON Serialization (TODO 1) | Live coding + student work |
| 0:40--0:45 | 5 min | Break / catch-up buffer | --- |
| 0:45--1:10 | 25 min | Part 3: Building the API Client (TODOs 2--3) | Live coding + student work |
| 1:10--1:30 | 20 min | Part 4: Mood API Service (TODOs 4--5) | Live coding + student work |
| 1:30--1:35 | 5 min | Break / catch-up buffer | --- |
| 1:35--1:50 | 15 min | Part 5: Network Error Handling (TODO 6) | Live coding + student work |
| 1:50--2:00 | 10 min | Part 6: Online/Offline Strategy (TODO 7) + Wrap-up | Live coding + verification |

**Total:** 120 minutes (2 hours)

> **Pacing note:** Part 1 is a warm-up that does not involve code changes in the Flutter project -- students use curl commands in the terminal to explore the API. TODOs 2--3 and 4--5 are paired and follow similar patterns (HTTP methods, then service methods that use them). TODO 6 adds error handling to existing code. TODO 7 is conceptually important -- it introduces the online-first with offline fallback pattern that is critical for healthcare apps operating in environments with unreliable connectivity.

---

## Detailed Facilitation Guide

### 0:00--0:10 --- Welcome & Context Setting (10 min)

**Type:** Instructor talk

**What to say (talking points, not a script):**

- "Until now, our Mood Tracker has been a local-only app. Data lives in SQLite on the device. Today we connect it to a real REST API server."
- "Think about a hospital scenario: a patient logs their mood on a tablet in the waiting room. The psychiatrist needs to see those entries on their workstation during the consultation. Without networking, the data is trapped on the tablet."
- "In healthcare, connecting to a server introduces two concerns: reliability and security. What happens when the hospital Wi-Fi drops? What happens if the network connection is intercepted? We will address both."
- "The starter project has everything from Weeks 6--7: Riverpod state management, SQLite persistence, the full UI. Today we add a networking layer on top of that."
- "There are 7 TODOs across 4 files. We will also do a curl warm-up in the terminal before writing any Dart code."

**What students should be doing:**

- Opening the starter project in their IDE
- Running `flutter pub get`
- Launching the app and verifying it loads mood entries from SQLite
- Opening a terminal window alongside their IDE

**Checkpoint:** Before moving on, verify that **every student has the starter app running** and can see mood entries on the home screen. Also verify that every student has a terminal ready.

**Common pitfall:** Students who skipped Week 7 may not have a working SQLite implementation. Pair them with a neighbor, or have them use the Week 8 starter which includes a fully working Week 7 codebase.

---

### 0:10--0:25 --- Part 1: Connecting to the API Server -- Curl Warm-Up (15 min)

**Type:** Follow-along

**This part does not involve any code changes in the Flutter project.** Students interact with the API using curl commands in the terminal.

**Demo on projector:**

Open a terminal and walk through these steps:

**Step 1 -- Health check:**

```bash
curl http://localhost:8000/health
```

**Say:** "This is the simplest API call -- a GET request to the health endpoint. If you see a JSON response, the server is running."

**Step 2 -- Explore the API docs:**

Open `http://localhost:8000/docs` in a browser. Walk through the Swagger UI. Point to the `/moods` endpoints.

**Say:** "This is auto-generated documentation. Every endpoint shows the expected request format and response format. You will reference this frequently today."

**Step 3 -- Register a user:**

```bash
curl -X POST http://localhost:8000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email": "student@test.com", "username": "student", "password": "test123"}'
```

**Say:** "Registration uses JSON. Notice the Content-Type header. The server creates a user account and returns 201 Created."

> **Instructor tip:** Have each student use a unique email (e.g., `student1@test.com`, `student2@test.com`) to avoid conflicts.

**Step 4 -- Login and obtain a token:**

```bash
curl -X POST http://localhost:8000/auth/login \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=student@test.com&password=test123"
```

**Say:** "Login uses form-encoded data, not JSON. This is an OAuth2 convention -- the field is called 'username' even though we are sending an email. Copy the `access_token` from the response. You will need it in a moment."

**Step 5 -- Paste the token into config.dart:**

Have students open `lib/config.dart` and paste their access token into the `tempAuthToken` variable.

**Say:** "This is a temporary hardcoded token. In Week 9, we will replace this with proper authentication. For today, this gets us past the API's auth checks so we can focus on networking."

**Step 6 -- Test an authenticated API call:**

```bash
curl http://localhost:8000/moods \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

**Say:** "This returns an empty list because the new account has no mood entries. By the end of today, your Flutter app will be making this same request."

**Checkpoint:** "Can everyone reach the API server? Raise your hand if you got a response from the health check. Now raise your hand if you successfully logged in and got a token." If any students cannot reach the server, troubleshoot networking now before moving to code.

**Common pitfall:** Students on Android emulators using `localhost` or `127.0.0.1` will get connection refused. They need `10.0.2.2` in their `config.dart`. iOS simulator students can use `127.0.0.1`. Address this now.

---

### 0:25--0:40 --- Part 2: JSON Serialization (15 min)

**Type:** Live coding (first half) + student work (second half)

**This is the bridge between Dart objects and JSON.** Students have seen `toMap()`/`fromMap()` for SQLite. Now they write `toJson()`/`fromJson()` for the API.

#### 0:25--0:32 --- Live Demo of TODO 1 (7 min)

**Demo on projector.** Open `lib/models/mood_entry.dart`. Explain the existing code:

1. Point to `toMap()` and `fromMap()`. Say: "These convert between MoodEntry objects and SQLite maps. They use column names like 'id', 'score', 'note', 'created_at'."
2. Point to the TODO 1 comment. Say: "Now we need similar methods for the API. But the API may use different field names or types than our local database."

**Write `toJson()` live:**

```dart
// API serialization
Map<String, dynamic> toJson() {
  return {
    'score': score,
    'note': note,
  };
}
```

**Pause.** Explain:

- "Notice that `toJson()` only sends `score` and `note`. We do NOT send `id` or `createdAt` because the server assigns those automatically."
- "This is a key difference from `toMap()`, which includes all fields for SQLite storage."
- "In a healthcare app, the server typically assigns the record ID and timestamp. This prevents duplicate IDs across devices and ensures timestamps are in a consistent timezone."

**Write `fromJson()` live:**

```dart
factory MoodEntry.fromJson(Map<String, dynamic> json) {
  return MoodEntry(
    id: json['id'].toString(),
    score: json['score'] as int,
    note: json['note'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}
```

**Pause.** Explain:

- "`json['id'].toString()` -- the API returns the id as an integer, but our app uses String IDs internally. We convert to keep things consistent."
- "`DateTime.parse(json['created_at'])` -- the API returns ISO 8601 date strings. `DateTime.parse` handles this natively."
- "The field name is `'created_at'` with an underscore -- this is the API's convention (snake_case). Our Dart code uses `createdAt` (camelCase). The serialization methods handle this translation."

#### 0:32--0:40 --- Student Work on TODO 1 (8 min)

**Say:** "Complete TODO 1 now. Add both `toJson()` and `fromJson()` to the MoodEntry class. The TODO comments in the code have hints. You have 8 minutes."

**Walk around the room.** Common issues:

- Students who include `id` and `createdAt` in `toJson()` -- remind them the server assigns those
- Students who forget `toString()` on the id in `fromJson()` -- will cause type errors later
- Students who confuse `toJson()` with `toMap()` -- they are similar but serve different purposes

#### Complete TODO 1 Solution

**File:** `lib/models/mood_entry.dart`

```dart
// API serialization
Map<String, dynamic> toJson() {
  return {
    'score': score,
    'note': note,
  };
}

factory MoodEntry.fromJson(Map<String, dynamic> json) {
  return MoodEntry(
    id: json['id'].toString(),
    score: json['score'] as int,
    note: json['note'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}
```

**Checkpoint:** "Raise your hand if TODO 1 is done. The app will not change visually yet -- we need the API client before anything connects to the server."

**Common pitfall:** Students who try to test `toJson()`/`fromJson()` by running the app. These methods are not called anywhere yet. Reassure them: "We will use these in TODOs 4--5 when we build the mood API service."

---

### 0:40--0:45 --- Break / Catch-Up Buffer (5 min)

- Students who finished TODO 1: take a real break
- Students who are behind: use this time to finish
- Walk around and verify everyone has both `toJson()` and `fromJson()` in `mood_entry.dart`
- If many students are stuck, show the TODO 1 solution on the projector
- Remind students: "After the break, we start building the HTTP client. This is where the app starts talking to the server."

---

### 0:45--1:10 --- Part 3: Building the API Client (25 min)

**Type:** Live coding + student work

**This part builds the core HTTP client that all API calls will go through.** The API client handles URL construction, headers, status code checking, and JSON decoding.

#### 0:45--0:55 --- Live Demo of TODO 2 (10 min)

**Demo on projector.** Open `lib/services/api_client.dart`. Walk through the existing code:

1. Point to the `ApiException` class. Say: "This is a custom exception type. When something goes wrong with an API call, we throw this instead of a generic exception. It carries a message and an optional HTTP status code."
2. Point to the `ApiClient` class, `baseUrl`, and `_headers`. Say: "The base URL comes from `config.dart`. The headers include Content-Type and the Authorization token."
3. Point to the TODO 2 comment. Say: "We need a `get()` method that makes an HTTP GET request, checks the status code, and decodes the JSON response."

**Write the `get()` method live:**

```dart
Future<dynamic> get(String endpoint) async {
  final url = Uri.parse('$baseUrl$endpoint');
  final response = await http.get(url, headers: _headers);
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return jsonDecode(response.body);
  }
  throw ApiException(
    'GET $endpoint failed',
    statusCode: response.statusCode,
  );
}
```

**Pause after `Uri.parse`.** Explain:

- "`Uri.parse('$baseUrl$endpoint')` constructs the full URL. If `baseUrl` is `http://localhost:8000` and `endpoint` is `/moods`, the result is `http://localhost:8000/moods`."
- "We use `Uri.parse` because the `http` package requires a `Uri` object, not a raw string."

**Pause after the status check.** Explain:

- "Status codes 200--299 mean success. We check the range rather than just `== 200` because different endpoints may return 200, 201, or 204."
- "If the status code is outside that range, we throw an `ApiException`. The calling code can catch it and display an error message."
- "`jsonDecode(response.body)` converts the JSON string into a Dart `Map` or `List`. The return type is `dynamic` because we do not know the exact structure here -- the calling code will cast it."

**Say:** "This is the pattern for every HTTP method: construct the URL, make the request, check the status code, decode the response. The `post()` method in TODO 3 follows the same pattern with one addition -- a request body."

#### 0:55--1:10 --- Student Work on TODO 3 (15 min)

**Say:** "Now implement TODO 3 -- the `post()` method. It is very similar to `get()`, but it also takes a `Map<String, dynamic> body` parameter that gets JSON-encoded and sent as the request body. Follow the TODO comments. You have 15 minutes."

**Key differences to highlight before students start:**

| | GET (TODO 2) | POST (TODO 3) |
|---|---|---|
| Parameters | `endpoint` only | `endpoint` + `body` |
| HTTP method | `http.get(...)` | `http.post(...)` |
| Body | None | `jsonEncode(body)` |
| Response | Always has JSON body | May have empty body |

> **Instructor tip:** Emphasize the empty body check: `response.body.isNotEmpty ? jsonDecode(response.body) : null`. Some POST endpoints (like delete confirmations) return 204 No Content with an empty body. Calling `jsonDecode('')` would throw a FormatException.

**Walk around the room.** Common issues:

- Students who forget `body: jsonEncode(body)` -- they pass the Map directly, which the `http` package will form-encode instead of JSON-encoding
- Students who forget the empty body check -- will crash on endpoints that return empty responses
- Students who only check `response.statusCode == 200` instead of the 200--299 range

#### Complete TODO 2 Solution

**File:** `lib/services/api_client.dart`

```dart
Future<dynamic> get(String endpoint) async {
  final url = Uri.parse('$baseUrl$endpoint');
  final response = await http.get(url, headers: _headers);
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return jsonDecode(response.body);
  }
  throw ApiException(
    'GET $endpoint failed',
    statusCode: response.statusCode,
  );
}
```

#### Complete TODO 3 Solution

**File:** `lib/services/api_client.dart`

```dart
Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
  final url = Uri.parse('$baseUrl$endpoint');
  final response = await http.post(
    url,
    headers: _headers,
    body: jsonEncode(body),
  );
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return response.body.isNotEmpty ? jsonDecode(response.body) : null;
  }
  throw ApiException(
    'POST $endpoint failed',
    statusCode: response.statusCode,
  );
}
```

**Checkpoint:** "Raise your hand if TODOs 2 and 3 are done. The API client can now make GET and POST requests. Note that `delete()` and `put()` already exist in the starter code -- they follow the same pattern."

**Common pitfall:** Students who try to test the API client directly. There is nothing calling these methods yet. The next TODOs connect the mood service to the API client.

---

### 1:10--1:30 --- Part 4: Mood API Service (20 min)

**Type:** Live coding + student work

**This part builds the domain-specific service layer that uses the API client to perform mood-related operations.**

#### 1:10--1:20 --- Live Demo of TODO 4 (10 min)

**Demo on projector.** Open `lib/services/mood_api_service.dart`. Walk through the existing code:

1. Point to the `MoodApiService` class and its `_apiClient` field. Say: "This service uses the API client we just built. It does not make HTTP calls directly -- it delegates to the API client."
2. Point to the TODO 4 comment. Say: "We need a `getMoods()` method that fetches all mood entries from the API."

**Before writing the code, show the API response format on the projector.** Open `http://localhost:8000/docs` and show the `/moods` GET endpoint response schema:

```json
{
  "entries": [
    {
      "id": 1,
      "score": 8,
      "note": "Great day",
      "created_at": "2026-02-22T10:30:00"
    }
  ],
  "total": 1
}
```

**Say:** "The response is NOT a plain list. It is an object with an `entries` key that contains the list, and a `total` key. Students who try to cast the response directly to a List will get a type error."

**Write `getMoods()` live:**

```dart
Future<List<MoodEntry>> getMoods() async {
  final data = await _apiClient.get('/moods');
  final entries = data['entries'] as List;
  return entries
      .map((e) => MoodEntry.fromJson(e as Map<String, dynamic>))
      .toList();
}
```

**Pause.** Explain:

- "`data['entries']` extracts the list from the response wrapper. This is a common API pattern -- returning metadata alongside the data."
- "`.map((e) => MoodEntry.fromJson(e))` converts each JSON object into a MoodEntry using the `fromJson()` factory we wrote in TODO 1."
- "The cast `as Map<String, dynamic>` is needed because `jsonDecode` returns `List<dynamic>` -- Dart does not infer the inner type."

**Healthcare connection:** "In real healthcare APIs like FHIR, responses always include metadata -- pagination info, total counts, links to next pages. You will always need to extract the actual data from a wrapper object."

#### 1:20--1:30 --- Student Work on TODO 5 (10 min)

**Say:** "Now implement TODO 5 -- the `createMood()` and `deleteMood()` methods. `createMood()` sends a POST with score and note, then converts the response to a MoodEntry. `deleteMood()` sends a DELETE request. Follow the TODO comments. You have 10 minutes."

**Walk around the room.** Common issues:

- Students who forget to use `toJson()` -- they try to manually build the JSON map instead of using the method from TODO 1
- Students who forget to parse the response of `createMood()` with `fromJson()` -- the API returns the created entry, which is needed for the local state
- Students who are confused about the `id` parameter type in `deleteMood()` -- it is a `String` in our app but the API expects it in the URL path

#### Complete TODO 4 Solution

**File:** `lib/services/mood_api_service.dart`

```dart
Future<List<MoodEntry>> getMoods() async {
  final data = await _apiClient.get('/moods');
  final entries = data['entries'] as List;
  return entries
      .map((e) => MoodEntry.fromJson(e as Map<String, dynamic>))
      .toList();
}
```

#### Complete TODO 5 Solution

**File:** `lib/services/mood_api_service.dart`

```dart
Future<MoodEntry> createMood(int score, String? note) async {
  final data = await _apiClient.post('/moods', {
    'score': score,
    'note': note,
  });
  return MoodEntry.fromJson(data as Map<String, dynamic>);
}

Future<void> deleteMood(String id) async {
  await _apiClient.delete('/moods/$id');
}
```

**Checkpoint:** "At this point, the API service is complete. Let me verify it end-to-end." On the projector, demonstrate:

1. Show that the mood repository (or provider) in the starter still uses SQLite
2. Explain that TODO 7 will wire the API service into the repository

> **Instructor tip:** If students ask "why can we not test this yet?" -- explain that the mood_repository and mood_provider still point to the local database. TODO 7 changes the repository to use the API service. For now, the service methods exist but nothing calls them.

**Common pitfall:** Students who try to inline `MoodEntry.toJson()` inside `createMood()` instead of passing the raw score and note. The method signature takes primitives, not a MoodEntry object, because the caller may not have a fully formed MoodEntry yet (no id or timestamp).

---

### 1:30--1:35 --- Break / Catch-Up Buffer (5 min)

- Students who finished TODOs 1--5: take a real break
- Students who are behind: use this time to finish
- Walk around and verify everyone has the API client methods (TODOs 2--3) and the mood API service methods (TODOs 4--5)
- If many students are stuck on TODOs 4--5, show the solutions on the projector
- Quick check: "How many of you have all five TODOs done? Raise your hand." If less than 60%, consider spending extra time here.

---

### 1:35--1:50 --- Part 5: Network Error Handling (15 min)

**Type:** Live coding + student work

**This is where we make the app robust.** Without error handling, any network hiccup crashes the app.

#### 1:35--1:42 --- Live Demo of TODO 6 (7 min)

**Demo on projector.** Open `lib/services/api_client.dart`. Go back to the `get()` method from TODO 2.

**Say:** "Right now, if the server is unreachable, what happens? Let me show you."

**Demo the failure:** Stop the API server temporarily and try to use the app. Point to the unhandled exception in the debug console.

**Say:** "A `SocketException` crashes the app. In a hospital setting, imagine a nurse entering patient data and the Wi-Fi drops momentarily. The app should show an error message, not crash."

**Wrap the `get()` method with try-catch live:**

```dart
Future<dynamic> get(String endpoint) async {
  try {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw ApiException(
      'GET $endpoint failed',
      statusCode: response.statusCode,
    );
  } on SocketException {
    throw ApiException('No internet connection. Please check your network.');
  } on HttpException {
    throw ApiException('Server error. Please try again later.');
  } on FormatException {
    throw ApiException('Invalid response from server.');
  }
}
```

**Explain each catch clause:**

- "`SocketException` -- the device cannot reach the server at all. No internet, server down, wrong URL, firewall blocking the connection."
- "`HttpException` -- the HTTP layer itself fails. This is rare but can happen with malformed responses."
- "`FormatException` -- `jsonDecode` fails because the response is not valid JSON. This can happen if the server returns an HTML error page instead of JSON."
- "All three are converted to `ApiException` with a user-friendly message. The UI can catch `ApiException` and show the message in a SnackBar."

> **Instructor tip:** Emphasize that the `on ApiException` clause is NOT caught here. We only catch the low-level exceptions and convert them. If the status code check throws an `ApiException`, it passes through to the caller. This is intentional -- the caller can distinguish between network errors and API errors.

**Say:** "You need to add this same try-catch wrapping to ALL four HTTP methods: `get()`, `post()`, `delete()`, and `put()`. The `delete()` and `put()` methods already exist in the starter but do not have error handling."

#### 1:42--1:50 --- Student Work on TODO 6 (8 min)

**Say:** "Complete TODO 6. Wrap all four HTTP methods with the try-catch pattern I just showed. You have 8 minutes."

**Walk around the room.** Common issues:

- Students who only wrap `get()` and forget the other three methods
- Students who catch `ApiException` in the try-catch -- this swallows the status code errors instead of letting them propagate
- Students who put the try-catch in the wrong place (wrapping only the HTTP call, not the jsonDecode as well)

#### Complete TODO 6 Solution

**File:** `lib/services/api_client.dart`

The pattern is identical for all four methods. Here is the complete `get()` method with error handling (shown in the live demo above), and below are the `post()`, `delete()`, and `put()` methods with the same wrapping:

**post() with error handling:**

```dart
Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
  try {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(body),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    }
    throw ApiException(
      'POST $endpoint failed',
      statusCode: response.statusCode,
    );
  } on SocketException {
    throw ApiException('No internet connection. Please check your network.');
  } on HttpException {
    throw ApiException('Server error. Please try again later.');
  } on FormatException {
    throw ApiException('Invalid response from server.');
  }
}
```

**delete() with error handling:**

```dart
Future<void> delete(String endpoint) async {
  try {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(url, headers: _headers);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'DELETE $endpoint failed',
        statusCode: response.statusCode,
      );
    }
  } on SocketException {
    throw ApiException('No internet connection. Please check your network.');
  } on HttpException {
    throw ApiException('Server error. Please try again later.');
  } on FormatException {
    throw ApiException('Invalid response from server.');
  }
}
```

**put() with error handling:**

```dart
Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
  try {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(
      url,
      headers: _headers,
      body: jsonEncode(body),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    }
    throw ApiException(
      'PUT $endpoint failed',
      statusCode: response.statusCode,
    );
  } on SocketException {
    throw ApiException('No internet connection. Please check your network.');
  } on HttpException {
    throw ApiException('Server error. Please try again later.');
  } on FormatException {
    throw ApiException('Invalid response from server.');
  }
}
```

**Checkpoint:** "Stop the API server and try to trigger an error in the app. Instead of a crash, you should see a caught exception with a friendly message. If you still see an unhandled SocketException, you missed one of the four methods."

**Common pitfall:** Students who add a catch-all `catch (e)` block that swallows everything. This hides bugs. The try-catch should only catch the three specific exception types and let everything else propagate.

---

### 1:50--2:00 --- Part 6: Online/Offline Strategy + Wrap-Up (10 min)

**Type:** Live coding + verification

**This is the capstone TODO.** It changes the repository from local-only to API-first with local fallback.

#### 1:50--1:55 --- Live Demo of TODO 7 (5 min)

**Demo on projector.** Open `lib/repositories/mood_repository.dart`. Walk through the existing code:

**Say:** "Currently, all four methods (`getAllMoods`, `addMood`, `deleteMood`, `updateMood`) talk directly to the local SQLite database. We are going to change them to try the API first. If the API call fails -- network down, server error, timeout -- we fall back to the local database. This is the online-first with offline fallback pattern."

**Write `getAllMoods()` and `addMood()` live:**

```dart
Future<List<MoodEntry>> getAllMoods() async {
  try {
    final moods = await _apiService.getMoods();
    return moods;
  } catch (e) {
    // API failed -- fall back to local database
    final maps = await _dbHelper.getMoods();
    return maps.map((m) => MoodEntry.fromMap(m)).toList();
  }
}

Future<MoodEntry> addMood(int score, String? note) async {
  try {
    final entry = await _apiService.createMood(score, note);
    await _dbHelper.insertMood(entry.toMap());
    return entry;
  } catch (e) {
    // API failed -- save locally only
    final entry = MoodEntry(score: score, note: note);
    await _dbHelper.insertMood(entry.toMap());
    return entry;
  }
}
```

**Pause after `getAllMoods()`.** Explain:

- "The happy path: the API is reachable, we get fresh data from the server."
- "The fallback path: anything goes wrong, we load from SQLite. The user sees potentially stale data, but the app does not crash."
- "In healthcare, this is critical. A clinician reviewing patient mood history should always see something, even if the server is temporarily unreachable."

**Pause after `addMood()`.** Explain:

- "On success: we create the entry via the API, then also save it locally for offline access. The API returns the created entry with a server-assigned ID and timestamp."
- "On failure: we create a local-only entry. The data is not lost -- it lives in SQLite."
- "Notice that `addMood()` now returns a `MoodEntry` instead of `void`. The provider needs the created entry to update the local state."

**Say:** "The same pattern applies to `deleteMood()` and `updateMood()`. Implement them now -- try the API first, catch errors, then do the local operation regardless."

**Show the remaining two methods quickly:**

```dart
Future<void> deleteMood(String id) async {
  try {
    await _apiService.deleteMood(id);
  } catch (e) {
    // API failed -- continue with local delete
  }
  await _dbHelper.deleteMood(id);
}

Future<void> updateMood(MoodEntry entry) async {
  try {
    await _apiService.updateMood(entry.id, entry.score, entry.note);
  } catch (e) {
    // API failed -- continue with local update
  }
  await _dbHelper.updateMood(entry.id, entry.toMap());
}
```

**Explain the subtle difference:**

- "For `deleteMood()` and `updateMood()`, we do the local operation regardless of whether the API succeeds or fails. The `try`/`catch` only wraps the API call. The local database call happens after, outside the try-catch."
- "This means: if the API is up, both the server and local database are updated. If the API is down, only the local database is updated. The data is eventually consistent."

> **Instructor tip:** If a student asks about syncing -- "what happens when the server comes back?" -- acknowledge it is a great question. Full offline sync (queuing operations and replaying them when connectivity returns) is a complex topic beyond this lab. For now, the simple fallback is sufficient.

**Also mention the provider change:**

```dart
// In mood_provider.dart, addMood now uses the returned entry:
Future<void> addMood(int score, String? note) async {
  final entry = await _repository.addMood(score, note);
  state = [entry, ...state];
}
```

**Say:** "The provider's `addMood()` method now uses the entry returned by the repository instead of creating its own. This ensures the state reflects the server-assigned ID and timestamp."

#### Complete TODO 7 Solution

**File:** `lib/repositories/mood_repository.dart`

```dart
Future<List<MoodEntry>> getAllMoods() async {
  try {
    final moods = await _apiService.getMoods();
    return moods;
  } catch (e) {
    // API failed -- fall back to local database
    final maps = await _dbHelper.getMoods();
    return maps.map((m) => MoodEntry.fromMap(m)).toList();
  }
}

Future<MoodEntry> addMood(int score, String? note) async {
  try {
    final entry = await _apiService.createMood(score, note);
    await _dbHelper.insertMood(entry.toMap());
    return entry;
  } catch (e) {
    // API failed -- save locally only
    final entry = MoodEntry(score: score, note: note);
    await _dbHelper.insertMood(entry.toMap());
    return entry;
  }
}

Future<void> deleteMood(String id) async {
  try {
    await _apiService.deleteMood(id);
  } catch (e) {
    // API failed -- continue with local delete
  }
  await _dbHelper.deleteMood(id);
}

Future<void> updateMood(MoodEntry entry) async {
  try {
    await _apiService.updateMood(entry.id, entry.score, entry.note);
  } catch (e) {
    // API failed -- continue with local update
  }
  await _dbHelper.updateMood(entry.id, entry.toMap());
}
```

#### 1:55--2:00 --- End-to-End Verification and Wrap-Up (5 min)

**Walk students through this verification sequence:**

1. **Verify the API server is running** (`curl http://localhost:8000/health`)
2. **Launch the app** -- it should load moods from the API (the list may differ from what was in SQLite)
3. **Add a mood entry** through the app
4. **Verify on the server** via curl:
   ```bash
   curl http://localhost:8000/moods \
     -H "Authorization: Bearer YOUR_TOKEN_HERE"
   ```
   The new entry should appear in the response.
5. **Stop the API server** (Ctrl+C in the server terminal)
6. **Add another mood entry** -- it should succeed via the SQLite fallback, no crash
7. **Restart the API server** -- the app resumes using the API

**Talking points for wrap-up:**

- "You completed 7 TODOs across 4 files. The app now talks to a real API server."
- "The key architectural pattern is layered abstraction: `MoodEntry.toJson()/fromJson()` handles serialization, `ApiClient` handles HTTP mechanics, `MoodApiService` handles domain-specific endpoints, and `MoodRepository` handles the online/offline strategy."
- "The error handling pattern -- catching `SocketException`, `HttpException`, and `FormatException` and converting them to `ApiException` -- gives the UI a single exception type to handle."
- "The online-first with offline fallback pattern is fundamental to healthcare apps. Patients and clinicians need the app to work even when connectivity is unreliable."

**Preview Week 9:**

- "In Week 9, students will replace the hardcoded token with proper JWT authentication -- login screens, secure token storage, route guarding, and automatic token injection into API requests."

**Final words:**

- "If your app is not fully working, the finished project is available as a reference. Compare it with your work to find the differences."
- "The most common issues are: wrong `apiBaseUrl` in `config.dart`, API server not running, and Android emulator needing `10.0.2.2` instead of `localhost`. Check those first."

---

## Instructor Notes: Pacing & Common Issues

### Where Students Typically Get Stuck

1. **API response shape (TODO 4).** The `/moods` endpoint returns `{"entries": [...], "total": N}`, not a plain list. Students who write `final entries = data as List` will get a type error. Emphasize the wrapper object pattern and show the API docs.

2. **`toJson()` including too many fields (TODO 1).** Students instinctively include `id` and `createdAt` in `toJson()` because `toMap()` includes them. Explain that the server assigns those fields -- sending them may cause validation errors or be silently ignored.

3. **Missing `jsonEncode()` in post() (TODO 3).** Students who pass a `Map` directly to the `body` parameter get form-encoded data instead of JSON. The server responds with 422 Unprocessable Entity. Show the difference: `body: {'score': '8'}` (form-encoded) vs `body: jsonEncode({'score': 8})` (JSON).

4. **Android emulator networking.** `localhost` and `127.0.0.1` inside an Android emulator refer to the emulator itself, not the host machine. Students need `10.0.2.2`. This causes connection refused errors that look like server problems.

5. **Empty response body on POST (TODO 3).** Some endpoints return 204 No Content with an empty body. `jsonDecode('')` throws a `FormatException`. The `response.body.isNotEmpty` check prevents this.

6. **Catching ApiException in the try-catch (TODO 6).** Students who add a generic `catch (e)` or explicitly catch `ApiException` in the error handling try-catch will swallow status code errors. Only the three low-level exceptions should be caught.

### Where to Slow Down

- The explanation of API response structure in TODO 4. Show the Swagger docs, show a raw curl response, then show how `data['entries']` extracts the list.
- The difference between `toJson()`/`fromJson()` and `toMap()`/`fromMap()`. Draw a diagram showing the two paths: Dart object <-> JSON (API) and Dart object <-> Map (SQLite).
- The online/offline fallback strategy in TODO 7. Walk through both paths explicitly: "Server is up -- what happens? Server is down -- what happens?"

### Where You Can Speed Up

- Part 1 (curl warm-up) -- if students are already comfortable with APIs from other courses, shorten this to 10 minutes.
- TODO 3 (post method) -- it follows the exact same pattern as TODO 2. Point out the differences and let students work.
- TODO 6 (error handling) -- it is the same try-catch block repeated four times. Show it once, then have students apply it to all four methods independently.

### If You Are Running Out of Time

Priority order (must complete):

1. **TODO 1** -- JSON serialization. Foundation for everything else.
2. **TODOs 2--3** -- API client HTTP methods. Required for TODOs 4--5.
3. **TODOs 4--5** -- Mood API service. Required for TODO 7.
4. **TODO 7** -- Online/offline strategy. This is the payoff -- the app connects to the server.
5. **TODO 6** -- Error handling. Important for robustness but the app works without it.

Can be shortened:

- Part 1 (curl warm-up) -- skip the detailed Swagger tour, just register and get a token
- TODO 6 -- show the pattern once and assign the remaining three methods as homework
- TODO 7 -- show `getAllMoods()` live and assign the other three methods as homework

### If You Have Extra Time

- Have students implement a "refresh" button that forces a reload from the API
- Discuss HTTP caching headers (ETag, Cache-Control) and how they reduce bandwidth
- Show Postman or Insomnia as alternatives to curl for API exploration
- Discuss FHIR (Fast Healthcare Interoperability Resources) and how its API patterns compare
- Add loading indicators while waiting for API responses
- Discuss pagination -- what happens when a patient has thousands of mood entries?
- Preview the authentication flow they will implement in Week 9

---

## Complete Solutions Reference

Below are the full solutions for every TODO. Use these if you need to quickly show a solution on the projector or help a struggling student.

### TODO 1 Solution -- toJson() and fromJson()

**File:** `lib/models/mood_entry.dart`

```dart
// API serialization
Map<String, dynamic> toJson() {
  return {
    'score': score,
    'note': note,
  };
}

factory MoodEntry.fromJson(Map<String, dynamic> json) {
  return MoodEntry(
    id: json['id'].toString(),
    score: json['score'] as int,
    note: json['note'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}
```

### TODO 2 Solution -- ApiClient get() method

**File:** `lib/services/api_client.dart`

```dart
Future<dynamic> get(String endpoint) async {
  final url = Uri.parse('$baseUrl$endpoint');
  final response = await http.get(url, headers: _headers);
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return jsonDecode(response.body);
  }
  throw ApiException(
    'GET $endpoint failed',
    statusCode: response.statusCode,
  );
}
```

### TODO 3 Solution -- ApiClient post() method

**File:** `lib/services/api_client.dart`

```dart
Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
  final url = Uri.parse('$baseUrl$endpoint');
  final response = await http.post(
    url,
    headers: _headers,
    body: jsonEncode(body),
  );
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return response.body.isNotEmpty ? jsonDecode(response.body) : null;
  }
  throw ApiException(
    'POST $endpoint failed',
    statusCode: response.statusCode,
  );
}
```

### TODO 4 Solution -- MoodApiService getMoods()

**File:** `lib/services/mood_api_service.dart`

```dart
Future<List<MoodEntry>> getMoods() async {
  final data = await _apiClient.get('/moods');
  final entries = data['entries'] as List;
  return entries
      .map((e) => MoodEntry.fromJson(e as Map<String, dynamic>))
      .toList();
}
```

### TODO 5 Solution -- MoodApiService createMood() and deleteMood()

**File:** `lib/services/mood_api_service.dart`

```dart
Future<MoodEntry> createMood(int score, String? note) async {
  final data = await _apiClient.post('/moods', {
    'score': score,
    'note': note,
  });
  return MoodEntry.fromJson(data as Map<String, dynamic>);
}

Future<void> deleteMood(String id) async {
  await _apiClient.delete('/moods/$id');
}
```

### TODO 6 Solution -- Error Handling (all four HTTP methods)

**File:** `lib/services/api_client.dart`

**get() with error handling:**

```dart
Future<dynamic> get(String endpoint) async {
  try {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw ApiException(
      'GET $endpoint failed',
      statusCode: response.statusCode,
    );
  } on SocketException {
    throw ApiException('No internet connection. Please check your network.');
  } on HttpException {
    throw ApiException('Server error. Please try again later.');
  } on FormatException {
    throw ApiException('Invalid response from server.');
  }
}
```

**post() with error handling:**

```dart
Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
  try {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(body),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    }
    throw ApiException(
      'POST $endpoint failed',
      statusCode: response.statusCode,
    );
  } on SocketException {
    throw ApiException('No internet connection. Please check your network.');
  } on HttpException {
    throw ApiException('Server error. Please try again later.');
  } on FormatException {
    throw ApiException('Invalid response from server.');
  }
}
```

**delete() with error handling:**

```dart
Future<void> delete(String endpoint) async {
  try {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(url, headers: _headers);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'DELETE $endpoint failed',
        statusCode: response.statusCode,
      );
    }
  } on SocketException {
    throw ApiException('No internet connection. Please check your network.');
  } on HttpException {
    throw ApiException('Server error. Please try again later.');
  } on FormatException {
    throw ApiException('Invalid response from server.');
  }
}
```

**put() with error handling:**

```dart
Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
  try {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(
      url,
      headers: _headers,
      body: jsonEncode(body),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    }
    throw ApiException(
      'PUT $endpoint failed',
      statusCode: response.statusCode,
    );
  } on SocketException {
    throw ApiException('No internet connection. Please check your network.');
  } on HttpException {
    throw ApiException('Server error. Please try again later.');
  } on FormatException {
    throw ApiException('Invalid response from server.');
  }
}
```

### TODO 7 Solution -- Online/Offline Repository

**File:** `lib/repositories/mood_repository.dart`

```dart
Future<List<MoodEntry>> getAllMoods() async {
  try {
    final moods = await _apiService.getMoods();
    return moods;
  } catch (e) {
    // API failed -- fall back to local database
    final maps = await _dbHelper.getMoods();
    return maps.map((m) => MoodEntry.fromMap(m)).toList();
  }
}

Future<MoodEntry> addMood(int score, String? note) async {
  try {
    final entry = await _apiService.createMood(score, note);
    await _dbHelper.insertMood(entry.toMap());
    return entry;
  } catch (e) {
    // API failed -- save locally only
    final entry = MoodEntry(score: score, note: note);
    await _dbHelper.insertMood(entry.toMap());
    return entry;
  }
}

Future<void> deleteMood(String id) async {
  try {
    await _apiService.deleteMood(id);
  } catch (e) {
    // API failed -- continue with local delete
  }
  await _dbHelper.deleteMood(id);
}

Future<void> updateMood(MoodEntry entry) async {
  try {
    await _apiService.updateMood(entry.id, entry.score, entry.note);
  } catch (e) {
    // API failed -- continue with local update
  }
  await _dbHelper.updateMood(entry.id, entry.toMap());
}
```

**Provider update** (mood_provider.dart -- the `addMood` method changes):

```dart
Future<void> addMood(int score, String? note) async {
  final entry = await _repository.addMood(score, note);
  state = [entry, ...state];
}
```

---

## End-of-Lab Assessment

### Wrap-Up and Verification

Walk students through this final verification sequence:

1. Verify the API server is running (`curl http://localhost:8000/health`)
2. Launch the app -- it should load moods from the API
3. Add a mood entry through the app
4. Check the server via curl to confirm the entry was created
5. Stop the API server (Ctrl+C)
6. Add another mood entry -- it should work via the SQLite fallback with no crash
7. Restart the API server
8. The app resumes using the API on the next load

### Recovery Strategies

If students encounter issues during verification:

- **API connection fails:** Check `apiBaseUrl` in `config.dart`. For Android emulators, use `10.0.2.2`. For iOS simulators, use `127.0.0.1`. For physical devices, use the computer's LAN IP address.
- **401 Unauthorized errors:** The token has expired. Re-login via curl and update the token in `config.dart`.
- **422 Unprocessable Entity errors:** The request body does not match the expected JSON schema. Check the API docs at `http://localhost:8000/docs` and compare with the request being sent. Common cause: sending form-encoded data instead of JSON, or missing required fields.
- **Connection refused on Android emulator:** The emulator uses `10.0.2.2` to reach the host machine's localhost, not `localhost` or `127.0.0.1`.

### Minimum Completion Checklist

Every student should leave the lab with:

- [ ] TODO 1 -- `toJson()` and `fromJson()` methods on `MoodEntry`
- [ ] TODOs 2--3 -- `get()` and `post()` HTTP methods in `ApiClient`
- [ ] TODOs 4--5 -- `getMoods()`, `createMood()`, and `deleteMood()` in `MoodApiService`
- [ ] TODO 6 -- Error handling with try-catch on all four HTTP methods
- [ ] TODO 7 -- Online/offline fallback strategy in `MoodRepository`

### Common Errors Reference

| Error | Cause | Fix |
|-------|-------|-----|
| `SocketException: Connection refused` | API server not running or wrong URL | Start the server; check `apiBaseUrl` in `config.dart` |
| `SocketException: Connection refused` (Android only) | Emulator using `localhost` instead of `10.0.2.2` | Change `apiBaseUrl` to use `10.0.2.2` |
| `401 Unauthorized` | Token expired or invalid | Re-login via curl and update `tempAuthToken` in `config.dart` |
| `422 Unprocessable Entity` | Request body does not match API schema | Check Content-Type header; ensure `jsonEncode()` is used for JSON bodies |
| `FormatException: Unexpected character` | Trying to `jsonDecode` an empty or non-JSON response | Add `response.body.isNotEmpty` check before decoding |
| `type '_Map<String, dynamic>' is not a subtype of type 'List<dynamic>'` | Treating the API response object as a plain list | Extract `data['entries']` before mapping; the response is a wrapper object |

### What Comes Next

"In Week 9, students will replace the hardcoded token with proper JWT authentication. They will implement login and registration screens, secure token storage using `flutter_secure_storage`, an auth state machine, dynamic token injection into API requests, and route guarding so unauthenticated users see a login screen instead of the home screen."

### For Students Who Did Not Finish

- Reassure them: "The finished project is available as a reference. Compare it with your work to find the differences."
- Minimum viable: TODOs 1--5 (the app can make API calls). TODOs 6--7 can be finished at home.
- Remind them that Week 9 builds directly on this networking foundation -- they should have a working API integration by then.
- Point them to the [http package documentation](https://pub.dev/packages/http) and the [Dart JSON guide](https://dart.dev/guides/json) for additional learning.
