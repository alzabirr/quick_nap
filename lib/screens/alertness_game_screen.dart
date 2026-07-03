import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nes_ui/nes_ui.dart';
import '../themes/app_theme.dart';
import '../widgets/ambient_background.dart';
import '../widgets/glass_card.dart';

class AlertnessGameScreen extends StatefulWidget {
  const AlertnessGameScreen({super.key});

  @override
  State<AlertnessGameScreen> createState() => _AlertnessGameScreenState();
}

class _AlertnessGameScreenState extends State<AlertnessGameScreen> {
  int _gameState = 0; // 0 = Idle/Start, 1 = Count Down, 2 = Waiting for target, 3 = Target active, 4 = Finished
  int _round = 0;
  final int _totalRounds = 5;
  
  final List<int> _reactionTimesMs = [];
  DateTime? _targetSpawnTime;
  Timer? _spawnTimer;
  
  double _targetX = 0.5;
  double _targetY = 0.5;
  final double _targetSize = 80.0;
  
  int _countdown = 3;
  Timer? _countdownTimer;

  void _startGame() {
    setState(() {
      _gameState = 1;
      _round = 0;
      _reactionTimesMs.clear();
      _countdown = 3;
    });
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() { _countdown--; });
      } else {
        _countdownTimer?.cancel();
        _startNextRound();
      }
    });
  }

  void _startNextRound() {
    if (_round >= _totalRounds) {
      setState(() { _gameState = 4; });
      return;
    }
    
    setState(() { _gameState = 2; _round++; });

    final randomDelayMs = 1500 + Random().nextInt(2000);
    _spawnTimer = Timer(Duration(milliseconds: randomDelayMs), () {
      setState(() {
        _targetX = 0.15 + Random().nextDouble() * 0.7;
        _targetY = 0.2 + Random().nextDouble() * 0.5;
        _gameState = 3;
        _targetSpawnTime = DateTime.now();
      });
    });
  }

  void _onTargetTapped() {
    if (_gameState != 3 || _targetSpawnTime == null) return;
    
    final elapsedMs = DateTime.now().difference(_targetSpawnTime!).inMilliseconds;
    _reactionTimesMs.add(elapsedMs);
    
    _spawnTimer?.cancel();
    _startNextRound();
  }

  double get _averageTime {
    if (_reactionTimesMs.isEmpty) return 0.0;
    return _reactionTimesMs.reduce((a, b) => a + b) / _reactionTimesMs.length;
  }

  String get _alertnessLevel {
    final avg = _averageTime;
    if (avg < 280) return "Fully Alert!";
    if (avg < 400) return "Slightly Groggy";
    return "Need Coffee!";
  }

  String get _alertnessDescription {
    final avg = _averageTime;
    if (avg < 280) return "Outstanding! Your cognitive reaction speeds are in peak shape. You are ready to attack the day.";
    if (avg < 400) return "Decent reaction times, but some sleep inertia remains. A cold splash of water will do wonders.";
    return "Your reaction times are quite slow. Try a guided light stretching session and avoid sleeping in.";
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _spawnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // Standard Header
              Positioned(
                top: 12,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    NesButton(type: NesButtonType.normal, onPressed: () => Navigator.of(context).pop(), child: const Icon(CupertinoIcons.chevron_left, color: Colors.black, size: 20)),
                    const SizedBox(width: 8),
                    Text('MORNING REFLEXES', style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // Game Container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_gameState == 0) ...[
                      NesContainer(padding: const EdgeInsets.all(20), child: const Icon(CupertinoIcons.bolt_horizontal_circle_fill, size: 56, color: Color(0xfff7d51d)))
                          .animate()
                          ..shake()
                          ..scaleXY(begin: 0.8, end: 1.0),
                      const SizedBox(height: 24),
                      Text("Morning Alertness Test", textAlign: TextAlign.center, style: headingStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text("Test your morning cognitive speeds. Pop the target shapes as fast as they appear.", textAlign: TextAlign.center, style: bodyStyle(fontSize: 10, color: textMid, height: 1.5)),
                      const SizedBox(height: 32),
                      NesButton(type: NesButtonType.primary, onPressed: _startGame, child: const Text("START REFLEX TEST")),
                    ] else if (_gameState == 1) ...[
                      Center(child: Text("$_countdown", style: headingStyle(fontSize: 72, fontWeight: FontWeight.bold, color: primary))
                          .animate().scaleXY(begin: 0.5, end: 1.5, duration: 800.ms, curve: Curves.bounceOut)),
                    ] else if (_gameState == 2 || _gameState == 3) ...[
                      Text("Round $_round of $_totalRounds", textAlign: TextAlign.center, style: bodyStyle(fontSize: 10, color: textMid, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(_gameState == 2 ? "Wait for it..." : "TAP!", textAlign: TextAlign.center,
                          style: headingStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _gameState == 3 ? const Color(0xff92cc41) : Colors.white)),
                      const SizedBox(height: 24),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final double gameWidth = constraints.maxWidth;
                          return Container(
                            height: 320,
                            decoration: BoxDecoration(color: surface, border: Border.all(color: textMid, width: 2)),
                            child: Stack(
                              children: [
                                if (_gameState == 3)
                                  Positioned(
                                    left: _targetX * (gameWidth - _targetSize),
                                    top: _targetY * (320 - _targetSize),
                                    child: GestureDetector(
                                      onTapDown: (_) => _onTargetTapped(),
                                      child: Container(
                                        width: _targetSize,
                                        height: _targetSize,
                                        decoration: BoxDecoration(
                                          color: accent,
                                          border: Border.all(color: Colors.white, width: 3),
                                        ),
                                        child: const Center(child: Icon(CupertinoIcons.bolt_fill, color: Colors.white, size: 36)),
                                      ).animate().scale(duration: 150.ms),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ] else if (_gameState == 4) ...[
                      glassCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text("TEST RESULT", style: bodyStyle(fontSize: 8, color: textMid, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(_alertnessLevel, style: headingStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary)),
                            const Divider(color: Color(0xff808080), height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Average Speed", style: bodyStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                Text("${_averageTime.toStringAsFixed(0)} ms", style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(_alertnessDescription, textAlign: TextAlign.center, style: bodyStyle(fontSize: 10, color: textMid, height: 1.4)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      NesButton(type: NesButtonType.normal, onPressed: _startGame, child: Text("TRY AGAIN", style: bodyStyle(fontSize: 10, color: Colors.black))),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
