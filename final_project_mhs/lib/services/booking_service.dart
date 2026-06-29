import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class BookingService {
  static String get _base => AuthService.baseUrl;

  static Future<List<Map<String, dynamic>>> getBookings({String? status}) async {
    try {
      final uri = Uri.parse('$_base/api/bookings').replace(
        queryParameters: {if (status != null) 'status': status},
      );
      final headers = await AuthService.authHeaders();
      final response = await http.get(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as List;
        if (data.isNotEmpty) {
          final first = data.first as Map<String, dynamic>;
          // Debug struktur booking response
          // ignore: avoid_print
          print('BOOKING SAMPLE KEYS (first): ${first.keys.toList()}');
          // ignore: avoid_print
          print('VENUE SAMPLE (completed): ${first['venue']}');
          // ignore: avoid_print
          // Debug: tampilkan kemungkinan field image yang flat
          // ignore: avoid_print
          print('VENUE IMAGE_URL (completed): ${first['image_url'] ?? first['imageUrl'] ?? first['image']}');
          // ignore: avoid_print
          print('VENUE_TITLE (completed): ${first['venue_title']}');
        }
        return List<Map<String, dynamic>>.from(data);
      }
    } catch (_) {}
    return [];
  }

  static Future<Map<String, dynamic>> createBooking({
    required int venueId,
    required String eventDate, // YYYY-MM-DD
    String? eventName,
    int guestCount = 1,
    String? notes,
  }) async {
    try {
      final headers = await AuthService.authHeaders();
      final response = await http.post(
        Uri.parse('$_base/api/bookings'),
        headers: headers,
        body: jsonEncode({
          'venue_id':    venueId,
          'event_date':  eventDate,
          'event_name':  eventName,
          'guest_count': guestCount,
          'notes':       notes,
        }),
      ).timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201) {
        return {'success': true, 'data': body['data']};
      }
      return {'success': false, 'message': body['message'] ?? 'Booking gagal'};
    } catch (_) {
      return {'success': false, 'message': 'Tidak bisa terhubung ke server'};
    }
  }

  static Future<bool> cancelBooking(int bookingId) async {
    try {
      final headers = await AuthService.authHeaders();
      final response = await http.patch(
        Uri.parse('$_base/api/bookings/$bookingId/cancel'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> completeBooking(int bookingId) async {
    try {
      final headers = await AuthService.authHeaders();
      final response = await http.patch(
        Uri.parse('$_base/api/bookings/$bookingId/complete'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
