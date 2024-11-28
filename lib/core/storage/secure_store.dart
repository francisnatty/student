import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Singleton pattern
  static final SecureStorage _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;
  SecureStorage._internal();

  // Initialize FlutterSecureStorage instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Write data to secure storage
  Future<void> write({required String key, required String value}) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw Exception("Failed to write data: $e");
    }
  }

  // Read data from secure storage
  Future<String?> get({required String key}) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      throw Exception("Failed to read data: $e");
    }
  }

  // Delete data from secure storage
  Future<void> delete({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw Exception("Failed to delete data: $e");
    }
  }

  // Clear all data from secure storage
  Future<void> clear() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw Exception("Failed to clear all data: $e");
    }
  }
}
