# Week 9 Lab: Instructor Guide

**Course:** Multiplatform Mobile Software Engineering in Practice
**Lab Duration:** 2 hours
**Topic:** Authentication & Security
**Audience:** Familiar with Flutter widgets, Riverpod, SQLite, and API networking from Weeks 4--8

> This document is for the **instructor only**. Students use the separate `README.md` workbook.

---

## Pre-Lab Checklist

Complete these **before students arrive**:

- [ ] Verify Flutter is installed on all lab machines (`flutter doctor`)
- [ ] **Start the mood-tracker-api server** and verify it is running:
  ```bash
  cd mood-tracker-api
  uvicorn main:app --reload
  curl http://localhost:8000/docs
  ```
- [ ] Create a test user account via curl to verify the API auth endpoints work:
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
- [ ] Build and launch the starter app on an emulator/simulator -- confirm it compiles (it will show HomeScreen directly since auth is not yet wired)
- [ ] Open the **finished** project and confirm it builds and runs correctly (this is your reference)
- [ ] Verify `flutter_secure_storage` package is present in `pubspec.yaml` (version 9.x)
- [ ] Verify `http` package is present in `pubspec.yaml`
- [ ] Open the student workbook (`README.md`) on the projector
- [ ] Have the starter project open in a second IDE window for live coding demos
- [ ] Increase IDE/terminal font size to at least 18pt for projector readability
- [ ] Have a browser tab open to the API docs at `http://localhost:8000/docs` for quick reference

### Room Setup

- Projector showing your IDE with the starter project open
- Students should have the starter project loaded and running before you begin
- **All students must have a working Week 8 codebase** as the starting point
- If students do not have the starter project, they can clone or copy it from the course repository
- **The API server must be accessible** from every student's emulator/simulator. For Android emulators, `10.0.2.2` maps to the host machine's localhost. For iOS simulators, `127.0.0.1` works directly.

### If Dependencies Fail to Resolve

If `flutter pub get` fails:

1. Check internet connectivity (pub.dev must be reachable)
2. Try `flutter pub cache repair`
3. If the lab network is slow, have a pre-resolved project on USB drives (copy the entire project including `.dart_tool/` and `.packages`)
4. As a last resort, the `pubspec.lock` file in the starter project should work -- delete it and re-run `flutter pub get`

### If FlutterSecureStorage Fails on Android Emulator

`flutter_secure_storage` requires API level 23+ (Android 6.0). If students see `Unhandled Exception: PlatformException`, check that their emulator runs API 23 or higher. For iOS simulators, no special configuration is needed.

---

## Timing Overview

| Time | Duration | Activity | Type |
|------|----------|----------|------|
| 0:00--0:10 | 10 min | Welcome, context setting, verify setup | Instructor talk |
| 0:10--0:20 | 10 min | Part 1: Understanding Auth in Mobile Apps | Instructor talk + discussion |
| 0:20--0:35 | 15 min | Part 2: Secure Token Storage (TODO 1) | Live coding + student work |
| 0:35--0:55 | 20 min | Part 3: Login & Register Services (TODOs 2--3) | Live coding + student work |
| 0:55--1:00 | 5 min | Break / catch-up buffer | --- |
| 1:00--1:15 | 15 min | Part 4: Auth State Management (TODO 4) | Live coding + student work |
| 1:15--1:25 | 10 min | Part 5: Dynamic Token Injection (TODO 5) | Follow-along |
| 1:25--1:40 | 15 min | Part 6: Connecting UI to Auth (TODO 6) | Student work |
| 1:40--1:55 | 15 min | Part 7: Route Guarding & Auto-Login (TODO 7) | Live coding + student work |
| 1:55--2:00 | 5 min | End-to-end verification + wrap-up | Summary |

**Total:** 120 minutes (2 hours)

> **Pacing note:** TODOs 1--3 are in the same file (`auth_service.dart`) and follow a straightforward pattern. Students should move through them relatively quickly. TODO 4 (the state machine) and TODO 7 (route guarding) are the most conceptually challenging. If students struggle with TODO 4, use the break to help them catch up. TODO 5 is mechanical (replace getter with async method, update call sites) and can be done quickly.

---

## Detailed Facilitation Guide

### 0:00--0:10 --- Welcome & Context Setting (10 min)

**Type:** Instructor talk

**What to say (talking points, not a script):**

- "Last week you connected the Mood Tracker to a REST API. The app sent requests with a hardcoded token from `config.dart`. Today we replace that with real authentication."
- "Think about what happens in a real health app if someone steals the auth token -- they can read all the patient's mood entries, modify them, or delete them. In healthcare, this is not just a bug, it is a HIPAA violation."
- "We are going to implement three things: (1) secure token storage so tokens are encrypted at rest, (2) login and registration API calls, and (3) route guarding so unauthenticated users cannot access the app."
- "There are 7 TODOs across 5 files. The pattern is: store tokens securely, call auth APIs, manage auth state, inject tokens into requests, wire the UI, and guard routes."

**What students should be doing:**

- Opening the starter project in their IDE
- Running `flutter pub get`
- Launching the app (it should show the HomeScreen directly since auth is not yet wired)
- Verifying they can reach the API server (check `config.dart` for the correct base URL)

**Checkpoint:** Before moving on, verify that **every student has the starter app running** and that the **API server is accessible** from their emulator/simulator. Have them test by checking if the existing mood loading works (even with the hardcoded token, if they pasted one from Week 8).

**Common pitfall:** Students on Android emulators need `10.0.2.2` as the API host, not `localhost` or `127.0.0.1`. Students on iOS simulators can use `127.0.0.1`. Students on physical devices need the computer's LAN IP.

---

### 0:10--0:20 --- Part 1: Understanding Auth in Mobile Apps (10 min)

**Type:** Instructor talk + discussion

**Demo on projector:**

Open the starter project and walk through the problem:

1. Open `config.dart`. Point to `tempAuthToken`. Say: "This is how we authenticated in Week 8 -- a hardcoded string that anyone can read in the source code. This is obviously not acceptable for a real app."
2. Open `api_client.dart`. Point to the `_headers` getter. Say: "Every API request sends this hardcoded token. What happens when the token expires? What happens when a different user wants to log in?"
3. Open `login_screen.dart`. Point to the placeholder `_login()` method. Say: "The UI is already built -- there's a beautiful login form. But pressing Sign In does nothing useful. We need to connect it to real authentication."

**Key concepts to explain:**

- **JWT tokens:** Access token (short-lived, sent with every request) and refresh token (long-lived, used to get new access tokens)
- **Secure storage:** `SharedPreferences` = plaintext file on disk. `FlutterSecureStorage` = OS keychain (iOS) or EncryptedSharedPreferences (Android). For tokens, always use encrypted storage.
- **Auth state machine:** The app has four states: `initial` (just started), `loading` (checking/logging in), `authenticated` (show HomeScreen), `unauthenticated` (show LoginScreen)

**Draw on the whiteboard:**

```
                    App Launch
                        |
                   [initial]
                        |
                  checkAuth()
                   /         \
           token found     no token
                |               |
        [authenticated]  [unauthenticated]
                |               |
            HomeScreen      LoginScreen
```

**Discussion question:** "Why is it dangerous to store auth tokens in SharedPreferences on a healthcare app?" Expected answers: plaintext storage, anyone with device access can read them, rooted devices expose all preferences, backup extraction tools, HIPAA violations.

---

### 0:20--0:35 --- Part 2: Secure Token Storage (15 min)

**Type:** Live coding (first half) + student work (second half)

#### 0:20--0:28 --- Live Demo of TODO 1 (8 min)

**Demo on projector.** Open `lib/services/auth_service.dart`. Walk through the existing code:

1. Point to `FlutterSecureStorage _storage`. Say: "This is already created for us. It wraps the OS keychain on iOS and EncryptedSharedPreferences on Android."
2. Point to the key constants. Say: "These are the storage keys. Think of them like SharedPreferences keys, but the values are encrypted."
3. Write the four methods live:

```dart
Future<void> saveTokens(String accessToken, String refreshToken) async {
  await _storage.write(key: _accessTokenKey, value: accessToken);
  await _storage.write(key: _refreshTokenKey, value: refreshToken);
}

Future<String?> getAccessToken() async {
  return await _storage.read(key: _accessTokenKey);
}

Future<String?> getRefreshToken() async {
  return await _storage.read(key: _refreshTokenKey);
}

Future<void> deleteTokens() async {
  await _storage.delete(key: _accessTokenKey);
  await _storage.delete(key: _refreshTokenKey);
}
```

**Explain after writing:**
- "All methods are `async` because encrypted storage requires platform channel communication"
- "`getAccessToken()` returns `String?` -- it may be `null` if the user has never logged in or has logged out"
- "`deleteTokens()` is what we will call during logout"

#### 0:28--0:35 --- Student Work (7 min)

**Say:** "Complete TODO 1 now. Uncomment the method scaffolds and fill them in. You have 7 minutes."

**Walk around the room.** This is straightforward -- most students should finish quickly.

**Common pitfall:** Students who forget `await` before `_storage.write()`. The methods will still compile (they just return a `Future<void>` that nobody awaits), but the tokens may not be saved before the next line executes.

**Checkpoint:** "Raise your hand if TODO 1 is done. The methods should compile. We cannot test them yet because we have no way to call them -- that comes in TODO 2."

---

### 0:35--0:55 --- Part 3: Login & Register Services (20 min)

**Type:** Live coding + student work

#### 0:35--0:45 --- Live Demo of TODO 2 (10 min)

**Demo on projector.** Stay in `lib/services/auth_service.dart`. Write the `login()` method:

```dart
Future<void> login(String email, String password) async {
  final url = Uri.parse('$apiBaseUrl/auth/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {
      'username': email, // OAuth2 convention: email goes in 'username'
      'password': password,
    },
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    await saveTokens(
      data['access_token'] as String,
      data['refresh_token'] as String,
    );
  } else if (response.statusCode == 401) {
    throw AuthException('Incorrect email or password.');
  } else {
    throw AuthException('Login failed. Please try again.');
  }
}
```

**Pause after the headers line.** Explain:

- "Notice the Content-Type is `application/x-www-form-urlencoded`, NOT `application/json`. This is the OAuth2 specification for the password grant."
- "When the body is a `Map<String, String>` and the Content-Type is form-encoded, the `http` package automatically encodes it as `key=value&key=value`."
- Show the API docs on the projector (`http://localhost:8000/docs`) to show the `/auth/login` endpoint expects form data.

**Pause after the body.** Explain:

- "The field name is `'username'`, but we pass the email. This is an OAuth2 convention. The OAuth2 spec defines a `username` field, and our API uses the email as the username."
- "This is a real-world gotcha. Students who send `'email': email` will get a 422 error from the API."

**Pause after saveTokens.** Explain:

- "On success, we parse the JSON response and store both tokens. The tokens are now encrypted in the OS keychain."
- "We do NOT return the tokens. The calling code does not need them directly -- it will read them from secure storage when needed."

#### 0:45--0:55 --- Student Work on TODO 3 (10 min)

**Say:** "Now implement TODO 3 -- the `register()` method. This one uses JSON instead of form-encoded data. Follow the TODO comments. You have 10 minutes."

**Key differences to highlight before students start:**

| | Login (TODO 2) | Register (TODO 3) |
|---|---|---|
| Content-Type | `application/x-www-form-urlencoded` | `application/json` |
| Body encoding | `Map<String, String>` (auto-encoded) | `jsonEncode(Map)` |
| Success status | `200` | `201` |
| On success | Store tokens | Return (no tokens) |
| Fields | `username`, `password` | `email`, `username`, `password` |

**Walk around the room.** Common issues:
- Using form-encoded for register (should be JSON)
- Forgetting `jsonEncode()` for the body
- Expecting a `200` instead of `201` for successful registration
- Trying to store tokens after registration (register does not return tokens)

#### TODO 3 Solution

```dart
Future<void> register(String email, String username, String password) async {
  final url = Uri.parse('$apiBaseUrl/auth/register');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'username': username,
      'password': password,
    }),
  );
  if (response.statusCode == 201) {
    return; // Registration successful, user can now login
  } else if (response.statusCode == 400) {
    final data = jsonDecode(response.body);
    throw AuthException(data['detail'] as String);
  } else {
    throw AuthException('Registration failed. Please try again.');
  }
}
```

**Checkpoint:** "TODOs 1--3 are all in `auth_service.dart`. Raise your hand if all three are done. We cannot test yet because nothing calls these methods. That changes with TODO 4."

**Common pitfall:** Students who try to run the app after TODO 3. The app will compile and run, but the auth service is not connected to anything yet. The app still shows HomeScreen with the hardcoded token.

---

### 0:55--1:00 --- Break / Catch-Up Buffer (5 min)

- Students who finished TODOs 1--3: take a real break
- Students who are behind: use this time to finish
- Walk around and verify everyone has the three methods in `auth_service.dart`
- If many students are stuck, show the TODO 3 solution on the projector

---

### 1:00--1:15 --- Part 4: Auth State Management (15 min)

**Type:** Live coding + student work

**This is the most conceptually challenging part.** Students need to understand the state machine pattern.

#### 1:00--1:10 --- Live Demo of TODO 4 (10 min)

**Demo on projector.** Open `lib/providers/auth_provider.dart`. Walk through the existing code:

1. Point to the `AuthState` enum. Say: "These are our four states. The app starts in `initial`, transitions to `loading` during login, then lands on `authenticated` or `unauthenticated`."
2. Write the `AuthNotifier` class live:

```dart
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState.initial);

  Future<void> checkAuth() async {
    final token = await _authService.getAccessToken();
    if (token != null) {
      state = AuthState.authenticated;
    } else {
      state = AuthState.unauthenticated;
    }
  }

  Future<void> login(String email, String password) async {
    state = AuthState.loading;
    try {
      await _authService.login(email, password);
      state = AuthState.authenticated;
    } on AuthException {
      state = AuthState.unauthenticated;
      rethrow;
    }
  }

  Future<void> register(String email, String username, String password) async {
    state = AuthState.loading;
    try {
      await _authService.register(email, username, password);
      await _authService.login(email, password);
      state = AuthState.authenticated;
    } on AuthException {
      state = AuthState.unauthenticated;
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.deleteTokens();
    state = AuthState.unauthenticated;
  }
}
```

**Pause after `checkAuth()`.** Explain:

- "This is called when the app starts. It checks if there is a stored token. If yes, the user is already logged in. If no, show the login screen."
- "Notice we do NOT validate the token with the server here. For a production app, you might want to make a lightweight API call to verify the token is still valid."

**Pause after `login()`.** Explain:

- "`state = AuthState.loading` first -- this triggers the UI to show a loading indicator."
- "If `_authService.login()` succeeds, state becomes `authenticated`. The UI will react and show HomeScreen."
- "`rethrow` is critical. The state notifier handles the state transition (to `unauthenticated`), but rethrows the exception so the LoginScreen can catch it and show the error message in a SnackBar."

**Pause after `register()`.** Explain:

- "After successful registration, we immediately call `login()` to log the user in. This is a UX convenience -- the user does not have to type credentials twice."
- "Two `await` calls in sequence: first register, then login. If either fails, the catch block handles it."

**Then uncomment the `authProvider` definition:**

```dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});
```

**Explain:** "`ref.read(authServiceProvider)` provides the `AuthService` instance to the notifier. This is dependency injection via Riverpod."

#### 1:10--1:15 --- Student Work (5 min)

**Say:** "Complete TODO 4. Uncomment the class scaffold, fill in the methods, and uncomment the `authProvider`. You have 5 minutes."

**Walk around the room.** Most students should be able to follow the pattern from the live demo.

**Common pitfall:** Students who forget to uncomment `authProvider` at the bottom. Without it, TODO 6 and 7 will not compile.

**Checkpoint:** "Raise your hand if TODO 4 is done and the `authProvider` is uncommented."

---

### 1:15--1:25 --- Part 5: Dynamic Token Injection (10 min)

**Type:** Follow-along (everyone together)

#### TODO 5 Demo (5 min)

**Demo on projector.** Open `lib/services/api_client.dart`:

**Step 1 -- Replace the getter:**

**Before:**
```dart
Map<String, String> get _headers => {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tempAuthToken',
    };
```

**After:**
```dart
Future<Map<String, String>> _getHeaders() async {
  final token = await _authService.getAccessToken();
  return {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };
}
```

**Explain:**
- "We replaced a synchronous getter with an async method because reading from secure storage is async."
- "The `if (token != null)` is a Dart collection-if. If the user is not logged in, we simply omit the Authorization header."
- "This completely removes the dependency on `tempAuthToken` from `config.dart`."

**Step 2 -- Update all HTTP methods. Show one example:**

**Before:**
```dart
final response = await http.get(url, headers: _headers);
```

**After:**
```dart
final headers = await _getHeaders();
final response = await http.get(url, headers: headers);
```

**Say:** "The same change applies to all four methods: `get`, `post`, `delete`, `put`. Replace `_headers` with `await _getHeaders()` in each one."

#### Student Work (5 min)

**Have every student make these changes.** Walk around to verify.

**What to watch for:**
- Students who only update one or two HTTP methods and forget the others
- Students who forget `await` before `_getHeaders()` (this will cause the headers to be a `Future` object instead of a `Map`)
- Students who forget to change the method signature from a getter to a regular method

**Checkpoint:** "Try to compile the app. It should compile. If you get a type error about `Future<Map>` where `Map` is expected, you forgot `await` somewhere."

---

### 1:25--1:40 --- Part 6: Connecting UI to Auth (15 min)

**Type:** Student work (with instructor available for help)

**Say:** "TODO 6 wires the login screen to the auth provider. Open `login_screen.dart` and follow the TODO comments. You need to: (1) add the import for `auth_provider.dart` and `auth_service.dart`, (2) replace the placeholder `_login()` method. Pay close attention to the `mounted` checks -- they prevent crashes when the widget is disposed during async operations. You have 15 minutes."

**Walk around the room.** Key things to verify:

1. Students add both imports: `auth_provider.dart` and `auth_service.dart`
2. The `_login()` method validates the form first
3. `setState(() => _isLoading = true)` is called before the async operation
4. `ref.read(authProvider.notifier).login()` is used (not `ref.watch()`)
5. The catch block catches `AuthException` specifically (not generic `Exception`)
6. `mounted` checks are present before both `ScaffoldMessenger` and `setState`
7. `setState(() => _isLoading = false)` is in the `finally` block

#### Complete TODO 6 Solution

**File:** `lib/screens/login_screen.dart`

Top of file -- add imports:
```dart
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
```

Replace the `_login()` method:
```dart
Future<void> _login() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);
  try {
    await ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );
  } on AuthException catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}
```

**Teaching point -- why `mounted` checks matter:**

Draw this timeline on the whiteboard:

```
User presses Sign In
  --> _login() starts
    --> setState(loading = true)
    --> await login() .... (network request takes 2 seconds)
    --> User presses Back button --> widget DISPOSED
    --> login() returns
    --> setState(loading = false) --> CRASH! Widget is disposed.
```

"The `mounted` check prevents this crash. After any `await`, the widget might no longer exist."

**Bonus:** If fast students finish early, point them to the RegisterScreen bonus TODO. The pattern is identical -- add imports, replace the placeholder SnackBar with `ref.read(authProvider.notifier).register(...)`.

#### Bonus: RegisterScreen Solution

**File:** `lib/screens/register_screen.dart`

Top of file -- add imports:
```dart
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
```

Replace the `_register()` method body:
```dart
Future<void> _register() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);
  try {
    await ref.read(authProvider.notifier).register(
          _emailController.text.trim(),
          _usernameController.text.trim(),
          _passwordController.text,
        );
  } on AuthException catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}
```

**Checkpoint:** "Can you tap Sign In and see either a loading indicator or an error message? If you see the SnackBar 'Incorrect email or password', that means your login is hitting the API -- it is working. We just need a valid account."

---

### 1:40--1:55 --- Part 7: Route Guarding & Auto-Login (15 min)

**Type:** Live coding + student work

**This is the final piece that brings everything together.**

#### 1:40--1:50 --- Live Demo of TODO 7 (10 min)

**Demo on projector.** Open `lib/main.dart`:

**Step 1 -- Add imports:**
```dart
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
```

**Step 2 -- Change `MoodTrackerApp` to `ConsumerWidget`:**

```dart
class MoodTrackerApp extends ConsumerWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Mood Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: switch (authState) {
        AuthState.authenticated => const HomeScreen(),
        AuthState.unauthenticated => const LoginScreen(),
        AuthState.loading => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        AuthState.initial => const _AuthCheckScreen(),
      },
    );
  }
}
```

**Pause after the switch expression.** Explain:

- "This is a Dart 3 switch expression. It returns a widget based on the auth state."
- "`ref.watch(authProvider)` means this widget rebuilds every time the auth state changes. When the user logs in, the state changes from `unauthenticated` to `authenticated`, and the entire `MaterialApp` rebuilds with `HomeScreen` as the home."
- "The `initial` state shows `_AuthCheckScreen`, which we need to create next."

**Step 3 -- Add `_AuthCheckScreen`:**

```dart
class _AuthCheckScreen extends ConsumerStatefulWidget {
  const _AuthCheckScreen();

  @override
  ConsumerState<_AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends ConsumerState<_AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(authProvider.notifier).checkAuth());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
```

**Explain:**
- "This screen exists only to trigger the auth check on startup. It shows a loading indicator while checking."
- "`Future.microtask()` is needed because Riverpod does not allow state modifications during `initState`. The microtask schedules it for the next event loop iteration."
- "After `checkAuth()` runs, the state changes to `authenticated` or `unauthenticated`, and `MoodTrackerApp` rebuilds to show the appropriate screen."
- "The underscore prefix (`_AuthCheckScreen`) makes it private to this file. Students don't need to import it anywhere."

#### 1:50--1:55 --- Student Work + End-to-End Test (5 min)

**Say:** "Make these changes and hot restart the app. You should see a loading indicator, then the login screen. Try registering an account, then logging in."

**Walk students through the end-to-end test:**

1. App launches -- loading indicator -- login screen (no stored token)
2. Tap "Don't have an account? Register"
3. Fill in email, username, password, confirm password
4. Tap "Create Account" -- if register + auto-login works, you should see HomeScreen
5. Close the app completely and reopen -- you should be auto-logged in (token was stored)

**What to watch for:**
- Students who see `StateError: No ProviderScope found` -- they accidentally removed or moved the `ProviderScope` wrapper
- Students who see an infinite loading indicator -- `checkAuth()` is not being called, or the state is stuck at `initial`. Check that `_AuthCheckScreen.initState()` calls `checkAuth()`
- Network errors (SocketException) -- the API server is not running or the base URL is wrong

---

### 1:55--2:00 --- Summary and Wrap-up (5 min)

**Talking points:**

- "You completed 7 TODOs across 5 files. The app now has real authentication."
- "The key takeaway is the layered architecture: `AuthService` handles storage and API calls, `AuthNotifier` manages the state machine, and the UI reacts to state changes."
- "The `mounted` check pattern is critical for any async operation in Flutter. You will use it constantly in production apps."
- "The route guarding pattern -- watching auth state in a root ConsumerWidget -- is how most Flutter apps handle authentication."

**Preview what comes next:**
- "The Mood Tracker app is now feature-complete: state management, local persistence, API networking, and authentication."
- "Next week we will focus on testing and polish."

**Final words:**
- "If your app is not fully working, the finished project is available as a reference."
- "The most common issues are: wrong base URL, API server not running, and missing `await` keywords. Check those first."

---

## Instructor Notes: Pacing & Common Issues

### Where Students Typically Get Stuck

1. **Form-encoded vs JSON (TODOs 2--3).** Students will try to use JSON for the login endpoint and get 422 errors. Emphasize the difference: login uses `application/x-www-form-urlencoded` with a `Map<String, String>` body; register uses `application/json` with `jsonEncode()`.

2. **OAuth2 `username` field (TODO 2).** The login body uses `'username': email`, not `'email': email`. Students who use `'email'` will get a validation error from the API. Show the API docs to explain this.

3. **`rethrow` in AuthNotifier (TODO 4).** Students may not understand why we both change state AND rethrow. Explain: "The notifier handles the state transition. The rethrow lets the UI show the error message. They are different concerns."

4. **Missing `await` before `_getHeaders()` (TODO 5).** This causes a subtle type error: the headers parameter receives a `Future<Map>` instead of a `Map`. The compiler may or may not catch it depending on the inference context. If students get runtime errors about wrong types, check for missing `await`.

5. **`mounted` check (TODO 6).** Students will forget it or not understand why it is needed. Use the whiteboard timeline (shown in the facilitation guide above) to illustrate the race condition.

6. **`Future.microtask()` in `_AuthCheckScreen` (TODO 7).** Students will try to call `ref.read(authProvider.notifier).checkAuth()` directly in `initState()` without wrapping it. This may cause a Riverpod error about modifying state during build. `Future.microtask()` defers the call.

### Where to Slow Down

- The explanation of FlutterSecureStorage vs SharedPreferences. This is a security concept that directly applies to healthcare.
- The auth state machine pattern in TODO 4. Draw it on the whiteboard multiple times.
- The `mounted` check pattern in TODO 6. This is a common Flutter pitfall that students will encounter repeatedly.

### Where You Can Speed Up

- TODO 1 (secure storage methods) -- four simple methods, no conceptual difficulty.
- TODO 5 (replacing headers) -- mechanical change, same pattern repeated four times.
- The register screen bonus -- identical pattern to TODO 6.

### If You Are Running Out of Time

Priority order (must complete):

1. **TODOs 1--2** -- Secure storage and login. This is the foundation.
2. **TODO 4** -- Auth state machine. Required for TODO 7.
3. **TODO 6** -- Wire login UI. Students can see login working.
4. **TODO 7** -- Route guarding. The app shows login/home based on state.
5. **TODO 5** -- Dynamic token injection. Important but can work with hardcoded token temporarily.
6. **TODO 3** -- Register. Can be assigned as homework (students can create accounts via curl).

Can be shortened:
- Part 1 explanation (reduce from 10 to 5 min if students already understand JWT concepts)
- TODO 5 can be done as homework since it is mechanical

### If You Have Extra Time

- Wire up the RegisterScreen bonus TODO
- Implement a logout button in the HomeScreen app bar
- Discuss token refresh flow (how to handle expired access tokens using the refresh token)
- Show what happens when you send an expired token to the API (401 response)
- Discuss additional security measures: certificate pinning, biometric authentication, token rotation
- Show the `flutter_secure_storage` source code to explain how it uses the platform keychain
- Discuss HIPAA technical safeguards and how they map to what students just implemented

---

## Complete Solutions Reference

Below are the full solutions for every TODO. Use these if you need to quickly show a solution on the projector or help a struggling student.

### TODO 1 Solution -- Secure Token Storage Methods

**File:** `lib/services/auth_service.dart`

```dart
Future<void> saveTokens(String accessToken, String refreshToken) async {
  await _storage.write(key: _accessTokenKey, value: accessToken);
  await _storage.write(key: _refreshTokenKey, value: refreshToken);
}

Future<String?> getAccessToken() async {
  return await _storage.read(key: _accessTokenKey);
}

Future<String?> getRefreshToken() async {
  return await _storage.read(key: _refreshTokenKey);
}

Future<void> deleteTokens() async {
  await _storage.delete(key: _accessTokenKey);
  await _storage.delete(key: _refreshTokenKey);
}
```

### TODO 2 Solution -- login()

**File:** `lib/services/auth_service.dart`

```dart
Future<void> login(String email, String password) async {
  final url = Uri.parse('$apiBaseUrl/auth/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {
      'username': email,
      'password': password,
    },
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    await saveTokens(
      data['access_token'] as String,
      data['refresh_token'] as String,
    );
  } else if (response.statusCode == 401) {
    throw AuthException('Incorrect email or password.');
  } else {
    throw AuthException('Login failed. Please try again.');
  }
}
```

### TODO 3 Solution -- register()

**File:** `lib/services/auth_service.dart`

```dart
Future<void> register(String email, String username, String password) async {
  final url = Uri.parse('$apiBaseUrl/auth/register');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'username': username,
      'password': password,
    }),
  );
  if (response.statusCode == 201) {
    return;
  } else if (response.statusCode == 400) {
    final data = jsonDecode(response.body);
    throw AuthException(data['detail'] as String);
  } else {
    throw AuthException('Registration failed. Please try again.');
  }
}
```

### TODO 4 Solution -- AuthNotifier and authProvider

**File:** `lib/providers/auth_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

enum AuthState { initial, loading, authenticated, unauthenticated }

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState.initial);

  Future<void> checkAuth() async {
    final token = await _authService.getAccessToken();
    if (token != null) {
      state = AuthState.authenticated;
    } else {
      state = AuthState.unauthenticated;
    }
  }

  Future<void> login(String email, String password) async {
    state = AuthState.loading;
    try {
      await _authService.login(email, password);
      state = AuthState.authenticated;
    } on AuthException {
      state = AuthState.unauthenticated;
      rethrow;
    }
  }

  Future<void> register(String email, String username, String password) async {
    state = AuthState.loading;
    try {
      await _authService.register(email, username, password);
      await _authService.login(email, password);
      state = AuthState.authenticated;
    } on AuthException {
      state = AuthState.unauthenticated;
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.deleteTokens();
    state = AuthState.unauthenticated;
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});
```

### TODO 5 Solution -- Dynamic Token Injection

**File:** `lib/services/api_client.dart`

```dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'auth_service.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

class ApiClient {
  final String baseUrl;
  final AuthService _authService;

  ApiClient({this.baseUrl = apiBaseUrl, AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);
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

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders();
      final response = await http.post(
        url,
        headers: headers,
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

  Future<void> delete(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders();
      final response = await http.delete(url, headers: headers);
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

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders();
      final response = await http.put(
        url,
        headers: headers,
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
}
```

### TODO 6 Solution -- LoginScreen _login() method

**File:** `lib/screens/login_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
          );
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.mood,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Mood Tracker',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outlined),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Sign In'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text("Don't have an account? Register"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### TODO 7 Solution -- Auth-Based Route Guarding

**File:** `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const ProviderScope(child: MoodTrackerApp()));
}

class MoodTrackerApp extends ConsumerWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Mood Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: switch (authState) {
        AuthState.authenticated => const HomeScreen(),
        AuthState.unauthenticated => const LoginScreen(),
        AuthState.loading => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        AuthState.initial => const _AuthCheckScreen(),
      },
    );
  }
}

class _AuthCheckScreen extends ConsumerStatefulWidget {
  const _AuthCheckScreen();

  @override
  ConsumerState<_AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends ConsumerState<_AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(authProvider.notifier).checkAuth());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
```

### Bonus Solution -- RegisterScreen

**File:** `lib/screens/register_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).register(
            _emailController.text.trim(),
            _usernameController.text.trim(),
            _passwordController.text,
          );
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    if (value.length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outlined),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outlined),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## End-of-Lab Assessment

### Minimum Completion Checklist

Every student should leave the lab with:

- [ ] `AuthService` with secure token storage methods (`saveTokens`, `getAccessToken`, `getRefreshToken`, `deleteTokens`)
- [ ] `login()` method sending form-encoded POST to `/auth/login`
- [ ] `register()` method sending JSON POST to `/auth/register`
- [ ] `AuthNotifier` state machine with `checkAuth`, `login`, `register`, `logout`
- [ ] `ApiClient` using dynamic `_getHeaders()` with real token from secure storage
- [ ] Login screen wired to `authProvider` with error handling and `mounted` checks
- [ ] Route guarding in `main.dart` showing `LoginScreen` or `HomeScreen` based on auth state

### Quick Verification Method

In the last 2 minutes, ask students to perform this sequence:

1. Launch the app -- should see the login screen
2. Register a new account
3. Verify automatic login after registration (should see HomeScreen)
4. Close and reopen the app -- should be auto-logged in
5. Add a mood entry to verify the API works with the real token

Students who complete all 5 steps have a fully working implementation.

### For Students Who Did Not Finish

- Reassure them: "The finished project is available as a reference. Compare it with your work to find the differences."
- Minimum viable: TODOs 1--2 and 4 (they have the auth service and state machine). TODOs 5--7 can be finished at home.
- Remind them that the authentication foundation is critical for the app to work properly going forward.
- Point them to the [FlutterSecureStorage documentation](https://pub.dev/packages/flutter_secure_storage) for additional learning.
