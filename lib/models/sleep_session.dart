import 'package:uuid/uuid.dart';

enum SleepPhase { light, deep, rem }

class SleepPhaseSegment {
  final DateTime startTime;
  final DateTime endTime;
  final SleepPhase phase;

  SleepPhaseSegment({
    required this.startTime,
    required this.endTime,
    required this.phase,
  });

  Map<String, dynamic> toJson() => {
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'phase': phase.name,
      };

  factory SleepPhaseSegment.fromJson(Map<String, dynamic> json) => SleepPhaseSegment(
        startTime: DateTime.parse(json['startTime'] as String),
        endTime: DateTime.parse(json['endTime'] as String),
        phase: SleepPhase.values.firstWhere((e) => e.name == json['phase']),
      );
}

enum DisturbanceType { snore, cough, talking, externalNoise }

class SoundDisturbance {
  final DateTime timestamp;
  final DisturbanceType type;
  final double intensity; // 0.0 to 1.0

  SoundDisturbance({
    required this.timestamp,
    required this.type,
    required this.intensity,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'type': type.name,
        'intensity': intensity,
      };

  factory SoundDisturbance.fromJson(Map<String, dynamic> json) => SoundDisturbance(
        timestamp: DateTime.parse(json['timestamp'] as String),
        type: DisturbanceType.values.firstWhere((e) => e.name == json['type']),
        intensity: (json['intensity'] as num).toDouble(),
      );
}

class SleepSession {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int sleepScore; // 0 - 100
  final List<SleepPhaseSegment> phases;
  final List<SoundDisturbance> disturbances;
  final int moodRating; // 1 - 5 (morning mood)
  final List<String> habits; // e.g. 'caffeine', 'screen_time', 'stress', 'exercise'
  final String? notes; // Dream diary notes/logs

  SleepSession({
    String? id,
    required this.startTime,
    required this.endTime,
    required this.sleepScore,
    required this.phases,
    required this.disturbances,
    required this.moodRating,
    required this.habits,
    this.notes,
  }) : id = id ?? const Uuid().v4();

  Duration get duration => endTime.difference(startTime);

  double get deepSleepPercentage {
    if (phases.isEmpty) return 0.0;
    final totalDuration = duration.inMinutes;
    if (totalDuration == 0) return 0.0;
    final deepDuration = phases
        .where((p) => p.phase == SleepPhase.deep)
        .fold(0, (sum, p) => sum + p.endTime.difference(p.startTime).inMinutes);
    return (deepDuration / totalDuration) * 100;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'sleepScore': sleepScore,
        'phases': phases.map((p) => p.toJson()).toList(),
        'disturbances': disturbances.map((d) => d.toJson()).toList(),
        'moodRating': moodRating,
        'habits': habits,
        'notes': notes,
      };

  factory SleepSession.fromJson(Map<String, dynamic> json) {
    return SleepSession(
      id: json['id'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      sleepScore: json['sleepScore'] as int,
      phases: (json['phases'] as List<dynamic>?)
              ?.map((e) => SleepPhaseSegment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      disturbances: (json['disturbances'] as List<dynamic>?)
              ?.map((e) => SoundDisturbance.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      moodRating: json['moodRating'] as int? ?? 3,
      habits: (json['habits'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      notes: json['notes'] as String?,
    );
  }
}
