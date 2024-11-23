// lib/services/http_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ki_kati/components/secureStorageServices.dart';

class HttpService {
  final String baseUrl;
  SecureStorageService storageService = SecureStorageService();

  HttpService(this.baseUrl);

  // Generic GET method
  Future<dynamic> get(String endpoint) async {
    // Retrieve user data using the key 'user_data'
    Map<String, dynamic>? retrievedUserData =
        await storageService.retrieveData('user_data');

    final url = Uri.parse('$baseUrl$endpoint');
    Map<String, String> headers = {};
    print(url);

    final token = retrievedUserData?['token'];

    if (token != null) {
      headers['Authorization'] =
          'Bearer $token'; // Add authorization header if token is available
    }

    try {
      final response = await http.get(url, headers: headers);
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

    Map<String, dynamic>? retrievedUserData =
        await storageService.retrieveData('user_data');
    final token = retrievedUserData?['token'];

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] =
          'Bearer $token'; // Add authorization header if token is available
    }
    try {
      final response = await http.post(
        url,
        headers: headers,
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

  // Generic DELETE method
  Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    Map<String, String> headers = {};

    Map<String, dynamic>? retrievedUserData =
        await storageService.retrieveData('user_data');
    final token = retrievedUserData?['token'];

    if (token != null) {
      headers['Authorization'] =
          'Bearer $token'; // Add authorization header if token is available
    }

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'statusCode': response.statusCode,
          'body': jsonDecode(response.body),
        };
      } else {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
