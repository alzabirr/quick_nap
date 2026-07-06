import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_alarm_background_trigger/flutter_alarm_background_trigger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/alarm_config.dart';

class AlarmNotificationService {
  AlarmNotificationService._();

  static const int _alarmNotificationId = 1001;
  static const String _alarmUid = 'quick_nap_alarm';
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static FlutterAlarmBackgroundTrigger? _backgroundTrigger;

  /// Stream that emits alarm events from the background trigger plugin.
  /// AlarmProvider subscribes to this to trigger the alarm UI.
  static final StreamController<AlarmItem> _alarmEventController =
      StreamController<AlarmItem>.broadcast();

  static Stream<AlarmItem> get onAlarmTriggered => _alarmEventController.stream;

  // Buffer triggered alarms if no one is listening yet (e.g. during startup)
  static final List<AlarmItem> _pendingAlarms = [];
  static List<AlarmItem> get pendingAlarms => List.unmodifiable(_pendingAlarms);
  static void clearPendingAlarms() => _pendingAlarms.clear();

  static bool _initialized = false;
  static bool _backgroundInitialized = false;

  static bool get isBackgroundTriggerAvailable => _backgroundInitialized;

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

    // Initialize background alarm trigger (Android-only)
    await _initBackgroundTrigger();
  }

  static Future<void> _initBackgroundTrigger() async {
    if (_backgroundInitialized) return;

    try {
      FlutterAlarmBackgroundTrigger.initialize();
      _backgroundTrigger = FlutterAlarmBackgroundTrigger();

      // Set up the event handler for when the alarm triggers.
      // This fires whether the app is in foreground, background, or was killed.
      _backgroundTrigger!.onForegroundAlarmEventHandler((alarms) {
        for (final alarm in alarms) {
          if (_alarmEventController.hasListener) {
            _alarmEventController.add(alarm);
          } else {
            _pendingAlarms.add(alarm);
          }
        }
      });

      _backgroundInitialized = true;
      debugPrint('Background alarm trigger initialized');
    } catch (e) {
      // Background trigger is Android-only; silently fall back
      debugPrint('Background alarm trigger not available: $e');
      _backgroundInitialized = false;
    }
  }

  static Future<void> scheduleAlarm(AlarmConfig config) async {
    if (kIsWeb || !config.isEnabled) return;

    // Schedule local notification (cross-platform, works in background)
    try {
      await _notifications.cancel(id: _alarmNotificationId);

      await _notifications.zonedSchedule(
        id: _alarmNotificationId,
        title: 'Quick Nap',
        body: 'Time to wake up!',
        scheduledDate: _nextAlarmTime(config),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'quick_nap_alarm',
            'Quick Nap Alarm',
            channelDescription: 'Wake-up alarm notifications',
            importance: Importance.max,
            priority: Priority.max,
            category: AndroidNotificationCategory.alarm,
            fullScreenIntent: true,
            playSound: true,
            sound: const UriAndroidNotificationSound('content://settings/system/alarm_alert'),
            audioAttributesUsage: AudioAttributesUsage.alarm,
            additionalFlags: Int32List.fromList(<int>[4]),
            enableVibration: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
            interruptionLevel: InterruptionLevel.timeSensitive,
          ),
          macOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      debugPrint('Local notification alarm scheduled for ${config.hour}:${config.minute}');
    } catch (error) {
      debugPrint('Local notification scheduling failed: $error');
    }

    // Also schedule background trigger for maximum reliability
    if (_backgroundTrigger != null) {
      try {
        await _backgroundTrigger!.deleteAlarmsByUid(_alarmUid);

        final alarmTime = _nextAlarmTimeForTrigger(config);
        await _backgroundTrigger!.addAlarm(
          alarmTime,
          uid: _alarmUid,
          payload: {
            'hour': config.hour,
            'minute': config.minute,
            'sound': config.soundName,
          },
          screenWakeDuration: const Duration(minutes: 1),
        );
        debugPrint('Background alarm scheduled for $alarmTime');
      } catch (error) {
        debugPrint('Background alarm scheduling failed: $error');
      }
    }
  }

  static Future<void> cancelAlarm() async {
    if (kIsWeb) return;

    // Cancel local notification
    try {
      await _notifications.cancel(id: _alarmNotificationId);
      debugPrint('Local notification alarm cancelled');
    } catch (error) {
      debugPrint('Local notification cancel failed: $error');
    }

    // Cancel background trigger alarms
    if (_backgroundTrigger != null) {
      try {
        await _backgroundTrigger!.deleteAlarmsByUid(_alarmUid);
        debugPrint('Background alarm cancelled');
      } catch (error) {
        debugPrint('Background alarm cancel failed: $error');
      }
    }
  }

  /// Dispose resources (called from main.dart cleanup)
  static void dispose() {
    _alarmEventController.close();
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

  /// Returns the next alarm DateTime for the background trigger plugin.
  static DateTime _nextAlarmTimeForTrigger(AlarmConfig config) {
    final now = DateTime.now();
    var scheduled = DateTime(
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
