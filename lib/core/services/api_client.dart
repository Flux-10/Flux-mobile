import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiResponse<T> {
  final T? data;
  final String? error;
  final int statusCode;

  ApiResponse({
    this.data,
    this.error,
    required this.statusCode,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

class ApiClient {
  final String baseUrl;
  final http.Client _httpClient;

  ApiClient({
    required this.baseUrl,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  Future<ApiResponse<T>> post<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
  }) async {
    final url = '$baseUrl$endpoint';
    log('API REQUEST: POST $url');
    log('Request body: ${jsonEncode(body)}');
    
    try {
      final response = await _httpClient.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          ...headers ?? {},
        },
        body: jsonEncode(body),
      );

      log('API RESPONSE: ${response.statusCode}');
      log('Response body: ${response.body}');

      dynamic responseBody;
      try {
        responseBody = jsonDecode(response.body);
      } catch (e) {
        log('Failed to parse response as JSON: $e');
        return ApiResponse<T>(
          error: 'Invalid response format',
          statusCode: response.statusCode,
        );
      }
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final data = fromJson(responseBody);
          return ApiResponse<T>(
            data: data,
            statusCode: response.statusCode,
          );
        } catch (e) {
          log('Error parsing success response: $e');
          return ApiResponse<T>(
            error: 'Failed to parse response data: $e',
            statusCode: response.statusCode,
          );
        }
      } else {
        final errorMessage = responseBody['message'] ?? 'Unknown error';
        log('API error: $errorMessage');
        return ApiResponse<T>(
          error: errorMessage,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      log('API exception: $e');
      return ApiResponse<T>(
        error: e.toString(),
        statusCode: 500,
      );
    }
  }
} 