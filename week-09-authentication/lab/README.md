# Week 9 Lab: Authentication & Security

> **Course:** Mobile Apps for Healthcare
> **Duration:** ~2 hours
> **Prerequisites:** Week 8 Networking & API (working Mood Tracker with API integration)

---

## Learning Objectives

By the end of this lab you will be able to:

1. Explain why secure token storage is critical in mobile health applications.
2. Store and retrieve JWT tokens using `FlutterSecureStorage` (encrypted at rest).
3. Implement login and registration flows that communicate with a REST API.
4. Manage authentication state using a `StateNotifier` state machine pattern.
5. Dynamically inject bearer tokens into API requests.
6. Wire login/register UI to the auth provider with proper error handling.
7. Implement route guarding so unauthenticated users see a login screen and authenticated users see the home screen.

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
- **The mood-tracker-api server running** on your machine (from Week 8). Verify by running:
  ```bash
  curl http://localhost:8000/docs
  ```
  You should see the API documentation page.
- **The starter project** loaded in your IDE:
  ```
  week-09-authentication/lab/starter/mood_tracker/
  ```
  Open this folder and run `flutter pub get` to resolve dependencies. Verify the app builds and launches before starting the exercises.

> **Tip:** If the starter project does not compile, check that `flutter_secure_storage` and `http` appear in `pubspec.yaml` and that `flutter pub get` completed without errors. Ask the instructor for help if needed.

---

## About the Starter Project

You are continuing to develop the **Mood Tracker** app from Weeks 6--8. The starter project already provides:

- Full Riverpod state management from Week 6
- SQLite local persistence from Week 7
- API networking with `ApiClient` from Week 8
- Login and Register screen UI (pre-built, but not wired up)
- An `AuthService` class with TODO scaffolds
- An `AuthNotifier` state machine (commented out)

The app currently sends API requests with a hardcoded token from `config.dart`. Your job in this lab is to replace that with proper **authentication** by completing 7 TODOs across 5 files.

### Project structure

| File | Purpose |
|------|---------|
| `lib/services/auth_service.dart` | TODOs 1--3: Secure storage, login, register |
| `lib/providers/auth_provider.dart` | TODO 4: Auth state machine |
| `lib/services/api_client.dart` | TODO 5: Dynamic token injection |
| `lib/screens/login_screen.dart` | TODO 6: Wiring login UI |
| `lib/main.dart` | TODO 7: Route guarding based on auth state |
| `lib/screens/register_screen.dart` | Pre-built register UI (bonus wiring) |
| `lib/config.dart` | API base URL and temp token (to be replaced) |

---

> **Healthcare Context: Why Authentication Matters in mHealth**
>
> In mobile health applications, authentication is not just a convenience feature -- it is a regulatory requirement. Consider:
> - **HIPAA compliance** requires that patient health data is accessible only to authorized users. An unauthenticated app that exposes mood, vitals, or medication data violates basic security requirements.
> - **Patient data protection** -- mood entries, even when anonymized, are sensitive health information. A stolen access token grants full access to a patient's data.
> - **Plaintext token storage is dangerous.** `SharedPreferences` stores data in unencrypted XML (Android) or plist (iOS) files. Anyone with physical device access or a backup extraction tool can read them. `FlutterSecureStorage` uses the OS keychain (iOS) or EncryptedSharedPreferences (Android) -- data is encrypted at rest.
> - **Session management** -- real mHealth apps use short-lived access tokens and refresh tokens so that a compromised token has a limited window of exploitation.
>
> The patterns you learn today -- encrypted storage, JWT-based auth, and state-driven route guarding -- are the same patterns used in production health apps that handle real patient data.

---

## Part 1: Understanding Auth in Mobile Apps (~10 min)

### 1.1 How JWT authentication works

JSON Web Tokens (JWT) are the standard for API authentication in modern mobile apps. The flow is:

1. **User submits credentials** (email + password) to the server.
2. **Server verifies** the credentials and returns two tokens:
   - **Access token** -- short-lived (minutes to hours), sent with every API request.
   - **Refresh token** -- long-lived (days to weeks), used to get a new access token when the old one expires.
3. **App stores tokens securely** on the device.
4. **Every API request** includes the access token in the `Authorization: Bearer <token>` header.
5. **When the access token expires**, the app uses the refresh token to get a new one (without asking the user to log in again).

### 1.2 Why FlutterSecureStorage?

| Storage | Encryption | Use case |
|---------|-----------|----------|
| `SharedPreferences` | None (plaintext) | Non-sensitive settings (theme preference, onboarding flag) |
| `FlutterSecureStorage` | OS keychain / EncryptedSharedPreferences | Secrets (auth tokens, API keys, PII) |

On Android, `SharedPreferences` writes to an XML file at `/data/data/<package>/shared_prefs/`. On a rooted device, this file is trivially readable. `FlutterSecureStorage` uses Android's `EncryptedSharedPreferences` with AES-256 encryption, backed by the hardware keystore.

On iOS, `FlutterSecureStorage` writes to the Keychain, which is encrypted by the Secure Enclave and only accessible to your app's sandbox.

### 1.3 The auth state machine

Your app's authentication state follows a clear state machine:

```
           App starts
               |
          [initial]
               |
         checkAuth()
          /        \
    token found   no token
         |            |
  [authenticated]  [unauthenticated]
         |                 |
      logout()         login() / register()
         |                 |
  [unauthenticated]   [loading]
                       /      \
                  success    failure
                     |          |
              [authenticated]  [unauthenticated]
```

This state machine drives which screen the user sees: `LoginScreen` or `HomeScreen`.

---

### Self-Check: Part 1

Before continuing, make sure you can answer these questions:

- [ ] What is the difference between an access token and a refresh token?
- [ ] Why is `SharedPreferences` unsuitable for storing auth tokens?
- [ ] What are the four states in our auth state machine?

---

## Part 2: Secure Token Storage (~15 min)

Open `lib/services/auth_service.dart`. This file contains the `AuthService` class with `FlutterSecureStorage` already initialized.

### 2.1 TODO 1: Implement secure token storage methods

Find the `TODO 1` comment block. Your task is to uncomment and complete four methods:

1. **`saveTokens(String accessToken, String refreshToken)`** -- Write both tokens to secure storage:
   ```dart
   await _storage.write(key: _accessTokenKey, value: accessToken);
   await _storage.write(key: _refreshTokenKey, value: refreshToken);
   ```

2. **`getAccessToken()`** -- Read and return the access token (may be `null` if not stored):
   ```dart
   return await _storage.read(key: _accessTokenKey);
   ```

3. **`getRefreshToken()`** -- Read and return the refresh token (may be `null`):
   ```dart
   return await _storage.read(key: _refreshTokenKey);
   ```

4. **`deleteTokens()`** -- Remove both tokens (used during logout):
   ```dart
   await _storage.delete(key: _accessTokenKey);
   await _storage.delete(key: _refreshTokenKey);
   ```

> **Key insight:** All `FlutterSecureStorage` operations are `async` because they interact with platform-specific encrypted storage. The `_accessTokenKey` and `_refreshTokenKey` constants are already defined at the top of the class.

---

### Self-Check: Part 2

- [ ] Your four methods compile without errors.
- [ ] `saveTokens` writes both tokens, `deleteTokens` deletes both tokens.
- [ ] All methods are `async` and return `Future`.

---

## Part 3: Login & Register Services (~20 min)

Stay in `lib/services/auth_service.dart`. Now you will implement the two API calls for authentication.

### 3.1 TODO 2: Implement login()

Find the `TODO 2` comment block. Implement the `login()` method that:

1. Sends a **POST** request to `/auth/login` with **form-encoded** data.
2. Parses the JSON response to extract `access_token` and `refresh_token`.
3. Stores both tokens using `saveTokens()`.
4. Throws an `AuthException` on failure.

```dart
Future<void> login(String email, String password) async {
  final url = Uri.parse('$apiBaseUrl/auth/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {
      'username': email,  // OAuth2 convention: email goes in 'username'
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

> **Important detail:** The login endpoint uses **form-encoded** data (`application/x-www-form-urlencoded`), not JSON. This is because the API follows the OAuth2 password grant specification, which mandates form encoding. Notice that the email is sent in the `'username'` field -- this is also an OAuth2 convention.

### 3.2 TODO 3: Implement register()

Find the `TODO 3` comment block. Implement the `register()` method that:

1. Sends a **POST** request to `/auth/register` with **JSON** data.
2. Returns successfully on `201` status.
3. Parses and throws the server's error message on `400` status.

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

> **Why does login use form-encoded but register uses JSON?** Login follows the OAuth2 token endpoint specification, which requires `application/x-www-form-urlencoded`. Registration is a custom endpoint that uses JSON, the more common format for REST APIs. This distinction is common in real-world APIs.

> **Notice:** Registration does NOT automatically log the user in. It only creates the account. The user (or the app) must call `login()` separately afterward. This separation of concerns is a common pattern.

---

### Self-Check: Part 3

- [ ] `login()` sends form-encoded data with `'username'` field (not `'email'`).
- [ ] `login()` stores both tokens on success.
- [ ] `register()` sends JSON data.
- [ ] `register()` throws `AuthException` with the server's error message on `400`.
- [ ] Both methods handle error status codes.

---

## Part 4: Auth State Management (~15 min)

Open `lib/providers/auth_provider.dart`. This file defines the `AuthState` enum and has a scaffold for the `AuthNotifier`.

### 4.1 TODO 4: Implement AuthNotifier

Find the `TODO 4` comment block. Uncomment and complete the `AuthNotifier` class:

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
      rethrow; // Let the UI handle the error message
    }
  }

  Future<void> register(String email, String username, String password) async {
    state = AuthState.loading;
    try {
      await _authService.register(email, username, password);
      // After registration, automatically log in
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

Then **uncomment the `authProvider`** definition below the class:

```dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});
```

> **Key insight -- the state machine pattern:**
> - Every method sets `state = AuthState.loading` before starting async work.
> - On success, state transitions to `authenticated`.
> - On failure, state transitions to `unauthenticated` and the exception is rethrown for the UI to display.
> - `rethrow` is critical: it lets the calling code (the login screen) catch the `AuthException` and show the error message in a SnackBar, while the notifier still handles the state transition.

> **Why `register()` calls `login()` after registration:** This is a UX choice. After a successful registration, the user is automatically logged in rather than being sent back to the login screen. The `register()` method calls `_authService.register()` then `_authService.login()` in sequence.

---

### Self-Check: Part 4

- [ ] `AuthNotifier` extends `StateNotifier<AuthState>`.
- [ ] The constructor starts in `AuthState.initial`.
- [ ] `checkAuth()` reads the stored token and transitions to `authenticated` or `unauthenticated`.
- [ ] `login()` and `register()` set `loading` state, then transition to `authenticated` on success or `unauthenticated` on failure.
- [ ] `logout()` deletes tokens and transitions to `unauthenticated`.
- [ ] The `authProvider` definition is uncommented.

---

## Part 5: Dynamic Token Injection (~10 min)

Open `lib/services/api_client.dart`. This file currently uses a hardcoded `tempAuthToken` from `config.dart`.

### 5.1 TODO 5: Replace _headers with _getHeaders()

Find the `TODO 5` comments. You need to make two changes:

**Step 1 -- Replace the getter with an async method:**

```dart
// Before (hardcoded):
Map<String, String> get _headers => {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tempAuthToken',
    };

// After (dynamic):
Future<Map<String, String>> _getHeaders() async {
  final token = await _authService.getAccessToken();
  return {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };
}
```

**Step 2 -- Update all HTTP methods** to use the new async method. In each of the four methods (`get`, `post`, `delete`, `put`), replace:

```dart
// Before:
final response = await http.get(url, headers: _headers);

// After:
final headers = await _getHeaders();
final response = await http.get(url, headers: headers);
```

> **Key insight:** The `if (token != null)` inside the map literal is a Dart collection-if. If no token is stored (user not logged in), the `Authorization` header is simply omitted. This prevents sending `Bearer null` to the server.

> **Why async?** `FlutterSecureStorage.read()` is an async operation because it interacts with the platform's encrypted storage. This means `_headers` cannot be a synchronous getter anymore -- it must become an async method. Every call site must `await` it.

---

### Self-Check: Part 5

- [ ] The hardcoded `_headers` getter is replaced with `_getHeaders()` async method.
- [ ] All four HTTP methods (`get`, `post`, `delete`, `put`) now use `await _getHeaders()`.
- [ ] The `Authorization` header is only included when a token exists.
- [ ] The `tempAuthToken` from `config.dart` is no longer referenced in this file.

---

## Part 6: Connecting UI to Auth (~15 min)

Open `lib/screens/login_screen.dart`. The login form UI is already built. You need to wire the submit button to the auth provider.

### 6.1 TODO 6: Implement the _login() method

Find the `TODO 6` comments. Make these changes:

**Step 1 -- Add the missing import** at the top of the file:

```dart
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
```

**Step 2 -- Replace the placeholder `_login()` method:**

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

> **Why the `mounted` check?** The `login()` call is asynchronous. While awaiting the network response, the user might navigate away (e.g., press the back button), which would dispose the widget. Calling `setState()` or `ScaffoldMessenger.of(context)` on a disposed widget throws an error. The `mounted` property is `true` only when the widget is still in the tree.

> **Why `ref.read()` and not `ref.watch()`?** The login button tap is a one-time action, not a continuous subscription. We use `ref.read()` in event handlers and `ref.watch()` in `build()` methods -- the same rule from Week 6.

### 6.2 Bonus: Wire the RegisterScreen

The register screen at `lib/screens/register_screen.dart` has a similar `_register()` method with a TODO comment. If you have time, wire it up the same way:

1. Add `import '../providers/auth_provider.dart';` and `import '../services/auth_service.dart';`.
2. Replace the placeholder SnackBar in `_register()` with:
   ```dart
   await ref.read(authProvider.notifier).register(
     _emailController.text.trim(),
     _usernameController.text.trim(),
     _passwordController.text,
   );
   ```
3. Change the `catch` block to catch `AuthException` specifically.

---

### Self-Check: Part 6

- [ ] The `_login()` method validates the form before calling the provider.
- [ ] Loading state is set to `true` before the async call and `false` in `finally`.
- [ ] `AuthException` is caught and displayed in a SnackBar.
- [ ] `mounted` checks are used before `setState()` and `ScaffoldMessenger`.

---

## Part 7: Route Guarding & Auto-Login (~15 min)

Open `lib/main.dart`. Currently, the app always shows `HomeScreen`. You need to make it show the correct screen based on the auth state.

### 7.1 TODO 7: Implement auth-based routing

Find the `TODO 7` comments. Make these changes:

**Step 1 -- Add imports:**

```dart
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
```

**Step 2 -- Change `MoodTrackerApp` from `StatelessWidget` to `ConsumerWidget`:**

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

**Step 3 -- Add the `_AuthCheckScreen` widget** below `MoodTrackerApp`:

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

> **How this works:**
> 1. The app starts with `AuthState.initial`, which shows `_AuthCheckScreen`.
> 2. `_AuthCheckScreen.initState()` calls `checkAuth()`, which reads the stored token.
> 3. If a token exists, state transitions to `authenticated` and `MoodTrackerApp` rebuilds to show `HomeScreen`.
> 4. If no token exists, state transitions to `unauthenticated` and `MoodTrackerApp` rebuilds to show `LoginScreen`.
> 5. After a successful login, state transitions to `authenticated` and the app automatically switches to `HomeScreen`.

> **Why `Future.microtask()`?** Riverpod does not allow modifying provider state during `initState()` synchronously. `Future.microtask()` schedules the call to run after the current build cycle completes, which is the safe way to trigger state changes during widget initialization.

> **Dart 3 switch expression:** The `switch (authState) { ... }` syntax is a Dart 3 feature called a switch expression. It is like a traditional switch statement but returns a value, making it ideal for choosing which widget to display.

---

### Self-Check: Part 7

- [ ] `MoodTrackerApp` is a `ConsumerWidget` that watches `authProvider`.
- [ ] The app shows a loading indicator during `initial` and `loading` states.
- [ ] The app shows `LoginScreen` when unauthenticated.
- [ ] The app shows `HomeScreen` when authenticated.
- [ ] `_AuthCheckScreen` calls `checkAuth()` on startup to restore the session.

---

## Part 8: Self-Check and Summary (~10 min)

### 8.1 End-to-end verification

Walk through this complete flow to verify everything works:

1. Launch the app. You should see a loading indicator, then the **login screen** (since no token is stored).
2. Tap **"Don't have an account? Register"** to go to the registration screen.
3. Create an account with an email, username, and password.
4. If registration succeeds, the app should automatically log you in and show the **home screen**.
5. Close and reopen the app. You should be **automatically logged in** (the stored token is detected).
6. Add a mood entry to verify the API works with the real token.
7. Log out (if you added a logout button, or clear the app data). You should be taken back to the **login screen**.
8. Log in with your credentials. You should see the **home screen** again.

If all 8 steps work correctly, you have completed the lab.

### 8.2 Summary

| TODO | File | What you did |
|------|------|-------------|
| 1 | `services/auth_service.dart` | Implemented `saveTokens`, `getAccessToken`, `getRefreshToken`, `deleteTokens` using `FlutterSecureStorage`. |
| 2 | `services/auth_service.dart` | Implemented `login()` -- POST form-encoded to `/auth/login`, parse token response, store tokens. |
| 3 | `services/auth_service.dart` | Implemented `register()` -- POST JSON to `/auth/register`, handle 400 errors. |
| 4 | `providers/auth_provider.dart` | Implemented `AuthNotifier` state machine with `checkAuth`, `login`, `register`, `logout`. |
| 5 | `services/api_client.dart` | Replaced hardcoded `_headers` with async `_getHeaders()` that reads the real token. |
| 6 | `screens/login_screen.dart` | Implemented `_login()` with form validation, provider call, error SnackBar, and `mounted` checks. |
| 7 | `main.dart` | Implemented auth-based route guarding with `ConsumerWidget` and `_AuthCheckScreen`. |

### 8.3 Key concepts learned

| Concept | Key Takeaway |
|---------|--------------|
| `FlutterSecureStorage` | Uses OS-level encryption (Keychain / EncryptedSharedPreferences) for sensitive data like tokens. |
| JWT auth flow | Client sends credentials, server returns access + refresh tokens, client stores and sends them with every request. |
| OAuth2 form encoding | Login endpoints following OAuth2 spec use `application/x-www-form-urlencoded`, not JSON. |
| State machine pattern | Auth state transitions (`initial -> loading -> authenticated/unauthenticated`) drive which screen is shown. |
| `mounted` check | Always check `mounted` before calling `setState()` or accessing `context` after an `await`. |
| Route guarding | Watch auth state in a root `ConsumerWidget` and conditionally render screens. |
| `Future.microtask()` | Safe way to trigger provider state changes during widget initialization. |

---

## What Comes Next

In the following weeks, you will extend this Mood Tracker app:

- **Week 10:** Polish, testing, and final features -- unit tests, integration tests, and app refinements.

The authentication foundation you built today ensures that every API request is properly authorized and that patient data is protected.

---

## Further Reading

- [FlutterSecureStorage package on pub.dev](https://pub.dev/packages/flutter_secure_storage)
- [JWT.io -- JSON Web Token introduction](https://jwt.io/introduction)
- [OAuth2 Resource Owner Password Credentials Grant](https://datatracker.ietf.org/doc/html/rfc6749#section-4.3)
- [Flutter Riverpod documentation](https://riverpod.dev/)
- [HIPAA Security Rule -- Technical Safeguards](https://www.hhs.gov/hipaa/for-professionals/security/laws-regulations/index.html)
- [OWASP Mobile Security -- Authentication](https://owasp.org/www-project-mobile-top-10/)
