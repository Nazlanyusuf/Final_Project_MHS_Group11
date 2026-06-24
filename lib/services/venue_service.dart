import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class VenueService {
  static String get _base => AuthService.baseUrl;

  static Future<List<Map<String, dynamic>>> getVenues({String? category}) async {
    try {
      final uri = Uri.parse('$_base/api/venues').replace(
        queryParameters: {
          if (category != null && category != 'All\nProducts')
            'category': category,
        },
      );
      final headers = await AuthService.authHeaders();
      final response = await http.get(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return List<Map<String, dynamic>>.from(body['data'] as List);
      }
    } catch (_) {}
    return [];
  }

  static Future<Map<String, dynamic>?> getVenue(int id) async {
    try {
      final headers = await AuthService.authHeaders();
      final response = await http.get(
        Uri.parse('$_base/api/venues/$id'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return body['data'] as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }
}
