import 'dart:convert';
import 'package:cema_mobile/app/service/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthenticatedClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  // Getter helper untuk URL agar tidak typo string
  String get baseUrl => dotenv.env['API_KEY'] ?? 'http://localhost:5000/api';

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // 1. Ambil Token dari Secure Storage
    final token = await StorageService().getToken();

    // 2. Sisipkan Token ke Header (jika ada)
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // 3. Standar Header JSON
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';

    return _inner.send(request);
  }

  /// Helper: Handle Response & Error secara Global
  dynamic processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body); // Sukses
      case 400:
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Bad Request');
      case 401:
        // PENTING: Token Expired atau Tidak Valid
        throw Exception('Unauthorized: Sesi habis. Silakan login ulang.');
      case 403:
        throw Exception('Forbidden: Anda tidak memiliki akses.');
      case 404:
        throw Exception('Data tidak ditemukan di server.');
      case 500:
      default:
        throw Exception('Server Error (${response.statusCode})');
    }
  }
}
