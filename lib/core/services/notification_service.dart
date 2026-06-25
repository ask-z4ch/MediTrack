import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    initializeTimeZones();

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // Required for Android 8+ (Oreo and above)
    const channel = AndroidNotificationChannel(
      'medicine_reminders',
      'Medicine Reminders',
      description: 'Daily reminders to take your medicines on time',
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> Function(int medicineId, String actionId)? _actionHandler;

  static void setActionHandler(
      Future<void> Function(int medicineId, String actionId) handler) {
    _actionHandler = handler;
  }

  static void _onNotificationResponse(NotificationResponse response) {
    final notificationId = int.tryParse(response.id ?? '');
    if (notificationId == null) return;
    final medicineId = notificationId ~/ 100;
    final actionId = response.actionId;
    if (actionId == null) return;
    _actionHandler?.call(medicineId, actionId);
  }

  static Future<void> scheduleDailyReminder({
    required int notificationId,
    required String medicineName,
    required String dosage,
    required TimeOfDay time,
  }) async {
    await _plugin.zonedSchedule(
      notificationId,
      'Time for $medicineName',
      '$dosage — tap to log',
      _nextInstanceOfTime(time),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_reminders',
          'Medicine Reminders',
          channelDescription: 'Daily medicine reminders',
          importance: Importance.high,
          priority: Priority.high,
          actions: [
            AndroidNotificationAction('taken', 'Mark Taken'),
            AndroidNotificationAction('skip', 'Skip'),
          ],
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static Future<void> cancelReminder(int notificationId) async {
    await _plugin.cancel(notificationId);
  }
}
