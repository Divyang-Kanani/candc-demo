import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize notifications (Android only)
  static Future<void> init() async {
    if (!Platform.isAndroid) return;

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    await _plugin.initialize(initSettings);

    // ✅ Request notification permission (Android 13+)
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  /// ✅ Show countdown notification
  static Future<void> showCountdown(String taskName, String timeText) async {
    if (!Platform.isAndroid) return;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'countdown_channel',
          'Countdown Timer',
          channelDescription: 'Shows live countdown during task',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: false,
          ongoing: true,
          autoCancel: false,
          // ✅ Prevents dismissal when tapped
          onlyAlertOnce: true,
          playSound: false,
          visibility: NotificationVisibility.public,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      1, // notification ID
      'Task Running: $taskName',
      'Remaining: $timeText',
      details,
    );
  }

  static Future<void> updateCountdown(String taskName, String timeText) async {
    if (!Platform.isAndroid) return;
    await showCountdown(taskName, timeText);
  }

  static Future<void> cancelCountdown() async {
    if (!Platform.isAndroid) return;
    await _plugin.cancel(1);
  }
}
