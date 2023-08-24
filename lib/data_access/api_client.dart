import 'dart:convert';
import 'package:http/http.dart' as http;

/// Provides a set of generic Http methods
class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  /// Generic GET request
  Future<http.Response> get(String endpoint) async {
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(url);
    return response;
  }

  /// Generic POST request
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return response;
  }

  // Generic PUT request
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return response;
  }

  /// Generic DELETE request
  Future<http.Response> delete(String endpoint) async {
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.delete(url);
    return response;
  }
}