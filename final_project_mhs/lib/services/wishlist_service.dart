import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class WishlistService {
  static String get _base => AuthService.baseUrl;

  static Future<List<Map<String, dynamic>>> getWishlist() async {
    try {
      final headers = await AuthService.authHeaders();
      final response = await http.get(
        Uri.parse('$_base/api/wishlist'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return List<Map<String, dynamic>>.from(body['data'] as List);
      }
    } catch (_) {}
    return [];
  }

  // Returns { is_wishlisted: bool }
  static Future<bool?> toggleWishlist(int venueId) async {
    try {
      final headers = await AuthService.authHeaders();
      final response = await http.post(
        Uri.parse('$_base/api/wishlist/toggle'),
        headers: headers,
        body: jsonEncode({'venue_id': venueId}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return body['is_wishlisted'] as bool;
      }
    } catch (_) {}
    return null;
  }

  static Future<bool> removeWishlist(int venueId) async {
    try {
      final headers = await AuthService.authHeaders();
      final response = await http.delete(
        Uri.parse('$_base/api/wishlist/$venueId'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
