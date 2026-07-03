import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_background_trigger/flutter_alarm_background_trigger.dart';
import '../models/alarm_config.dart';
import '../services/alarm_notification_service.dart';
import '../storage/hive_storage.dart';

class AlarmProvider with ChangeNotifier {
  final HiveStorage _storage = HiveStorage();
  late AlarmConfig _config;
  
  // Active ringing state
  bool _isRinging = false;
  Timer? _alarmCheckTimer;
  String? _lastTriggeredMinute;
  StreamSubscription<AlarmItem>? _bgAlarmSubscription;
  
  AlarmConfig get config => _config;
  bool get isRinging => _isRinging;

  AlarmProvider() {
    _loadConfig();
    _startAlarmCheck();
    _listenToBackgroundTrigger();
  }

  /// Listens to alarm events from flutter_alarm_background_trigger.
  /// This fires when the alarm time is reached, even if the app was killed.
  void _listenToBackgroundTrigger() {
    _bgAlarmSubscription = AlarmNotificationService.onAlarmTriggered.listen((alarm) {
      if (!_isRinging && _config.isEnabled) {
        triggerAlarm();
      }
    });
  }

  void _startAlarmCheck() {
    _alarmCheckTimer?.cancel();
    // Poll every 30 seconds as a fallback detection mechanism.
    // The primary trigger comes from flutter_alarm_background_trigger (Android)
    // or the local notification (iOS), but this ensures the alarm fires
    // even if the background trigger is unavailable.
    _alarmCheckTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_config.isEnabled && !_isRinging) {
        final now = DateTime.now();
        final minuteKey = '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}';
        if (now.hour == _config.hour &&
            now.minute == _config.minute &&
            _lastTriggeredMinute != minuteKey) {
          _lastTriggeredMinute = minuteKey;
          triggerAlarm();
        }
      }
    });
  }

  void _loadConfig() {
    final configJson = _storage.getSetting('alarm_config', null);
    if (configJson != null) {
      try {
        _config = AlarmConfig.fromJson(jsonDecode(configJson as String) as Map<String, dynamic>);
      } catch (e) {
        _config = AlarmConfig(hour: 7, minute: 0);
      }
    } else {
      _config = AlarmConfig(hour: 7, minute: 0);
    }
    if (_config.isEnabled) {
      unawaited(AlarmNotificationService.scheduleAlarm(_config));
    }
    notifyListeners();
  }

  Future<void> updateConfig(AlarmConfig newConfig) async {
    _config = newConfig;
    await _storage.saveSetting('alarm_config', jsonEncode(newConfig.toJson()));
    if (newConfig.isEnabled) {
      await AlarmNotificationService.scheduleAlarm(newConfig);
    } else {
      await AlarmNotificationService.cancelAlarm();
    }
    notifyListeners();
  }

  void triggerAlarm() {
    _isRinging = true;
    notifyListeners();
  }

  void dismissAlarm() {
    _isRinging = false;
    AlarmNotificationService.cancelAlarm();
    notifyListeners();
  }

  Future<void> snoozeAlarm() async {
    _isRinging = false;
    // Set alarm for 9 minutes later
    final now = DateTime.now();
    final snoozeTime = now.add(const Duration(minutes: 9));
    _config = _config.copyWith(
      hour: snoozeTime.hour,
      minute: snoozeTime.minute,
    );
    await _storage.saveSetting('alarm_config', jsonEncode(_config.toJson()));
    await AlarmNotificationService.scheduleAlarm(_config);
    notifyListeners();
  }

  /// Reset provider state (used during full app reset)
  void resetState() {
    _config = AlarmConfig(hour: 7, minute: 0);
    _isRinging = false;
    _lastTriggeredMinute = null;
    _alarmCheckTimer?.cancel();
    _startAlarmCheck();
    // Schedule notification for default enabled alarm, matching _loadConfig() pattern
    if (_config.isEnabled) {
      unawaited(AlarmNotificationService.scheduleAlarm(_config));
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _alarmCheckTimer?.cancel();
    _bgAlarmSubscription?.cancel();
    super.dispose();
  }
}
