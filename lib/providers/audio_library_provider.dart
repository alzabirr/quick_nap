import 'dart:async';
import 'package:flutter/material.dart';

class SoundTrack {
  final String id;
  final String title;
  final String category; // 'noise', 'nature', 'meditation', 'story'
  final String description;
  final IconData icon;

  SoundTrack({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.icon,
  });
}

class AudioLibraryProvider with ChangeNotifier {
  final List<SoundTrack> _tracks = [
    // White/Brown/Pink Noise
    SoundTrack(
      id: 'brown_noise',
      title: 'Brown Noise',
      category: 'noise',
      description: 'Deep, steady rumble for maximum focus & blocking distractions.',
      icon: Icons.waves,
    ),
    SoundTrack(
      id: 'pink_noise',
      title: 'Pink Noise',
      category: 'noise',
      description: 'Balanced frequency profile resembling gentle, rustling leaves.',
      icon: Icons.grain,
    ),
    // Nature
    SoundTrack(
      id: 'rain_forest',
      title: 'Forest Rain',
      category: 'nature',
      description: 'Relaxing rainfall hitting tropical foliage with distant birds.',
      icon: Icons.umbrella,
    ),
    SoundTrack(
      id: 'ocean_waves',
      title: 'Ocean Tides',
      category: 'nature',
      description: 'Slow rhythmic waves crashing gently on a sandy beach.',
      icon: Icons.water,
    ),
    // Meditation
    SoundTrack(
      id: 'relax_med',
      title: 'Unwind & Release',
      category: 'meditation',
      description: '10-minute guided breathing session to clear physical tension.',
      icon: Icons.self_improvement,
    ),
    SoundTrack(
      id: 'astral_travel',
      title: 'Deep Space Float',
      category: 'meditation',
      description: 'Ambient synthesizer pads creating a floating sensation.',
      icon: Icons.brightness_3,
    ),
    // Sleep stories
    SoundTrack(
      id: 'story_train',
      title: 'The Sleeper Train',
      category: 'story',
      description: 'Journey through the peaceful Swiss Alps under a starry sky.',
      icon: Icons.train,
    ),
  ];

  List<SoundTrack> get tracks => _tracks;

  SoundTrack? _currentTrack;
  bool _isPlaying = false;
  Duration? _timerDuration;
  Duration _elapsed = Duration.zero;
  Timer? _playbackTimer;
  Timer? _countdownTimer;

  SoundTrack? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  Duration? get timerDuration => _timerDuration;
  Duration get elapsed => _elapsed;

  void playTrack(SoundTrack track) {
    if (_currentTrack?.id == track.id && _isPlaying) {
      pauseTrack();
      return;
    }
    
    _currentTrack = track;
    _isPlaying = true;
    _elapsed = Duration.zero;
    
    _startSimulatedPlayback();
    notifyListeners();
  }

  void pauseTrack() {
    _isPlaying = false;
    _playbackTimer?.cancel();
    _countdownTimer?.cancel();
    notifyListeners();
  }

  void stopTrack() {
    _isPlaying = false;
    _currentTrack = null;
    _timerDuration = null;
    _playbackTimer?.cancel();
    _countdownTimer?.cancel();
    notifyListeners();
  }

  void setSleepTimer(Duration? duration) {
    _timerDuration = duration;
    if (duration != null && _isPlaying) {
      _startCountdownTimer();
    }
    notifyListeners();
  }

  void _startSimulatedPlayback() {
    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsed += const Duration(seconds: 1);
      notifyListeners();
    });

    if (_timerDuration != null) {
      _startCountdownTimer();
    }
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer(timerDuration!, () {
      stopTrack();
    });
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }
}
