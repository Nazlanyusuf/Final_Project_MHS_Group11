import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  static const _key = 'chat_contacts';

  static const _defaults = [
    {'name': 'Elegant Wedding Organizer', 'last': 'How can we help you?', 'time': '10:00', 'unread': 0, 'image_url': ''},
    {'name': 'Amanjiwo Hotel',            'last': 'Message...',           'time': '09:30', 'unread': 2, 'image_url': ''},
    {'name': 'Le Blanc',                  'last': 'Message...',           'time': 'Yesterday', 'unread': 0, 'image_url': ''},
    {'name': 'Pullman Hotel',             'last': 'Message...',           'time': 'Yesterday', 'unread': 1, 'image_url': ''},
  ];

  static Future<List<Map<String, dynamic>>> getContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return List<Map<String, dynamic>>.from(_defaults);
    return List<Map<String, dynamic>>.from(jsonDecode(raw) as List);
  }

  static Future<void> addOrMoveToTop(String venueName, {String? imageUrl}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contacts = await getContacts();
      contacts.removeWhere((c) => c['name'] == venueName);
      contacts.insert(0, {
        'name':      venueName,
        'last':      'Hello! Thank you for your interest.',
        'time':      _fmt(DateTime.now()),
        'unread':    0,
        'image_url': imageUrl ?? '',
      });
      await prefs.setString(_key, jsonEncode(contacts));
    } catch (_) {}
  }

  static Future<void> updateLastMessage(
      String venueName, String lastMsg) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contacts = await getContacts();
      for (final c in contacts) {
        if (c['name'] == venueName) {
          c['last'] = lastMsg;
          c['time'] = _fmt(DateTime.now());
        }
      }
      await prefs.setString(_key, jsonEncode(contacts));
    } catch (_) {}
  }

  static Future<void> markRead(String venueName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contacts = await getContacts();
      for (final c in contacts) {
        if (c['name'] == venueName) c['unread'] = 0;
      }
      await prefs.setString(_key, jsonEncode(contacts));
    } catch (_) {}
  }

  static String _fmt(DateTime dt) {
    final now = DateTime.now();
    if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return 'Yesterday';
  }
}
