import 'package:flutter/foundation.dart';

/// Сервис уведомлений для push-уведомлений и напоминаний
/// Notification service for push notifications and reminders
class NotificationService {
  // Синглтон для доступа из всего приложения
  // Singleton pattern for app-wide access
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  static NotificationService get instance => _instance;

  /// Инициализация сервиса уведомлений (вызывается в main.dart)
  /// Initialize notification service (called from main.dart)
  Future<void> init() async {
    try {
      debugPrint('✓ NotificationService инициализирован');
    } catch (e) {
      debugPrint('✗ Ошибка инициализации NotificationService: $e');
    }
  }

  /// Отправить уведомление о напоминании стрика (streak reminder)
  /// Show streak reminder notification
  /// [days] - количество дней текущего стрика / number of streak days
  /// Пример: если пользователь занимался 5 дней подряд, покажем уведомление
  Future<void> showStreakReminder(int days) async {
    try {
      // TODO: Интегрировать с реальным сервисом уведомлений (Firebase, local_notifications)
      // TODO: Integrate with real notification service (Firebase, local_notifications)
      debugPrint('🔔 Напоминание: Текущий стрик - $days дней! 🔥');
      debugPrint('   (Streak reminder: $days days! 🔥)');
    } catch (e) {
      debugPrint('✗ Ошибка при отправке streak reminder: $e');
    }
  }

  /// Отправить уведомление о разблокировке ачивки
  /// Show achievement unlocked notification
  /// [title] - название ачивки / achievement title
  /// Пример: "Ты выучил 50 иероглифов!"
  Future<void> showAchievementUnlocked(String title) async {
    try {
      // TODO: Интегрировать с реальным сервисом уведомлений
      // TODO: Integrate with real notification service
      debugPrint('🏆 Ачивка разблокирована: $title');
      debugPrint('   (Achievement unlocked: $title)');
    } catch (e) {
      debugPrint('✗ Ошибка при отправке achievement notification: $e');
    }
  }

  /// Отправить обычное уведомление
  /// Send generic notification
  /// [title] - заголовок / title
  /// [body] - текст уведомления / notification body
  Future<void> show({
    required String title,
    required String body,
  }) async {
    try {
      debugPrint('📱 Уведомление: $title - $body');
    } catch (e) {
      debugPrint('✗ Ошибка при отправке notification: $e');
    }
  }

  /// Запланировать ежедневное напоминание на определённое время
  /// Schedule daily reminder at specific time
  /// [hour] - час (0-23) / hour (0-23)
  /// [minute] - минута (0-59) / minute (0-59)
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
  }) async {
    try {
      // TODO: Интегрировать с real scheduled notifications
      // TODO: Integrate with real scheduled notifications library
      debugPrint('📅 Ежедневное напоминание запланировано на $hour:${minute.toString().padLeft(2, '0')}');
    } catch (e) {
      debugPrint('✗ Ошибка при планировании daily reminder: $e');
    }
  }
}
