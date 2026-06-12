import 'package:flutter/material.dart';

class SleepGoal {
  final int targetSleepMinutes; // e.g. 480 mins (8 hours)
  final int targetBedtimeHour; // e.g. 23 (11 PM)
  final int targetBedtimeMinute;
  final int currentStreak;
  final int longestStreak;
  final List<String> unlockedBadges; // e.g. "7_day_streak", "deep_sleep_master"

  SleepGoal({
    this.targetSleepMinutes = 480,
    this.targetBedtimeHour = 23,
    this.targetBedtimeMinute = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.unlockedBadges = const [],
  });

  TimeOfDay get bedtime => TimeOfDay(hour: targetBedtimeHour, minute: targetBedtimeMinute);

  SleepGoal copyWith({
    int? targetSleepMinutes,
    int? targetBedtimeHour,
    int? targetBedtimeMinute,
    int? currentStreak,
    int? longestStreak,
    List<String>? unlockedBadges,
  }) {
    return SleepGoal(
      targetSleepMinutes: targetSleepMinutes ?? this.targetSleepMinutes,
      targetBedtimeHour: targetBedtimeHour ?? this.targetBedtimeHour,
      targetBedtimeMinute: targetBedtimeMinute ?? this.targetBedtimeMinute,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      unlockedBadges: unlockedBadges ?? this.unlockedBadges,
    );
  }

  Map<String, dynamic> toJson() => {
        'targetSleepMinutes': targetSleepMinutes,
        'targetBedtimeHour': targetBedtimeHour,
        'targetBedtimeMinute': targetBedtimeMinute,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'unlockedBadges': unlockedBadges,
      };

  factory SleepGoal.fromJson(Map<String, dynamic> json) {
    return SleepGoal(
      targetSleepMinutes: json['targetSleepMinutes'] as int? ?? 480,
      targetBedtimeHour: json['targetBedtimeHour'] as int? ?? 23,
      targetBedtimeMinute: json['targetBedtimeMinute'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      unlockedBadges: (json['unlockedBadges'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }
}
