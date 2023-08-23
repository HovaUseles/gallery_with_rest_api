import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Future<http.Response> get(String endpoint) async {
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(url);
    return response;
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> delete(String endpoint) async {
    Uri url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.delete(url);
    return response;
  }
}