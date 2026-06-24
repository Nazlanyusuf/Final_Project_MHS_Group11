import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    if (kIsWeb) return; // flutter_local_notifications tidak support web

    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    if (defaultTargetPlatform == TargetPlatform.android) {
      final impl = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await impl?.requestNotificationsPermission();
      await impl?.requestExactAlarmsPermission();
    }
    _initialized = true;
  }

  static int _toId(String stringId) =>
      int.parse(stringId) % 2147483647;

  static Future<void> scheduleReminder({
    required String id,
    required String title,
    required DateTime scheduledTime,
    String? body,
  }) async {
    if (kIsWeb) return;
    if (scheduledTime.isBefore(DateTime.now())) return;
    await initialize();

    final utc = scheduledTime.toUtc();
    final tzTime = tz.TZDateTime.utc(
      utc.year, utc.month, utc.day, utc.hour, utc.minute,
    );

    await _plugin.zonedSchedule(
      _toId(id),
      title,
      (body != null && body.isNotEmpty) ? body : 'Event reminder sudah tiba!',
      tzTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'event_reminders',
          'Event Reminders',
          channelDescription: 'Notifikasi pengingat event terjadwal',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelReminder(String id) async {
    if (kIsWeb) return;
    await _plugin.cancel(_toId(id));
  }
}
