import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(android: android, iOS: ios);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == "random") {
          navigatorKey.currentState?.pushNamed('/randomMeal');
        }
      },
    );
  }

  static Future<void> scheduleDailyNotification() async {
    final now = tz.TZDateTime.now(tz.local);

    final time = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      20,
      00,
    );

    final scheduleTime =
    time.isBefore(now) ? time.add(const Duration(days: 1)) : time;

    const androidDetails = AndroidNotificationDetails(
      "daily_channel",
      "Daily Notifications",
      channelDescription: "Daily recipe reminder",
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    await _notifications.zonedSchedule(
      1,
      "Рецепт на денот",
      "Кликни за нов рандом рецепт!",
      scheduleTime,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: "random",
    );
  }

  static Future<void> showTestNotification() async {
    const android = AndroidNotificationDetails(
      "test_channel",
      "Test Notifications",
      importance: Importance.max,
      priority: Priority.high,
    );

    const ios = DarwinNotificationDetails();

    await _notifications.show(
      999,
      "Тест Нотификација",
      "Ова е тест нотификација!",
      const NotificationDetails(android: android, iOS: ios),
      payload: "random",
    );
  }

  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
