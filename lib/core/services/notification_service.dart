import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();

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

  static void _onNotificationResponse(NotificationResponse response) {
    // Use your global navigator key to navigate to the medicines screen
    // e.g.: navigatorKey.currentState?.pushNamed('/medicines');
  }
}
