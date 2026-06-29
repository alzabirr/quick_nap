import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/sleep_session.dart';
import '../models/sleep_goal.dart';
import '../storage/hive_storage.dart';

class SleepProvider with ChangeNotifier {
  final HiveStorage _storage = HiveStorage();
  List<SleepSession> _sessions = [];
  SleepGoal _goal = SleepGoal();
  
  // Live Tracking state
  bool _isTracking = false;
  DateTime? _trackingStartTime;
  
  // Stream data for graphs
  final List<double> _liveMovement = [];
  final List<double> _liveNoise = [];
  final List<SoundDisturbance> _liveDisturbances = [];
  SleepPhase _livePhase = SleepPhase.light;
  Timer? _liveTimer;
  
  List<SleepSession> get sessions => _sessions;
  SleepGoal get goal => _goal;
  bool get isTracking => _isTracking;
  DateTime? get trackingStartTime => _trackingStartTime;
  
  List<double> get liveMovement => _liveMovement;
  List<double> get liveNoise => _liveNoise;
  List<SoundDisturbance> get liveDisturbances => _liveDisturbances;
  SleepPhase get livePhase => _livePhase;

  SleepProvider() {
    _loadData();
  }

  void _loadData() {
    // Load historical sessions
    final sessionsJson = _storage.getSetting('sessions_list', null);
    if (sessionsJson != null) {
      try {
        final decoded = jsonDecode(sessionsJson as String) as List<dynamic>;
        _sessions = decoded.map((item) => SleepSession.fromJson(item as Map<String, dynamic>)).toList();
      } catch (e) {
        _sessions = [];
      }
    } else {
      _sessions = [];
    }

    // Load goals
    final goalJson = _storage.getSetting('sleep_goal', null);
    if (goalJson != null) {
      try {
        _goal = SleepGoal.fromJson(jsonDecode(goalJson as String) as Map<String, dynamic>);
      } catch (e) {
        _goal = SleepGoal();
      }
    }
    notifyListeners();
  }

  Future<void> saveGoal(SleepGoal newGoal) async {
    _goal = newGoal;
    await _storage.saveSetting('sleep_goal', jsonEncode(newGoal.toJson()));
    notifyListeners();
  }

  Future<void> clearAllSessions() async {
    _sessions.clear();
    await _storage.saveSetting('sessions_list', jsonEncode([]));
    notifyListeners();
  }

  // Live Sleep Tracking Simulator
  void startSleepTracking() {
    _isTracking = true;
    _trackingStartTime = DateTime.now();
    _liveMovement.clear();
    _liveNoise.clear();
    _liveDisturbances.clear();
    _livePhase = SleepPhase.light;
    
    // Prefill some graph history
    for (int i = 0; i < 30; i++) {
      _liveMovement.add(0.05 + Random().nextDouble() * 0.1);
      _liveNoise.add(0.08 + Random().nextDouble() * 0.05);
    }
    
    _liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final rand = Random();
      
      // Simulate slow cycle changes (every 20s simulate a possible phase change)
      if (timer.tick % 20 == 0) {
        final next = rand.nextInt(3);
        _livePhase = SleepPhase.values[next];
      }
      
      // Generate simulated sensor noise/movement based on current phase
      double movement = 0.0;
      double noise = 0.0;
      
      switch (_livePhase) {
        case SleepPhase.deep:
          movement = 0.01 + rand.nextDouble() * 0.04;
          noise = 0.02 + rand.nextDouble() * 0.05;
          break;
        case SleepPhase.light:
          movement = 0.05 + rand.nextDouble() * 0.15;
          noise = 0.08 + rand.nextDouble() * 0.1;
          break;
        case SleepPhase.rem:
          movement = 0.03 + rand.nextDouble() * 0.08;
          noise = 0.05 + rand.nextDouble() * 0.07;
          break;
      }
      
      // Random disturbance trigger (5% chance every second)
      if (rand.nextDouble() < 0.05) {
        final distType = DisturbanceType.values[rand.nextInt(DisturbanceType.values.length)];
        final intensity = 0.5 + rand.nextDouble() * 0.5;
        
        // Spike the graphs
        movement += intensity * 0.6;
        noise += intensity * 0.8;
        
        final disturbance = SoundDisturbance(
          timestamp: DateTime.now(),
          type: distType,
          intensity: intensity,
        );
        _liveDisturbances.add(disturbance);
      }
      
      // Add data points & keep last 40 entries
      _liveMovement.add(movement.clamp(0.0, 1.0));
      _liveNoise.add(noise.clamp(0.0, 1.0));
      if (_liveMovement.length > 40) {
        _liveMovement.removeAt(0);
        _liveNoise.removeAt(0);
      }
      
      notifyListeners();
    });
    
    notifyListeners();
  }

  Future<SleepSession> stopSleepTracking({required int moodRating, required List<String> habits, String? notes}) async {
    _liveTimer?.cancel();
    _isTracking = false;
    
    final endTime = DateTime.now();
    final startTime = _trackingStartTime ?? endTime.subtract(const Duration(hours: 8));
    _trackingStartTime = null;
    
    // Generate realistic session data based on the elapsed time
    // If elapsed time is very short, we inflate it to at least 7.5 hours for demo realism, 
    // unless they actually slept longer.
    final duration = endTime.difference(startTime);
    final isRealSession = duration.inMinutes >= 10;
    
    final DateTime finalStartTime = isRealSession ? startTime : endTime.subtract(const Duration(hours: 7, minutes: 45));
    final double sleepHours = endTime.difference(finalStartTime).inMinutes / 60.0;
    
    // Generate simulated phase chunks
    final List<SleepPhaseSegment> finalPhases = [];
    DateTime currentSegmentStart = finalStartTime;
    
    // We alternate phases: Awake -> Light -> Deep -> REM -> Light ...
    final cyclePhases = [SleepPhase.light, SleepPhase.deep, SleepPhase.rem, SleepPhase.light];
    int cycleIdx = 0;
    while (currentSegmentStart.isBefore(endTime)) {
      final chunkMinutes = 30 + Random().nextInt(45);
      DateTime segmentEnd = currentSegmentStart.add(Duration(minutes: chunkMinutes));
      if (segmentEnd.isAfter(endTime)) segmentEnd = endTime;
      
      finalPhases.add(SleepPhaseSegment(
        startTime: currentSegmentStart,
        endTime: segmentEnd,
        phase: cyclePhases[cycleIdx % cyclePhases.length],
      ));
      
      currentSegmentStart = segmentEnd;
      cycleIdx++;
    }
    
    // Accumulate disturbances
    final List<SoundDisturbance> finalDisturbances = [];
    final rand = Random();
    final disturbanceCount = (sleepHours * (1.2 + rand.nextDouble() * 2)).round();
    for (int i = 0; i < disturbanceCount; i++) {
      final offsetMinutes = rand.nextInt((sleepHours * 60).round());
      final type = DisturbanceType.values[rand.nextInt(DisturbanceType.values.length)];
      finalDisturbances.add(SoundDisturbance(
        timestamp: finalStartTime.add(Duration(minutes: offsetMinutes)),
        type: type,
        intensity: 0.3 + rand.nextDouble() * 0.7,
      ));
    }
    
    // Calculate sleep score
    // - Length: Target sleep (8 hours = 50 points)
    // - Deep Sleep Ratio: Target 20-30% of total sleep (30 points)
    // - Disturbances: Less is better (20 points max)
    int score = 50;
    final minutesSlept = endTime.difference(finalStartTime).inMinutes;
    final durationScore = ((minutesSlept / _goal.targetSleepMinutes) * 50).clamp(0, 50).round();
    
    final deepMinutes = finalPhases
        .where((p) => p.phase == SleepPhase.deep)
        .fold(0, (sum, p) => sum + p.endTime.difference(p.startTime).inMinutes);
    final deepRatio = minutesSlept > 0 ? (deepMinutes / minutesSlept) : 0.0;
    final ratioScore = (deepRatio >= 0.2 && deepRatio <= 0.3) 
        ? 30 
        : (deepRatio > 0.3 ? 25 : (deepRatio * 100).round());
    
    final distPenalty = (finalDisturbances.length * 2.5).clamp(0.0, 20.0).round();
    score = durationScore + ratioScore + (20 - distPenalty);
    score = score.clamp(10, 100);
    
    final newSession = SleepSession(
      startTime: finalStartTime,
      endTime: endTime,
      sleepScore: score,
      phases: finalPhases,
      disturbances: finalDisturbances,
      moodRating: moodRating,
      habits: habits,
      notes: notes,
    );
    
    _sessions.add(newSession);
    
    // Update streaks
    _updateStreaks(newSession);
    
    // Save to local storage
    await _storage.saveSetting('sessions_list', jsonEncode(_sessions.map((s) => s.toJson()).toList()));
    
    notifyListeners();
    return newSession;
  }
  
  void _updateStreaks(SleepSession newSession) {
    // Simulating streak validation
    // If they hit the target sleep consistency, increment streak
    final targetSlept = newSession.duration.inMinutes >= (_goal.targetSleepMinutes - 60);
    
    int newStreak = _goal.currentStreak;
    if (targetSlept) {
      newStreak += 1;
    } else {
      newStreak = 1; // reset or default to 1 for sleeping
    }
    
    final longest = max(newStreak, _goal.longestStreak);
    final badges = List<String>.from(_goal.unlockedBadges);
    
    if (newStreak >= 7 && !badges.contains('7_day_streak')) {
      badges.add('7_day_streak');
    }
    if (newSession.deepSleepPercentage >= 25 && !badges.contains('deep_sleep_master')) {
      badges.add('deep_sleep_master');
    }
    if (newSession.startTime.hour <= 22 && !badges.contains('early_bird')) {
      badges.add('early_bird');
    }
    
    final updatedGoal = _goal.copyWith(
      currentStreak: newStreak,
      longestStreak: longest,
      unlockedBadges: badges,
    );
    saveGoal(updatedGoal);
  }

  // Sleep coaching tips generator
  List<String> getCoachingTips() {
    if (_sessions.isEmpty) {
      return [
        "Consistent bedtimes are key to training your circadian rhythm.",
        "Avoid blue light screens at least 1 hour before you plan to sleep.",
        "Keep your room dark, quiet, and cool (around 65°F / 18°C)."
      ];
    }
    
    final averageScore = _sessions.map((s) => s.sleepScore).reduce((a, b) => a + b) / _sessions.length;
    final habitsCount = <String, int>{};
    for (var s in _sessions) {
      for (var h in s.habits) {
        habitsCount[h] = (habitsCount[h] ?? 0) + 1;
      }
    }
    
    final tips = <String>[];
    
    if (averageScore < 75) {
      tips.add("Your recent sleep scores are lower than optimal. Consider trying a relaxation soundscape 15 mins before sleeping.");
    }
    
    if ((habitsCount['screen_time'] ?? 0) >= 3) {
      tips.add("Screens were used before sleep frequently. The blue light inhibits melatonin production. Try replacing it with a guided meditation.");
    }
    
    if ((habitsCount['caffeine'] ?? 0) >= 3) {
      tips.add("Caffeine impact was flagged several times. Try stopping caffeine intake after 2 PM to let it clear your system.");
    }
    
    if ((habitsCount['exercise'] ?? 0) < 3) {
      tips.add("Adding a light morning or afternoon exercise session could deepen your REM and Deep sleep stages.");
    }

    if (tips.length < 3) {
      tips.add("Go to bed at the exact same time every day, even on weekends, to lock in your biological clock.");
      tips.add("A cool room temperature mimics your body's natural cooling cycle during sleep, aiding deeper recovery.");
    }

    return tips;
  }
}
