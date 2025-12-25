import 'dart:convert';
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
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/register');

    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );
  }
}
