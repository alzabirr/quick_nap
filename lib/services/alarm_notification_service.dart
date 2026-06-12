import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/alarm_config.dart';

class AlarmNotificationService {
  AlarmNotificationService._();

  static const int _alarmNotificationId = 1001;
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized || kIsWeb) return;

    tz.initializeTimeZones();
    try {
      final localTimezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTimezone.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _notifications.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      ),
    );

    final androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();

    _initialized = true;
  }

  static Future<void> scheduleAlarm(AlarmConfig config) async {
    if (kIsWeb || !config.isEnabled) return;

    try {
      await initialize();
      await _notifications.cancel(id: _alarmNotificationId);

      await _notifications.zonedSchedule(
        id: _alarmNotificationId,
        title: 'Smart Alarm',
        body: 'Time to wake up. Playing: ${config.soundName}',
        scheduledDate: _nextAlarmTime(config),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'smart_alarm',
            'Smart Alarm',
            channelDescription: 'Wake-up alarm notifications',
            importance: Importance.max,
            priority: Priority.max,
            category: AndroidNotificationCategory.alarm,
            fullScreenIntent: true,
            playSound: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
            interruptionLevel: InterruptionLevel.timeSensitive,
          ),
          macOS: DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (error) {
      debugPrint('Alarm notification scheduling failed: $error');
    }
  }

  static Future<void> cancelAlarm() async {
    if (kIsWeb) return;

    try {
      await initialize();
      await _notifications.cancel(id: _alarmNotificationId);
    } catch (error) {
      debugPrint('Alarm notification cancel failed: $error');
    }
  }

  static tz.TZDateTime _nextAlarmTime(AlarmConfig config) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      config.hour,
      config.minute,
    );

    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}
