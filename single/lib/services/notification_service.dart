import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> requestPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // TEST METHOD: Schedule a notification in 10 seconds
  Future<void> scheduleTestNotification() async {
    try {
      final scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
      
      await flutterLocalNotificationsPlugin.zonedSchedule(
        9999, // Test ID
        'Test Notification 🎉',
        'If you see this, notifications are working perfectly!',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_channel',
            'Test Notifications',
            channelDescription: 'Test notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint('Error scheduling test notification: $e');
      rethrow;
    }
  }

  // Schedule Monthly Anniversary
  Future<void> scheduleMonthlyAnniversary(DateTime startDate) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0, // ID 0 for monthly
        'Happy Monthly Anniversary! ❤️',
        'Another month of love together. Celebrate your special day!',
        _nextMonthlyDate(startDate),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'monthly_anniversary',
            'Monthly Anniversary',
            channelDescription: 'Notifications for monthly anniversaries',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint('Error scheduling monthly anniversary: $e');
      rethrow;
    }
  }

  // Schedule Yearly Anniversary
  Future<void> scheduleYearlyAnniversary(DateTime startDate) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        1, // ID 1 for yearly
        'Happy Anniversary! 🎉',
        'Celebrating another wonderful year together!',
        _nextYearlyDate(startDate),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'yearly_anniversary',
            'Yearly Anniversary',
            channelDescription: 'Notifications for yearly anniversaries',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint('Error scheduling yearly anniversary: $e');
      rethrow;
    }
  }

  // Schedule Milestone Days
  Future<void> scheduleMilestones(DateTime startDate) async {
    try {
      final milestones = [50, 100, 200, 300, 500, 700, 1000, 1500, 2000, 3000];
      
      for (int days in milestones) {
        final milestoneDate = startDate.add(Duration(days: days));
        final now = DateTime.now();

        // Only schedule if the date is in the future
        if (milestoneDate.isAfter(now)) {
          // Use days as ID (e.g., 100, 200) to avoid conflicts
          await flutterLocalNotificationsPlugin.zonedSchedule(
            days, 
            'Happy $days Days! 🥳',
            'You have been together for $days days. What a milestone!',
            tz.TZDateTime.from(milestoneDate, tz.local).add(const Duration(hours: 9)), // 9 AM
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'milestones',
                'Milestones',
                channelDescription: 'Notifications for relationship milestones',
                importance: Importance.high,
                priority: Priority.high,
              ),
              iOS: DarwinNotificationDetails(),
            ),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
        }
      }
    } catch (e) {
      debugPrint('Error scheduling milestones: $e');
      rethrow;
    }
  }

  Future<void> cancelMonthly() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> cancelYearly() async {
    await flutterLocalNotificationsPlugin.cancel(1);
  }

  Future<void> cancelMilestones() async {
    final milestones = [50, 100, 200, 300, 500, 700, 1000, 1500, 2000, 3000];
    for (int id in milestones) {
      await flutterLocalNotificationsPlugin.cancel(id);
    }
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // Helper to calculate next monthly date (9 AM)
  tz.TZDateTime _nextMonthlyDate(DateTime startDate) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      startDate.day,
      9, // 9:00 AM
      0,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Helper to calculate next yearly date (9 AM)
  tz.TZDateTime _nextYearlyDate(DateTime startDate) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      startDate.month,
      startDate.day,
      9, // 9:00 AM
      0,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = tz.TZDateTime(
        tz.local,
        now.year + 1,
        startDate.month,
        startDate.day,
        9,
        0,
      );
    }
    return scheduledDate;
  }
}
