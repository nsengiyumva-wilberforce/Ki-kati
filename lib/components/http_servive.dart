// lib/services/http_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl;

  HttpService(this.baseUrl);

  // Generic GET method
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Generic POST method
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      // Return a map with the status code and body regardless of the outcome

      /*return {
        'statusCode': response.statusCode,
        'body': jsonDecode(response.body),
      };
      */
      if (response.statusCode >= 200 && response.statusCode <= 500) {
        return {
          'statusCode': response.statusCode,
          'body': jsonDecode(response.body),
        };
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
