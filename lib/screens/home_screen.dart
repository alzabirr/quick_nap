import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/sleep_session.dart';
import '../themes/app_theme.dart';
import '../providers/sleep_provider.dart';
import '../providers/alarm_provider.dart';
import '../providers/audio_library_provider.dart';
import '../widgets/ambient_background.dart';
import '../widgets/glass_card.dart';
import '../models/alarm_config.dart';
import 'alertness_game_screen.dart';
import 'settings_screen.dart';
import 'sleep_journal_screen.dart';
import 'dream_notes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = 110.0 + MediaQuery.of(context).padding.bottom;
    final alarmProvider = Provider.of<AlarmProvider>(context);
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Main content matching active tab index
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.04, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey<int>(_selectedTabIndex),
                    child: [
                      _buildDashboardTab(bottomPadding),
                      _buildNotesTab(bottomPadding),
                      _buildCoachingTab(bottomPadding),
                      _buildSettingsTab(bottomPadding),
                    ][_selectedTabIndex],
                  ),
                ),
              ),

              // Bottom Navigation Bar
              Positioned(
                bottom: 24 + MediaQuery.of(context).padding.bottom,
                left: 30,
                right: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      height: 68,
                      decoration: BoxDecoration(
                        color: const Color(0xFF16161A).withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavBarItem(0, CupertinoIcons.house),
                          _buildNavBarItem(1, CupertinoIcons.doc_plaintext),
                          _buildNavBarItem(2, CupertinoIcons.square_grid_2x2),
                          _buildNavBarItem(3, CupertinoIcons.person),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Alarm Ringing Overlay (Top-most)
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
                                  },
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [primary, accent]),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Dismiss",
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
      ),
    );
  }

  Widget _buildNavBarItem(int index, IconData icon) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? primary : Colors.transparent,
        ),
        child: Center(
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.65),
            size: 24,
          ),
        ),
      ),
    );
  }

  // ================= TAB 0: DASHBOARD =================
  void _selectPresetAndSetAlarm(Duration duration, String title, String badge) {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    
    // Calculate targeted wake time
    final wakeTime = DateTime.now().add(duration);
    final timeStr = TimeOfDay(hour: wakeTime.hour, minute: wakeTime.minute).format(context);
    
    // Parse duration into hours/minutes
    final hours = duration.inHours;
    final mins = duration.inMinutes % 60;
    
    String hrText = "";
    String minText = "";
    if (hours > 0) {
      hrText = "$hours hr";
      minText = mins > 0 ? "$mins min" : "";
    } else {
      hrText = "$mins min";
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF11141D),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top drag handle
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              
              // Badge/Header
              Text(
                badge.toUpperCase(),
                style: bodyStyle(color: textMid, fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 24),
              
              // Big duration texts
              if (hours > 0) ...[
                Text(
                  hrText,
                  style: headingStyle(fontSize: 56, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                if (minText.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    minText,
                    style: headingStyle(fontSize: 56, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ],
              ] else ...[
                Text(
                  hrText,
                  style: headingStyle(fontSize: 56, fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ],
              const SizedBox(height: 32),
              
              // Wake up time indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.clock, color: Color(0xFF3B82F6), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Wake up at $timeStr",
                    style: bodyStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Info indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.info, color: Colors.white38, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    "Extra 15 mins will be added for falling asleep",
                    style: bodyStyle(color: textMid, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              
              // Set Alarm Button
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  // Actually configure the alarm
                  alarmProvider.updateConfig(alarmProvider.config.copyWith(
                    hour: wakeTime.hour,
                    minute: wakeTime.minute,
                    isEnabled: true,
                  ));
                  
                  Navigator.of(sheetContext).pop(); // close bottom sheet
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$title Preset selected! Smart alarm scheduled for $timeStr'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primary, accent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.3),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Set Alarm",
                      style: bodyStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDashboardTab(double bottomPadding) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding),
      physics: const BouncingScrollPhysics(),
      children: [
        // Set Alarm Section Title
        Text(
          "Set Alarm",
          style: headingStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 16),

        // Preset 1: Power Nap
        GestureDetector(
          onTap: () => _selectPresetAndSetAlarm(const Duration(minutes: 20), "Power Nap", "Power Nap"),
          child: glassCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary,
                  ),
                  child: const Center(
                    child: Icon(CupertinoIcons.bolt_fill, color: Colors.white, size: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Power Nap",
                      style: headingStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "20 Min Booster",
                      style: bodyStyle(color: textMid, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Preset Grid: 1-4 Cycles
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.25,
          children: [
            _buildCycleGridItem(
              cycleNumber: "1",
              cycleBadge: "1 CYCLE",
              timeText: "1h 30m",
              subtitle: "Survival Sleep",
              duration: const Duration(hours: 1, minutes: 30),
            ),
            _buildCycleGridItem(
              cycleNumber: "2",
              cycleBadge: "2 CYCLES",
              timeText: "3h 00m",
              subtitle: "Deep Sleep Peak",
              duration: const Duration(hours: 3),
            ),
            _buildCycleGridItem(
              cycleNumber: "3",
              cycleBadge: "3 CYCLES",
              timeText: "4h 30m",
              subtitle: "Memory Boost",
              duration: const Duration(hours: 4, minutes: 30),
            ),
            _buildCycleGridItem(
              cycleNumber: "4",
              cycleBadge: "4 CYCLES",
              timeText: "6h 00m",
              subtitle: "Functional Rest",
              duration: const Duration(hours: 6),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Preset 5: Recommended 7h 30m Card
        GestureDetector(
          onTap: () => _selectPresetAndSetAlarm(const Duration(hours: 7, minutes: 30), "Recommended Rest", "5 Cycles"),
          child: glassCard(
            opacity: 0.2,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary,
                  ),
                  child: Center(
                    child: Text(
                      "5",
                      style: headingStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "7h 30m",
                            style: headingStyle(fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFFB4169), width: 1.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "RECOMMENDED",
                              style: TextStyle(color: Color(0xFFA78BFA), fontSize: 9, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "5 CYCLES • Optimal for most adults",
                        style: bodyStyle(color: textMid, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Preset 6: 9h 00m Card
        GestureDetector(
          onTap: () => _selectPresetAndSetAlarm(const Duration(hours: 9), "Extended Rest", "6 Cycles"),
          child: glassCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1E293B),
                  ),
                  child: Center(
                    child: Text(
                      "6",
                      style: headingStyle(fontSize: 18, color: textMid, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "9h 00m",
                      style: headingStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Full Rest (6 CYCLES)",
                      style: bodyStyle(color: textMid, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Custom Alarm Trigger Button
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _showCustomAlarmBottomSheet,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: surface.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: textDark.withValues(alpha: 0.08)),
            ),
            child: Center(
              child: Text(
                "Custom Alarm",
                style: bodyStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCycleGridItem({
    required String cycleNumber,
    required String cycleBadge,
    required String timeText,
    required String subtitle,
    required Duration duration,
  }) {
    return GestureDetector(
      onTap: () => _selectPresetAndSetAlarm(duration, "$cycleBadge Rest", cycleBadge),
      child: glassCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1E293B),
                  ),
                  child: Center(
                    child: Text(
                      cycleNumber,
                      style: headingStyle(fontSize: 12, color: textMid, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    cycleBadge,
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeText,
                  style: headingStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: bodyStyle(color: textMid, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= TAB 1: ANALYTICS =================
  Widget _buildAnalyticsTab() {
    final sleepProvider = Provider.of<SleepProvider>(context);

    if (sleepProvider.sessions.isEmpty) {
      return Center(
        child: Text("Track sleep to view analytics logs", style: bodyStyle(color: textMid)),
      );
    }

    final activeSession = sleepProvider.sessions.last;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          "Sleep Trends",
          style: headingStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 18),

        // 1. Sleep phase timeline graph
        glassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SLEEP PHASE WAVEFORM (LAST NIGHT)",
                style: bodyStyle(fontSize: 12, color: textMid, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 100,
                child: CustomPaint(
                  painter: SleepPhasesPainter(phases: activeSession.phases),
                  child: Container(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLegendDot(Colors.blue, "Light"),
                  _buildLegendDot(Colors.indigo, "Deep"),
                  _buildLegendDot(accent, "REM"),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // 2. Disturbances Map
        glassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SOUND DISTURBANCES TIMELINE",
                style: bodyStyle(fontSize: 12, color: textMid, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 80,
                child: CustomPaint(
                  painter: DisturbancesPainter(disturbances: activeSession.disturbances),
                  child: Container(),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Peaks indicate loud sounds (snoring, coughing) detected during tracking.",
                style: bodyStyle(fontSize: 12, color: textMid),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // 3. Weekly consistency trends
        glassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "WEEKLY SLEEP CONSISTENCY",
                style: bodyStyle(fontSize: 12, color: textMid, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 120,
                child: CustomPaint(
                  painter: WeeklyConsistencyPainter(sessions: sleepProvider.sessions),
                  child: Container(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(label, style: bodyStyle(fontSize: 12, color: textMid)),
      ],
    );
  }

  // ================= TAB 2: RELAXATION =================
  Widget _buildRelaxationTab() {
    final audioProvider = Provider.of<AudioLibraryProvider>(context);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      physics: const BouncingScrollPhysics(),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Relaxation Library",
              style: headingStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            // Timer button
            DropdownButton<int>(
              dropdownColor: surface,
              underline: const SizedBox(),
              icon: Icon(CupertinoIcons.timer, color: primary),
              style: bodyStyle(fontSize: 13, color: primary, fontWeight: FontWeight.w700),
              hint: const Text('Timer'),
              value: audioProvider.timerDuration?.inMinutes,
              items: const [
                DropdownMenuItem(value: 15, child: Text('15 min')),
                DropdownMenuItem(value: 30, child: Text('30 min')),
                DropdownMenuItem(value: 45, child: Text('45 min')),
                DropdownMenuItem(value: 60, child: Text('60 min')),
              ],
              onChanged: (val) {
                if (val != null) {
                  audioProvider.setSleepTimer(Duration(minutes: val));
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Grid of tracks
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: audioProvider.tracks.length,
          itemBuilder: (context, index) {
            final track = audioProvider.tracks[index];
            final isPlaying = audioProvider.currentTrack?.id == track.id && audioProvider.isPlaying;
            return GestureDetector(
              onTap: () => audioProvider.playTrack(track),
              child: glassCard(
                opacity: isPlaying ? 0.25 : 0.1,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: primary.withValues(alpha: 0.15),
                          child: Icon(track.icon, color: primary, size: 20),
                        ),
                        if (isPlaying)
                          Icon(CupertinoIcons.play_fill, color: accent, size: 18)
                        else
                          Icon(CupertinoIcons.play, color: textMid, size: 16),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.title,
                          style: bodyStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          track.category.toUpperCase(),
                          style: bodyStyle(fontSize: 10, color: textMid, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMiniAudioPlayer() {
    final audioProvider = Provider.of<AudioLibraryProvider>(context);
    if (audioProvider.currentTrack == null) return const SizedBox();

    return glassCard(
      opacity: 0.28,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(audioProvider.currentTrack!.icon, color: primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  audioProvider.currentTrack!.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: bodyStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                Text(
                  audioProvider.timerDuration != null 
                      ? "Timer active: ${audioProvider.timerDuration!.inMinutes}m" 
                      : "Playing relaxation ambient",
                  style: bodyStyle(fontSize: 11, color: textMid),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(audioProvider.isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill, color: textDark),
            onPressed: () {
              if (audioProvider.isPlaying) {
                audioProvider.pauseTrack();
              } else {
                audioProvider.playTrack(audioProvider.currentTrack!);
              }
            },
          ),
          IconButton(
            icon: Icon(CupertinoIcons.stop_fill, color: textMid),
            onPressed: () => audioProvider.stopTrack(),
          ),
        ],
      ),
    );
  }

  // ================= TAB 3: COACHING & GAMIFICATION =================
  Widget _buildCoachingTab(double bottomPadding) {
    final sleepProvider = Provider.of<SleepProvider>(context);
    final tips = sleepProvider.getCoachingTips();

    return ListView(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPadding),
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          "Sleep Coaching",
          style: headingStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 18),

        // Streaks & Achievements Card
        glassCard(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricColumn(
                icon: CupertinoIcons.flame_fill,
                color: Colors.orange,
                value: "${sleepProvider.goal.currentStreak} Days",
                label: "Sleep Streak",
              ),
              Container(width: 1, height: 40, color: Colors.white10),
              _buildMetricColumn(
                icon: CupertinoIcons.star_fill,
                color: Colors.amber,
                value: "${sleepProvider.goal.unlockedBadges.length}",
                label: "Achievements",
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Launch Game Card
        glassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MORNING REACTION TEST",
                style: bodyStyle(fontSize: 12, color: textMid, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                "Struggling to wake up? Play a quick reflex mini-game to stimulate your mind and clear cognitive fog.",
                style: bodyStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 16),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const AlertnessGameScreen()));
                },
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      "Launch Reflex Test ⚡",
                      style: bodyStyle(color: primary, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // AI Recommendations Section
        Text(
          "AI Coaching Advice",
          style: headingStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ...tips.map((tip) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: glassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(CupertinoIcons.lightbulb_fill, color: Colors.amber, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip,
                      style: bodyStyle(fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMetricColumn({required IconData icon, required Color color, required String value, required String label}) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(value, style: headingStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        Text(label, style: bodyStyle(fontSize: 12, color: textMid)),
      ],
    );
  }

  // ================= TAB 4: SETTINGS =================
  Widget _buildSettingsTab(double bottomPadding) {
    return SettingsScreen(bottomPadding: bottomPadding);
  }

  Widget _buildJournalTab(double bottomPadding) {
    return SleepJournalScreen(bottomPadding: bottomPadding);
  }

  Widget _buildNotesTab(double bottomPadding) {
    return DreamNotesScreen(bottomPadding: bottomPadding);
  }

  void _showCustomAlarmBottomSheet() {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    final initialConfig = alarmProvider.config;
    
    TimeOfDay selectedTime = TimeOfDay(hour: initialConfig.hour, minute: initialConfig.minute);
    int selectedWindow = initialConfig.smartWindowMinutes;
    String selectedSound = initialConfig.soundName;
    bool gradualVolume = initialConfig.gradualVolume;
    String selectedSnooze = initialConfig.snoozeType;

    final List<int> windows = [15, 30, 45, 60, 90];
    final List<String> sounds = ['Morning Ambient', 'Forest Rain', 'Soft Chimes', 'Ocean Breath', 'Birds Chorus'];
    final List<String> snoozes = ['shake', 'tap'];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final now = DateTime.now();
            var alarmDateTime = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
            if (alarmDateTime.isBefore(now)) {
              alarmDateTime = alarmDateTime.add(const Duration(days: 1));
            }
            final timeStr = selectedTime.format(context);

            Future<void> pickTime() async {
              final picked = await showTimePicker(
                context: context,
                initialTime: selectedTime,
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: primary,
                        surface: surface,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() {
                  selectedTime = picked;
                });
              }
            }

            return Container(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 20 + MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: const Color(0xFF11141D),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1.5,
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top drag handle
                    Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Badge/Header
                    Text(
                      "CUSTOM ALARM",
                      style: bodyStyle(color: textMid, fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    
                    // Large clock display
                    GestureDetector(
                      onTap: pickTime,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              timeStr,
                              style: headingStyle(fontSize: 52, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Icon(CupertinoIcons.pencil, color: primary, size: 22),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Smart Wake-up Window Section
                    _buildSectionHeader("Smart Wake-Up Window"),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: windows.map((w) {
                        final isSelected = selectedWindow == w;
                        return GestureDetector(
                          onTap: () => setState(() => selectedWindow = w),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? primary : surface.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              "${w}m",
                              style: bodyStyle(
                                color: isSelected ? Colors.white : textDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),

                    // Sounds and volume section
                    _buildSectionHeader("Wake Up Sounds & Volume"),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surface.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: textDark.withValues(alpha: 0.08)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Sound', style: bodyStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              DropdownButton<String>(
                                value: selectedSound,
                                dropdownColor: surface,
                                style: bodyStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primary),
                                underline: const SizedBox(),
                                items: sounds.map((sound) {
                                  return DropdownMenuItem(value: sound, child: Text(sound));
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) setState(() => selectedSound = value);
                                },
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white10, height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Gradual Volume', style: bodyStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              CupertinoSwitch(
                                value: gradualVolume,
                                activeTrackColor: primary,
                                onChanged: (value) => setState(() => gradualVolume = value),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Snooze Trigger Section
                    _buildSectionHeader("Snooze Trigger"),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: snoozes.map((s) {
                        final isSelected = selectedSnooze == s;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedSnooze = s),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? primary : surface.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected ? Colors.transparent : textDark.withValues(alpha: 0.08),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  s == 'shake' ? '👋 Shake' : '👆 Tap Screen',
                                  style: bodyStyle(
                                    color: isSelected ? Colors.white : textDark,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Set Alarm Button
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        alarmProvider.updateConfig(AlarmConfig(
                          hour: selectedTime.hour,
                          minute: selectedTime.minute,
                          isEnabled: true,
                          smartWindowMinutes: selectedWindow,
                          soundName: selectedSound,
                          gradualVolume: gradualVolume,
                          snoozeType: selectedSnooze,
                        ));
                        
                        Navigator.of(sheetContext).pop();
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Custom smart alarm scheduled for $timeStr'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      child: Container(
                        height: 58,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primary, accent],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withValues(alpha: 0.3),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Set Alarm",
                            style: bodyStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: bodyStyle(color: textMid, fontSize: 11, fontWeight: FontWeight.w800),
      ),
    );
  }
}

// ================= CUSTOM PAINTERS =================

class SleepDialPainter extends CustomPainter {
  final double score;

  SleepDialPainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 10;
    
    // Background arc
    final bgPaint = Paint()
      ..color = Colors.white10
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(center, radius, bgPaint);

    // Glowing arc based on score
    final arcPaint = Paint()
      ..shader = LinearGradient(colors: [primary, accent]).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double sweepAngle = 2 * pi * (score / 100.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant SleepDialPainter oldDelegate) {
    return oldDelegate.score != score;
  }
}

class SleepPhasesPainter extends CustomPainter {
  final List<SleepPhaseSegment> phases;

  SleepPhasesPainter({required this.phases});

  @override
  void paint(Canvas canvas, Size size) {
    if (phases.isEmpty) return;

    final paint = Paint()
      ..color = primary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final double stepWidth = size.width / phases.length;

    for (int i = 0; i < phases.length; i++) {
      final double x = i * stepWidth + (stepWidth / 2);
      
      double y = size.height * 0.5; // default light
      if (phases[i].phase == SleepPhase.deep) {
        y = size.height * 0.8;
      } else if (phases[i].phase == SleepPhase.rem) {
        y = size.height * 0.2;
      }

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Fill points
      final dotPaint = Paint()
        ..color = phases[i].phase == SleepPhase.deep
            ? Colors.indigo
            : (phases[i].phase == SleepPhase.rem ? accent : Colors.blue)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 5, dotPaint);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SleepPhasesPainter oldDelegate) => true;
}

class DisturbancesPainter extends CustomPainter {
  final List<SoundDisturbance> disturbances;

  DisturbancesPainter({required this.disturbances});

  @override
  void paint(Canvas canvas, Size size) {
    if (disturbances.isEmpty) {
      // Draw flat timeline
      final paint = Paint()
        ..color = Colors.white10
        ..strokeWidth = 2.0;
      canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
      return;
    }

    final paintLine = Paint()
      ..color = textMid.withValues(alpha: 0.2)
      ..strokeWidth = 2.0;
    
    canvas.drawLine(Offset(0, size.height * 0.8), Offset(size.width, size.height * 0.8), paintLine);

    final step = size.width / (disturbances.length + 1);
    for (int i = 0; i < disturbances.length; i++) {
      final x = (i + 1) * step;
      final intensity = disturbances[i].intensity;
      final yTop = size.height * 0.8 - (intensity * size.height * 0.7);

      final paintSpike = Paint()
        ..color = accent
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(Offset(x, size.height * 0.8), Offset(x, yTop), paintSpike);
    }
  }

  @override
  bool shouldRepaint(covariant DisturbancesPainter oldDelegate) => true;
}

class WeeklyConsistencyPainter extends CustomPainter {
  final List<SleepSession> sessions;

  WeeklyConsistencyPainter({required this.sessions});

  @override
  void paint(Canvas canvas, Size size) {
    if (sessions.isEmpty) return;

    final paintBar = Paint()
      ..color = primary
      ..style = PaintingStyle.fill;

    final double barWidth = size.width / 15;
    final double spacing = size.width / 10;
    
    final recent = sessions.length > 7 ? sessions.sublist(sessions.length - 7) : sessions;

    for (int i = 0; i < recent.length; i++) {
      final double x = (i + 1) * spacing - (barWidth / 2);
      final double score = recent[i].sleepScore.toDouble();
      final double barHeight = (score / 100.0) * size.height * 0.8;
      final double y = size.height - barHeight;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          const Radius.circular(6),
        ),
        paintBar,
      );

      // Label index day
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: "D${i+1}",
          style: const TextStyle(color: Colors.white60, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(x - 2, size.height + 4));
    }
  }

  @override
  bool shouldRepaint(covariant WeeklyConsistencyPainter oldDelegate) => true;
}
