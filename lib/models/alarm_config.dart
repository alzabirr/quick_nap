import 'package:flutter/material.dart';

class AlarmConfig {
  final int hour;
  final int minute;
  final bool isEnabled;
  final int smartWindowMinutes; // 15, 30, 45, 60, 90 mins
  final String soundName; // e.g. "Forest Rain", "Morning Ambient"
  final bool gradualVolume;
  final String snoozeType; // "shake", "tap"

  AlarmConfig({
    required this.hour,
    required this.minute,
    this.isEnabled = true,
    this.smartWindowMinutes = 30,
    this.soundName = 'Morning Ambient',
    this.gradualVolume = true,
    this.snoozeType = 'shake',
  });

  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  AlarmConfig copyWith({
    int? hour,
    int? minute,
    bool? isEnabled,
    int? smartWindowMinutes,
    String? soundName,
    bool? gradualVolume,
    String? snoozeType,
  }) {
    return AlarmConfig(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isEnabled: isEnabled ?? this.isEnabled,
      smartWindowMinutes: smartWindowMinutes ?? this.smartWindowMinutes,
      soundName: soundName ?? this.soundName,
      gradualVolume: gradualVolume ?? this.gradualVolume,
      snoozeType: snoozeType ?? this.snoozeType,
    );
  }

  Map<String, dynamic> toJson() => {
        'hour': hour,
        'minute': minute,
        'isEnabled': isEnabled,
        'smartWindowMinutes': smartWindowMinutes,
        'soundName': soundName,
        'gradualVolume': gradualVolume,
        'snoozeType': snoozeType,
      };

  factory AlarmConfig.fromJson(Map<String, dynamic> json) {
    return AlarmConfig(
      hour: json['hour'] as int? ?? 7,
      minute: json['minute'] as int? ?? 0,
      isEnabled: json['isEnabled'] as bool? ?? true,
      smartWindowMinutes: json['smartWindowMinutes'] as int? ?? 30,
      soundName: json['soundName'] as String? ?? 'Morning Ambient',
      gradualVolume: json['gradualVolume'] as bool? ?? true,
      snoozeType: json['snoozeType'] as String? ?? 'shake',
    );
  }
}
