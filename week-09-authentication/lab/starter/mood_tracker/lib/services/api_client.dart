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

  // ===========================================================================
  // TODO 5: Update _headers to read token from AuthService
  //
  // Replace the hardcoded tempAuthToken with a dynamic token from AuthService.
  //
  // Since getAccessToken() is async, you need to change _headers from a
  // getter to an async method:
  //
  //   Future<Map<String, String>> _getHeaders() async {
  //     final token = await _authService.getAccessToken();
  //     return {
  //       'Content-Type': 'application/json',
  //       if (token != null) 'Authorization': 'Bearer $token',
  //     };
  //   }
  //
  // Then update all HTTP methods to use: final headers = await _getHeaders();
  //
  // This removes the dependency on config.dart's tempAuthToken and instead
  // reads the real JWT token stored by AuthService after login.
  // ===========================================================================

  // TODO 5: Replace this with _getHeaders() async method
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tempAuthToken',
      };

  Future<dynamic> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      // TODO 5: Change _headers to: final headers = await _getHeaders();
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

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      // TODO 5: Change _headers to: final headers = await _getHeaders();
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

  Future<void> delete(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      // TODO 5: Change _headers to: final headers = await _getHeaders();
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

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      // TODO 5: Change _headers to: final headers = await _getHeaders();
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
}
