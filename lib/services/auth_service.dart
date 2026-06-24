import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Otomatis pilih URL berdasarkan platform
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000';                   // Chrome/Edge
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';                             // Android emulator
    }
    return 'http://localhost:8000';                               // Windows/iOS/macOS
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, String>> get _authHeaders async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
    required String dateOfBirth,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: _headers,
        body: jsonEncode({
          'name': username,
          'email': email,
          'username': username,
          'password': password,
          'date_of_birth': dateOfBirth,
        }),
      ).timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return {'success': true, 'message': body['message'] ?? 'Registrasi berhasil'};
      }

      final errors = body['errors'] as Map<String, dynamic>?;
      final firstError = errors?.values.first;
      final message = firstError is List ? firstError.first : body['message'] ?? 'Registrasi gagal';
      return {'success': false, 'message': message};
    } catch (_) {
      return {'success': false, 'message': 'Tidak bisa terhubung ke server'};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: _headers,
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && body['success'] == true) {
        final token = body['token'] as String?;
        if (token != null) {
          await saveToken(token);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_data', jsonEncode(body['user']));
        }
        return {'success': true, 'token': token, 'user': body['user']};
      }
      return {'success': false, 'message': body['message'] ?? 'Login gagal'};
    } catch (_) {
      return {'success': false, 'message': 'Tidak bisa terhubung ke server'};
    }
  }

  static Future<void> logout() async {
    try {
      final headers = await _authHeaders;
      await http.post(
        Uri.parse('$baseUrl/api/auth/logout'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));
    } catch (_) {
    } finally {
      await removeToken();
    }
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('user_data');
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<Map<String, String>> authHeaders() async => _authHeaders;
}
