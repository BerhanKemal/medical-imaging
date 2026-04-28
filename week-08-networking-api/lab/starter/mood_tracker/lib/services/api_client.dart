import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

class ApiClient {
  final String baseUrl;

  ApiClient({this.baseUrl = apiBaseUrl});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tempAuthToken',
      };

  // ===========================================================================
  // TODO 2: Implement the get() method
  //
  // This method makes an HTTP GET request to the given endpoint.
  //
  //   Future<dynamic> get(String endpoint) async {
  //     final url = Uri.parse('$baseUrl$endpoint');
  //     final response = await http.get(url, headers: _headers);
  //     if (response.statusCode >= 200 && response.statusCode < 300) {
  //       return jsonDecode(response.body);
  //     }
  //     throw ApiException(
  //       'GET $endpoint failed',
  //       statusCode: response.statusCode,
  //     );
  //   }
  //
  // Steps:
  //   1. Build the full URL: Uri.parse('$baseUrl$endpoint')
  //   2. Call http.get() with the URL and _headers
  //   3. Check if status code is 2xx (success)
  //   4. If success: decode the JSON body and return it
  //   5. If failure: throw an ApiException with the status code
  // ===========================================================================

  // TODO 2: Uncomment and complete:
  //
  // Future<dynamic> get(String endpoint) async {
  //   final url = Uri.parse('$baseUrl$endpoint');
  //   // Make the GET request and handle the response
  // }

  // ===========================================================================
  // TODO 3: Implement the post() method
  //
  //   Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
  //     final url = Uri.parse('$baseUrl$endpoint');
  //     final response = await http.post(
  //       url,
  //       headers: _headers,
  //       body: jsonEncode(body),
  //     );
  //     if (response.statusCode >= 200 && response.statusCode < 300) {
  //       return response.body.isNotEmpty ? jsonDecode(response.body) : null;
  //     }
  //     throw ApiException(
  //       'POST $endpoint failed',
  //       statusCode: response.statusCode,
  //     );
  //   }
  //
  // Note: jsonEncode() converts the Dart Map to a JSON string for the body.
  // The response might be empty (e.g., 204 No Content), so check .isNotEmpty.
  // ===========================================================================

  // TODO 3: Uncomment and complete:
  //
  // Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
  //   final url = Uri.parse('$baseUrl$endpoint');
  //   // Make the POST request with JSON body and handle the response
  // }

  Future<void> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(url, headers: _headers);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'DELETE $endpoint failed',
        statusCode: response.statusCode,
      );
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
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
  }

  // ===========================================================================
  // TODO 6: Add error handling with try-catch
  //
  // Wrap the HTTP calls in get(), post(), delete(), and put() with try-catch
  // to handle network errors gracefully:
  //
  //   try {
  //     // ... existing HTTP code ...
  //   } on SocketException {
  //     throw ApiException('No internet connection. Please check your network.');
  //   } on HttpException {
  //     throw ApiException('Server error. Please try again later.');
  //   } on FormatException {
  //     throw ApiException('Invalid response from server.');
  //   }
  //
  // This ensures the app shows user-friendly messages instead of crashing
  // when the network is unavailable or the server is down.
  //
  // Hint: You need to import 'dart:io' for SocketException and HttpException.
  // (Already imported at the top of this file.)
  // ===========================================================================
}
