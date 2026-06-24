import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  static const _prefsKey = 'local_reviews';

  static Future<List<Map<String, dynamic>>> getMyReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(raw) as List);
  }

  static Future<Set<int>> getReviewedBookingIds() async {
    final reviews = await getMyReviews();
    return reviews
        .map((r) => r['booking_id'] as int? ?? 0)
        .where((id) => id != 0)
        .toSet();
  }

  static Future<Map<String, dynamic>> submitReview({
    required int bookingId,
    required int venueId,
    required String venueName,
    required int rating,
    String? comment,
  }) async {
    try {
      final reviews = await getMyReviews();
      // Prevent duplicate — replace if exists
      reviews.removeWhere((r) => r['booking_id'] == bookingId);
      reviews.add({
        'booking_id': bookingId,
        'venue_id':   venueId,
        'venue_name': venueName,
        'rating':     rating,
        'comment':    comment ?? '',
        'created_at': DateTime.now().toIso8601String(),
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, jsonEncode(reviews));
      return {'success': true};
    } catch (_) {
      return {'success': false, 'message': 'Gagal menyimpan review'};
    }
  }
}
