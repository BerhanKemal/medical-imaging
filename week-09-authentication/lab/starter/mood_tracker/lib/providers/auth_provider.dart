import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

enum AuthState { initial, loading, authenticated, unauthenticated }

// ===========================================================================
// TODO 4: Implement AuthNotifier
//
// Create a StateNotifier<AuthState> that manages the authentication state
// machine. The states are:
//   - initial: app just started, haven't checked for stored tokens yet
//   - loading: currently logging in, registering, or checking tokens
//   - authenticated: user is logged in with a valid token
//   - unauthenticated: no valid token, show login screen
//
// class AuthNotifier extends StateNotifier<AuthState> {
//   final AuthService _authService;
//
//   AuthNotifier(this._authService) : super(AuthState.initial);
//
//   Future<void> checkAuth() async {
//     // Check if we have a stored access token
//     final token = await _authService.getAccessToken();
//     if (token != null) {
//       state = AuthState.authenticated;
//     } else {
//       state = AuthState.unauthenticated;
//     }
//   }
//
//   Future<void> login(String email, String password) async {
//     state = AuthState.loading;
//     try {
//       await _authService.login(email, password);
//       state = AuthState.authenticated;
//     } on AuthException {
//       state = AuthState.unauthenticated;
//       rethrow;  // Let the UI handle the error message
//     }
//   }
//
//   Future<void> register(String email, String username, String password) async {
//     state = AuthState.loading;
//     try {
//       await _authService.register(email, username, password);
//       // After registration, automatically log in
//       await _authService.login(email, password);
//       state = AuthState.authenticated;
//     } on AuthException {
//       state = AuthState.unauthenticated;
//       rethrow;
//     }
//   }
//
//   Future<void> logout() async {
//     await _authService.deleteTokens();
//     state = AuthState.unauthenticated;
//   }
// }
// ===========================================================================

// TODO 4: Uncomment and complete:
//
// class AuthNotifier extends StateNotifier<AuthState> {
//   final AuthService _authService;
//
//   AuthNotifier(this._authService) : super(AuthState.initial);
//
//   // Implement checkAuth(), login(), register(), logout()
// }

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// TODO 4: Uncomment once AuthNotifier is implemented:
//
// final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
//   return AuthNotifier(ref.read(authServiceProvider));
// });
