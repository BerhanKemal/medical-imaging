import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  // ===========================================================================
  // TODO 1: Implement secure token storage methods
  //
  // saveTokens(String accessToken, String refreshToken) should:
  //   - Save both tokens using _storage.write()
  //   await _storage.write(key: _accessTokenKey, value: accessToken);
  //   await _storage.write(key: _refreshTokenKey, value: refreshToken);
  //
  // getAccessToken() should:
  //   - Read and return the access token (may be null)
  //   return await _storage.read(key: _accessTokenKey);
  //
  // getRefreshToken() should:
  //   - Read and return the refresh token (may be null)
  //   return await _storage.read(key: _refreshTokenKey);
  //
  // deleteTokens() should:
  //   - Delete both tokens from storage
  //   await _storage.delete(key: _accessTokenKey);
  //   await _storage.delete(key: _refreshTokenKey);
  //
  // Why FlutterSecureStorage instead of SharedPreferences?
  // SharedPreferences stores data in plaintext XML/JSON files. Anyone with
  // device access can read them. FlutterSecureStorage uses the OS keychain
  // (iOS) or EncryptedSharedPreferences (Android) — data is encrypted at rest.
  // For auth tokens, this is critical: a stolen token = full account access.
  // ===========================================================================

  // TODO 1: Uncomment and complete:
  //
  // Future<void> saveTokens(String accessToken, String refreshToken) async {
  //   // Save both tokens to secure storage
  // }
  //
  // Future<String?> getAccessToken() async {
  //   // Read access token from secure storage
  //   return null;
  // }
  //
  // Future<String?> getRefreshToken() async {
  //   // Read refresh token from secure storage
  //   return null;
  // }
  //
  // Future<void> deleteTokens() async {
  //   // Delete both tokens from secure storage
  // }

  // ===========================================================================
  // TODO 2: Implement login()
  //
  // The API login endpoint uses OAuth2 password flow with FORM-ENCODED data
  // (not JSON). The 'username' field actually takes the email address.
  //
  //   Future<void> login(String email, String password) async {
  //     final url = Uri.parse('$apiBaseUrl/auth/login');
  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  //       body: {
  //         'username': email,  // OAuth2 convention: email goes in 'username'
  //         'password': password,
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       await saveTokens(
  //         data['access_token'] as String,
  //         data['refresh_token'] as String,
  //       );
  //     } else if (response.statusCode == 401) {
  //       throw AuthException('Incorrect email or password.');
  //     } else {
  //       throw AuthException('Login failed. Please try again.');
  //     }
  //   }
  //
  // Note: This uses form-encoded data (not JSON) because OAuth2 spec requires
  // it for the password grant. The Content-Type header must be
  // 'application/x-www-form-urlencoded', and the body is a Map<String, String>.
  // ===========================================================================

  // TODO 2: Uncomment and complete:
  //
  // Future<void> login(String email, String password) async {
  //   // POST form-encoded to /auth/login, store tokens on success
  // }

  // ===========================================================================
  // TODO 3: Implement register()
  //
  //   Future<void> register(String email, String username, String password) async {
  //     final url = Uri.parse('$apiBaseUrl/auth/register');
  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'email': email,
  //         'username': username,
  //         'password': password,
  //       }),
  //     );
  //     if (response.statusCode == 201) {
  //       return; // Registration successful, user can now login
  //     } else if (response.statusCode == 400) {
  //       final data = jsonDecode(response.body);
  //       throw AuthException(data['detail'] as String);
  //     } else {
  //       throw AuthException('Registration failed. Please try again.');
  //     }
  //   }
  //
  // Note: Register uses JSON (not form-encoded), unlike login.
  // On success (201), it does NOT automatically log in — the user must
  // call login() separately. This is a common pattern.
  // ===========================================================================

  // TODO 3: Uncomment and complete:
  //
  // Future<void> register(String email, String username, String password) async {
  //   // POST JSON to /auth/register, handle errors
  // }
}
