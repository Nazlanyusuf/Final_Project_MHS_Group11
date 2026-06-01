import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk komunikasi auth ke backend Laravel
/// Tambahkan dependency di pubspec.yaml:
///   http: ^1.2.0
///   shared_preferences: ^2.2.2
class AuthService {
  // ── Ganti dengan URL backend kamu ──────────────────────────────
  static const String _baseUrl = 'https://api.venuekitaaja.com';
  // Untuk testing lokal (Android emulator): 'http://10.0.2.2:8000'
  // Untuk testing lokal (iOS simulator):   'http://localhost:8000'

  // ── Simpan token ke local storage ──────────────────────────────
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
  }

  // ── Header default ─────────────────────────────────────────────
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

  // ── REGISTER ───────────────────────────────────────────────────
  /// POST /api/register
  /// Body: { email, username, password, password_confirmation, date_of_birth }
  static Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
    required String dateOfBirth,  // format: YYYY-MM-DD
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/register'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
          'password_confirmation': password,
          'date_of_birth': dateOfBirth,
        }),
      ).timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return {'success': true, 'message': body['message'] ?? 'Registrasi berhasil'};
      } else {
        // Laravel validation errors: { errors: { email: [...], ... } }
        final errors = body['errors'] as Map<String, dynamic>?;
        final firstError = errors?.values.first;
        final message = firstError is List ? firstError.first : body['message'] ?? 'Registrasi gagal';
        return {'success': false, 'message': message};
      }
    } catch (e) {
      return {'success': false, 'message': 'Tidak bisa terhubung ke server'};
    }
  }

  // ── LOGIN ──────────────────────────────────────────────────────
  /// POST /api/login
  /// Body: { email, password }
  /// Response: { token, user: { id, email, username, ... } }
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/login'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final token = body['token'] as String?;
        if (token != null) await saveToken(token);
        return {
          'success': true,
          'token': token,
          'user': body['user'],
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Email atau password salah',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Tidak bisa terhubung ke server'};
    }
  }

  // ── LOGOUT ─────────────────────────────────────────────────────
  /// POST /api/logout  (requires auth token)
  static Future<void> logout() async {
    try {
      final headers = await _authHeaders;
      await http.post(
        Uri.parse('$_baseUrl/api/logout'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));
    } catch (_) {
      // Tetap hapus token lokal walau request gagal
    } finally {
      await removeToken();
    }
  }

  // ── CEK APAKAH USER SUDAH LOGIN ────────────────────────────────
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
