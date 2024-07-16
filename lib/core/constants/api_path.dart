// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'pokeeserver-default-rtdb.firebaseio.com';

  // GET 요청
  static Future<Map<String, dynamic>?> getData(String endpoint) async {
    final url = Uri.https(_baseUrl, '$endpoint.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>?;
    } else {
      print('Failed to load data: ${response.statusCode}');
      return null;
    }
  }

  // PATCH 요청
  static Future<bool> patchData(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.https(_baseUrl, '$endpoint.json');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to update data: ${response.statusCode}');
      return false;
    }
  }

  // POST 요청
  static Future<bool> postData(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.https(_baseUrl, '$endpoint.json');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to post data: ${response.statusCode}');
      return false;
    }
  }
}
