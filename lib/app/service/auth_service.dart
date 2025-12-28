import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String? baseUrl = dotenv.env['API_KEY'];

  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }

  Future<http.Response> googleLogin(String idToken) async {
    final url = Uri.parse('$baseUrl/google-login');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );
  }

  Future<http.Response> register(
    String name,
    String phoneNumber,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/register');
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "password": password,
      }),
    );
  }

  Future<http.Response> getUserProfile(String userId, String token) async {
    final url = Uri.parse("$baseUrl/users/$userId");
    return await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<http.Response> updateUser(
    String userId,
    String token,
    Map<String, dynamic> data,
  ) async {
    debugPrint("token: $token");
    debugPrint(
      "Updating user $userId with data: $data in $baseUrl/users/$userId",
    );
    final url = Uri.parse("$baseUrl/users/$userId");
    return await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );
  }

  Future<http.StreamedResponse> uploadFile(
    String userId,
    File imageFile,
    String token,
  ) async {
    final url = Uri.parse("$baseUrl/users/$userId");

    var request = http.MultipartRequest('PUT', url);
    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath('profilePicture', imageFile.path),
    );

    return await request.send();
  }
}
