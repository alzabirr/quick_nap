import 'package:flutter/material.dart';

/// Battery optimization service.
/// Alarm reliability is ensured via AndroidScheduleMode.alarmClock without
/// displaying annoying battery optimization prompts to the user.
class BatteryOptimizationService {
  static Future<void> requestExemptionIfNeeded(BuildContext context) async {
    return;
  }
}
