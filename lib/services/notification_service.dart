// Сервис локальных push-уведомлений + ежедневное напоминание
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      tzdata.initializeTimeZones();
      try {
        final localTz = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(localTz));
      } catch (e) {
        debugPrint('TZ error: $e');
      }

      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const settings = InitializationSettings(android: android, iOS: ios);

      await _plugin.initialize(settings);

      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      _initialized = true;
      debugPrint('NotificationService initialized');
    } catch (e) {
      debugPrint('Notification init error: $e');
    }
  }

  Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!_initialized) return;
    try {
      const android = AndroidNotificationDetails(
        'languageland_main',
        'Languageland',
        channelDescription: 'Напоминания об учёбе',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );
      const ios = DarwinNotificationDetails();
      const details = NotificationDetails(android: android, iOS: ios);
      await _plugin.show(id, title, body, details);
    } catch (e) {
      debugPrint('Notification show error: $e');
    }
  }

  /// Ежедневное напоминание в указанное время (по умолчанию 19:00)
  Future<void> scheduleDaily({
    int hour = 19,
    int minute = 0,
  }) async {
    if (!_initialized) return;
    try {
      await _plugin.cancel(5000);

      const android = AndroidNotificationDetails(
        'languageland_daily',
        'Ежедневное напоминание',
        channelDescription: 'Напоминание учиться каждый день',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );
      const ios = DarwinNotificationDetails();
      const details = NotificationDetails(android: android, iOS: ios);

      // Сегодня в 19:00 или завтра, если время прошло
      final now = tz.TZDateTime.now(tz.local);
      var next = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
      if (next.isBefore(now)) {
        next = next.add(const Duration(days: 1));
      }

      await _plugin.zonedSchedule(
        5000,
        '🌸 Пора учиться!',
        'Ая ждёт тебя. Удели японскому 5 минут!',
        next,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // повтор каждый день
      );
      debugPrint('Daily reminder scheduled for $next');
    } catch (e) {
      debugPrint('Schedule daily error: $e');
    }
  }

  Future<void> showStreakReminder(int days) async {
    await show(
      id: 1002,
      title: '🔥 Стрик $days дней!',
      body: 'Не теряй серию — зайди на 5 минут.',
    );
  }

  Future<void> showAchievementUnlocked(String title) async {
    await show(id: 1003, title: '🏆 Новая ачивка!', body: title);
  }

  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } catch (_) {}
  }
}