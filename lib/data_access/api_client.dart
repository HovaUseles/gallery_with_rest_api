import 'dart:convert';
import 'package:http/http.dart' as http;

/// Provides a set of generic Http methods
class ApiClient {
  final String baseUrl;
  late int _defaultTimeout;

  ApiClient({required this.baseUrl, int? defaultTimeout}) {
    _defaultTimeout = defaultTimeout ?? 15;
  }

  /// Generic GET request
  Future<http.Response> get(String endpoint, {int? timeout}) async {
    int requestTimeout = timeout ?? _defaultTimeout; // set the request timeout variable
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(url).timeout(Duration(seconds: requestTimeout));
    return response;
  }

  /// Generic POST request
  Future<http.Response> post(String endpoint, Map<String, dynamic> body, {int? timeout}) async {
    int requestTimeout = timeout ?? _defaultTimeout; // set the request timeout variable
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    ).timeout(Duration(seconds: requestTimeout));
    return response;
  }

  // Generic PUT request
  Future<http.Response> put(String endpoint, Map<String, dynamic> body, {int? timeout}) async {
    int requestTimeout = timeout ?? _defaultTimeout; // set the request timeout variable
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    ).timeout(Duration(seconds: requestTimeout));
    return response;
  }

  /// Generic DELETE request
  Future<http.Response> delete(String endpoint, {int? timeout}) async {
    int requestTimeout = timeout ?? _defaultTimeout; // set the request timeout variable
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.delete(url).timeout(Duration(seconds: requestTimeout));
    return response;
  }
}