import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

class StorageService {
  // Singleton pattern (optional but good for consistency)
  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  // Secure storage for sensitive data
  // Note: We use method-level options to avoid constructor deprecation issues.
  final _secureStorage = const FlutterSecureStorage();

  // GetStorage for non-sensitive data
  final _box = GetStorage();

  // Helper for Android Options
  // In v10+, EncryptedSharedPreferences (AES GCM + RSA OAEP) is the default.
  // The 'encryptedSharedPreferences' option itself is deprecated and should not be used.
  AndroidOptions _getAndroidOptions() => const AndroidOptions();

  // --- Secure Operations (Token) ---

  Future<void> saveToken(String token) async {
    debugPrint("DEBUG: StorageService.saveToken called");
    try {
      await _secureStorage.write(
        key: 'token',
        value: token,
        aOptions: _getAndroidOptions(),
      );
      debugPrint("DEBUG: StorageService.saveToken success");
    } catch (e) {
      debugPrint("DEBUG: StorageService.saveToken FAILED: $e");
      rethrow;
    }
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(
      key: 'token',
      aOptions: _getAndroidOptions(),
    );
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'token', aOptions: _getAndroidOptions());
  }

  // --- General GetStorage Wrappers (Optional) ---
  void saveUser(String key, dynamic value) {
    _box.write(key, value);
  }

  dynamic readUser(String key) {
    return _box.read(key);
  }

  // --- Logout / Clear All ---

  Future<void> clearAll() async {
    await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
    await _box.erase();
  }
}
