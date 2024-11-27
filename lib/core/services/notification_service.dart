import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<PermissionStatus> get permissionStatus =>
      Permission.notification.status;

  Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(android: androidInit);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> requestPermission() async {
    // Check the current status of notification permission
    final status = await permissionStatus;

    if (status.isGranted) {
      debugPrint('Permission already granted.');
    } else if (status.isDenied) {
      // Request permission if it's currently denied
      PermissionStatus newStatus = await Permission.notification.request();
      newStatus = await Permission.notification.request();

      if (newStatus.isGranted) {
        debugPrint('Permission granted after request.');
      } else {
        debugPrint('Permission denied again.');
      }
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied
      debugPrint('Permission permanently denied.');
    }
  }

  Future<void> cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      channelDescription: 'Channel for task reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    // // Instant notification for testing
    // await _flutterLocalNotificationsPlugin.show(
    //   id,
    //   title,
    //   body,
    //   notificationDetails,
    // );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
          DateTime.now().add(const Duration(seconds: 5)), tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
