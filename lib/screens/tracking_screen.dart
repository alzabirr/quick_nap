import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/sleep_provider.dart';
import '../providers/alarm_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/ambient_background.dart';
import '../widgets/glass_card.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  final List<String> _selectedHabits = [];
  int _selectedMood = 3;

  final List<Map<String, String>> _availableHabits = [
    {'id': 'caffeine', 'label': 'Caffeine ☕'},
    {'id': 'screen_time', 'label': 'Screen Time 📱'},
    {'id': 'stress', 'label': 'High Stress ⚡'},
    {'id': 'exercise', 'label': 'Exercise 🏃‍♂️'},
  ];

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    
    // Start sleep tracking simulation automatically on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SleepProvider>(context, listen: false).startSleepTracking();
    });
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  void _finishSleep() {
    final notesController = TextEditingController();
    showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: false,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return CupertinoActionSheet(
              title: Text(
                'Good Morning! ☀️',
                style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              message: Text(
                'How do you feel and what did you do before sleeping?',
                style: bodyStyle(color: textMid),
              ),
              actions: [
                Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      children: [
                        Text(
                          'Select your mood:',
                          style: bodyStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            final moodValue = index + 1;
                            final emojis = ['😫', '🥱', '😐', '🙂', '🤩'];
                            final isSelected = _selectedMood == moodValue;
                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  _selectedMood = moodValue;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.symmetric(horizontal: 6),
                                decoration: BoxDecoration(
                                  color: isSelected ? primary.withValues(alpha: 0.2) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? primary : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  emojis[index],
                                  style: const TextStyle(fontSize: 28),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Before bedtime habits:',
                          style: bodyStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          alignment: WrapAlignment.center,
                          children: _availableHabits.map((habit) {
                            final isSelected = _selectedHabits.contains(habit['id']);
                            return FilterChip(
                              label: Text(
                                habit['label']!,
                                style: bodyStyle(
                                  color: isSelected ? Colors.white : textDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: primary,
                              checkmarkColor: Colors.white,
                              backgroundColor: surface.withValues(alpha: 0.5),
                              onSelected: (selected) {
                                setModalState(() {
                                  if (selected) {
                                    _selectedHabits.add(habit['id']!);
                                  } else {
                                    _selectedHabits.remove(habit['id']);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Dream Journal & Notes:',
                          style: bodyStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: surface.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: CupertinoTextField(
                            controller: notesController,
                            placeholder: 'Write down your dreams or how you slept...',
                            placeholderStyle: bodyStyle(color: textMid.withValues(alpha: 0.5)),
                            style: bodyStyle(color: textDark),
                            maxLines: 2,
                            padding: const EdgeInsets.all(12),
                            decoration: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () async {
                  final sleepProvider = Provider.of<SleepProvider>(context, listen: false);
                  // stop sleep session and save to DB
                  await sleepProvider.stopSleepTracking(
                    moodRating: _selectedMood,
                    habits: _selectedHabits,
                    notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
                  );
                  notesController.dispose();
                  if (context.mounted) {
                    Navigator.of(modalContext).pop(); // Dismiss sheet
                    Navigator.of(context).pop();      // Exit tracking screen
                  }
                },
                child: Text(
                  'Save session',
                  style: bodyStyle(color: primary, fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sleepProvider = Provider.of<SleepProvider>(context);
    final alarmProvider = Provider.of<AlarmProvider>(context);

    // Format current time of active session
    final elapsed = sleepProvider.trackingStartTime != null
        ? DateTime.now().difference(sleepProvider.trackingStartTime!)
        : Duration.zero;
    
    final elapsedStr = "${elapsed.inHours.toString().padLeft(2, '0')}:${(elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: Stack(
          children: [
            // Tracking UI
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Exit button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sleep Active",
                          style: headingStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                          icon: Icon(CupertinoIcons.clear_circled, color: textMid),
                          onPressed: () {
                            // Confirm cancellation
                            showCupertinoDialog<void>(
                              context: context,
                              builder: (dialogContext) => CupertinoAlertDialog(
                                title: const Text("Cancel tracking?"),
                                content: const Text("This sleep session will not be saved in your log history."),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text("Keep tracking"),
                                    onPressed: () => Navigator.of(dialogContext).pop(),
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    child: const Text("Discard"),
                                    onPressed: () {
                                      sleepProvider.stopSleepTracking(moodRating: 3, habits: []);
                                      Navigator.of(dialogContext).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    
                    const Spacer(),

                    // Breathing guidance bubble
                    Center(
                      child: AnimatedBuilder(
                        animation: _breathingController,
                        builder: (context, child) {
                          final scale = 1.0 + _breathingController.value * 0.35;
                          return Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  primary.withValues(alpha: 0.5),
                                  accent.withValues(alpha: 0.15),
                                  Colors.transparent,
                                ],
                                stops: const [0.3, 0.8, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primary.withValues(alpha: 0.25 * _breathingController.value),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: 100 * scale,
                                height: 100 * scale,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [primary, accent],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _breathingController.value > 0.5 ? "Inhale" : "Exhale",
                                    style: bodyStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const Spacer(),

                    // Live Session Stats
                    Center(
                      child: Column(
                        children: [
                          Text(
                            elapsedStr,
                            style: headingStyle(fontSize: 48, fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Phase: ${sleepProvider.livePhase.name.toUpperCase()}",
                                style: bodyStyle(color: textMid, fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Real-time Wave Graph (Sound and Movement)
                    glassCard(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Sensor Telemetry",
                                style: bodyStyle(fontSize: 13, color: textMid, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "Mic + Motion Active",
                                style: bodyStyle(fontSize: 11, color: primary, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 80,
                            child: CustomPaint(
                              painter: LiveWavePainter(
                                movementData: sleepProvider.liveMovement,
                                noiseData: sleepProvider.liveNoise,
                              ),
                              child: Container(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (sleepProvider.liveDisturbances.isNotEmpty)
                            Row(
                              children: [
                                Icon(CupertinoIcons.waveform_circle_fill, color: accent, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  "Last Disturbance: ${sleepProvider.liveDisturbances.last.type.name.toUpperCase()}",
                                  style: bodyStyle(color: accent, fontSize: 12, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Wake Up / Stop Button
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: _finishSleep,
                      child: Container(
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            "Stop Tracking & Wake Up",
                            style: bodyStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            
            // Alarm Ringing Overlay
            if (alarmProvider.isRinging)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.95),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [primary, accent]),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.4),
                                blurRadius: 40,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(CupertinoIcons.alarm_fill, size: 56, color: Colors.white),
                        ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                         .shake(hz: 8, curve: Curves.easeInOut)
                         .scaleXY(begin: 0.95, end: 1.05),
                        const SizedBox(height: 36),
                        Text(
                          "Smart Alarm",
                          style: headingStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Playing: ${alarmProvider.config.soundName}",
                          style: bodyStyle(fontSize: 16, color: textMid, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  alarmProvider.snoozeAlarm();
                                },
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Snooze (9m)",
                                      style: bodyStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  alarmProvider.dismissAlarm();
                                  _finishSleep();
                                },
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [primary, accent]),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Wake Up",
                                      style: bodyStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class LiveWavePainter extends CustomPainter {
  final List<double> movementData;
  final List<double> noiseData;

  LiveWavePainter({required this.movementData, required this.noiseData});

  @override
  void paint(Canvas canvas, Size size) {
    if (movementData.isEmpty) return;

    final paintMovement = Paint()
      ..color = primary.withValues(alpha: 0.8)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final paintNoise = Paint()
      ..color = accent.withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final pathMovement = Path();
    final pathNoise = Path();

    final double stepWidth = size.width / 40.0;
    
    // Draw movement curve
    for (int i = 0; i < movementData.length; i++) {
      final double x = i * stepWidth;
      final double y = size.height - (movementData[i] * size.height);
      
      if (i == 0) {
        pathMovement.moveTo(x, y);
      } else {
        pathMovement.lineTo(x, y);
      }
    }

    // Draw noise curve
    for (int i = 0; i < noiseData.length; i++) {
      final double x = i * stepWidth;
      final double y = size.height - (noiseData[i] * size.height * 0.8); // Scale down slightly to separate
      
      if (i == 0) {
        pathNoise.moveTo(x, y);
      } else {
        pathNoise.lineTo(x, y);
      }
    }

    canvas.drawPath(pathMovement, paintMovement);
    canvas.drawPath(pathNoise, paintNoise);
  }

  @override
  bool shouldRepaint(covariant LiveWavePainter oldDelegate) {
    return true; // Simple live animation repaints constantly
  }
}
