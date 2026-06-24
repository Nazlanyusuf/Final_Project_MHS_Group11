import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityLogService {
  static const _key = 'activity_log';

  static Future<List<Map<String, dynamic>>> getActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = List<Map<String, dynamic>>.from(jsonDecode(raw) as List);
    list.sort((a, b) {
      final da = DateTime.tryParse(a['time'] as String? ?? '') ?? DateTime(2000);
      final db = DateTime.tryParse(b['time'] as String? ?? '') ?? DateTime(2000);
      return db.compareTo(da);
    });
    return list;
  }

  static Future<void> log({
    required String type,
    required String title,
    required String subtitle,
    String? imageUrl,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      final list = raw == null
          ? <Map<String, dynamic>>[]
          : List<Map<String, dynamic>>.from(jsonDecode(raw) as List);
      list.add({
        'type': type,
        'title': title,
        'subtitle': subtitle,
        'image_url': imageUrl ?? '',
        'time': DateTime.now().toIso8601String(),
      });
      final trimmed = list.length > 100 ? list.sublist(list.length - 100) : list;
      await prefs.setString(_key, jsonEncode(trimmed));
    } catch (_) {}
  }

  static Future<void> markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'activity_log_seen', DateTime.now().toIso8601String());
  }

  static Future<bool> hasUnseen() async {
    final prefs = await SharedPreferences.getInstance();
    final seenRaw = prefs.getString('activity_log_seen');
    final activities = await getActivities();
    if (activities.isEmpty) return false;
    if (seenRaw == null) return true;
    final lastSeen = DateTime.tryParse(seenRaw);
    if (lastSeen == null) return true;
    return activities.any((a) {
      final t = DateTime.tryParse(a['time'] as String? ?? '');
      return t != null && t.isAfter(lastSeen);
    });
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
