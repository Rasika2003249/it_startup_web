import 'dart:convert';
import 'package:http/http.dart' as http;

/// Custom exception for API call failures.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: ${statusCode ?? "N/A"})';
}

/// A lightweight, reusable HTTP API Service using the [http] package.
/// Prepared for future backend integration without modifying UI logic.
class ApiService {
  static const Duration timeoutDuration = Duration(seconds: 15);

  /// Helper headers for standard JSON request/response
  static Map<String, String> get _defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Performs an HTTP GET request to the specified [endpoint].
  /// Returns decoded JSON Map or List, or `null` if the request fails.
  static Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse(endpoint);
      final response = await http
          .get(
            uri,
            headers: {..._defaultHeaders, ...?headers},
          )
          .timeout(timeoutDuration);

      return _processResponse(response);
    } catch (e) {
      // Basic logging/handling, returning null for graceful fallback
      // ignore: avoid_print
      print('ApiService GET error on $endpoint: $e');
      return null;
    }
  }

  /// Performs an HTTP POST request to the specified [endpoint] with a [body].
  /// Returns decoded JSON Map or List, or `null` if the request fails.
  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(endpoint);
      final response = await http
          .post(
            uri,
            headers: {..._defaultHeaders, ...?headers},
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      return _processResponse(response);
    } catch (e) {
      // ignore: avoid_print
      print('ApiService POST error on $endpoint: $e');
      return null;
    }
  }

  /// Process status codes and decode JSON responses
  static dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return true;
      return jsonDecode(response.body);
    } else {
      throw ApiException(
        'Request failed with status: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }
}
