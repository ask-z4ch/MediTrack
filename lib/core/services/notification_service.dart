import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static BuildContext? _appContext;

  static void setContext(BuildContext context) {
    _appContext = context;
  }

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
    const medicineChannel = AndroidNotificationChannel(
      'medicine_reminders',
      'Medicine Reminders',
      description: 'Daily reminders to take your medicines on time',
      importance: Importance.high,
    );
    const doctorChannel = AndroidNotificationChannel(
      'doctor_reminders',
      'Doctor Reminders',
      description: 'Upcoming appointment reminders',
      importance: Importance.high,
    );
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(medicineChannel);
    await androidPlugin?.createNotificationChannel(doctorChannel);
  }

  static Future<bool> requestExactAlarmPermission() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final canSchedule = await androidPlugin?.canScheduleExactNotifications();
    if (canSchedule == true) return true;
    await androidPlugin?.requestExactAlarmsPermission();
    return false;
  }

  static Future<void> Function(int medicineId, String actionId)? _actionHandler;

  static void setActionHandler(
      Future<void> Function(int medicineId, String actionId) handler) {
    _actionHandler = handler;
  }

  static Future<void> Function(
      int medicineId, int originalNotificationId, Duration duration)?
      _snoozeHandler;

  static void setSnoozeHandler(
    Future<void> Function(
            int medicineId, int originalNotificationId, Duration duration)
        handler,
  ) {
    _snoozeHandler = handler;
  }

  static void _onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == 'medicine') {
      _navigate('/medicines');
      return;
    }
    if (payload == 'followup') {
      _navigate('/doctor-visits');
      return;
    }

    final notificationId = int.tryParse(response.id?.toString() ?? '');
    if (notificationId == null) return;
    final medicineId = notificationId ~/ 100;
    final actionId = response.actionId;
    if (actionId == null) return;

    if (actionId == 'snooze') {
      _showSnoozeSheet(medicineId, notificationId);
    } else {
      _actionHandler?.call(medicineId, actionId);
    }
  }

  static void _navigate(String path) {
    final context = _appContext;
    if (context != null) {
      context.go(path);
    }
  }

  static void _showSnoozeSheet(int medicineId, int originalNotificationId) {
    final context = _appContext;
    if (context == null) return;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Snooze for how long?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('10 minutes'),
                leading: const Icon(Icons.timer_outlined),
                onTap: () {
                  Navigator.pop(ctx);
                  _snoozeHandler?.call(
                    medicineId,
                    originalNotificationId,
                    const Duration(minutes: 10),
                  );
                },
              ),
              ListTile(
                title: const Text('30 minutes'),
                leading: const Icon(Icons.timer_outlined),
                onTap: () {
                  Navigator.pop(ctx);
                  _snoozeHandler?.call(
                    medicineId,
                    originalNotificationId,
                    const Duration(minutes: 30),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
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
            AndroidNotificationAction('snooze', 'Snooze'),
          ],
        ),
      ),
      payload: 'medicine',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> scheduleSnooze({
    required int notificationId,
    required String medicineName,
    required Duration duration,
  }) async {
    await _plugin.zonedSchedule(
      notificationId + 500000,
      'Reminder: $medicineName',
      'You snoozed this reminder',
      tz.TZDateTime.now(tz.local).add(duration),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_reminders',
          'Medicine Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
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

  static Future<void> scheduleOneTimeReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledAt, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'doctor_reminders',
          'Doctor Reminders',
          channelDescription: 'Upcoming appointment reminders',
          importance: Importance.high,
        ),
      ),
      payload: 'followup',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelReminder(int notificationId) async {
    await _plugin.cancel(notificationId);
  }
}
