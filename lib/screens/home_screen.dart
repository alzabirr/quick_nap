import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:nes_ui/nes_ui.dart';
import '../themes/app_theme.dart';
import '../providers/alarm_provider.dart';
import '../widgets/ambient_background.dart';
import '../widgets/glass_card.dart';
import '../models/alarm_config.dart';
import '../storage/hive_storage.dart';
import 'settings_screen.dart';
import 'dream_notes_screen.dart';
import 'brain_games_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  Duration? _activeAlarmDuration;

  @override
  void initState() {
    super.initState();
    final storedDuration = HiveStorage().getSetting('active_alarm_duration', null);
    if (storedDuration != null) {
      _activeAlarmDuration = Duration(minutes: storedDuration as int);
    }
  }

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
                      _buildBrainGamesTab(bottomPadding),
                      _buildCoachingTab(bottomPadding),
                      _buildSettingsTab(bottomPadding),
                    ][_selectedTabIndex],
                  ),
                ),
              ),

              // Bottom Navigation Bar (NES-styled)
              Positioned(
                bottom: 12 + MediaQuery.of(context).padding.bottom,
                left: 24,
                right: 24,
                child: NesContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(child: _buildNavBarItem(0, CupertinoIcons.house_fill)),
                      Flexible(child: _buildNavBarItem(1, CupertinoIcons.doc_text_fill)),
                      Flexible(child: _buildNavBarItem(2, CupertinoIcons.gamecontroller_fill)),
                      Flexible(child: _buildNavBarItem(3, CupertinoIcons.moon_stars_fill)),
                      Flexible(child: _buildNavBarItem(4, CupertinoIcons.gear_alt_fill)),
                    ],
                  ),
                ),
              ),

              // Alarm Ringing Overlay
              if (alarmProvider.isRinging)
                Positioned.fill(
                  child: Container(
                    color: const Color(0xff0d0d0d),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          NesContainer(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                const Icon(CupertinoIcons.alarm_fill, size: 48, color: Color(0xffffffff)),
                                const SizedBox(height: 16),
                                Text(
                                  "TIME TO WAKE UP!",
                                  style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                                 .shimmer(duration: 600.ms, color: const Color(0xffe76e55)),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Expanded(
                                child: NesButton(
                                  type: NesButtonType.normal,
                                  onPressed: () {
                                    alarmProvider.dismissAlarm();
                                    setState(() {
                                      _activeAlarmDuration = null;
                                    });
                                    HiveStorage().saveSetting('active_alarm_duration', null);
                                    final random = Random();
                                    final gameConstructors = <Widget Function()>[
                                      () => const MemoryMatchGame(),
                                      () => const ColorReactionGame(),
                                      () => const WordScrambleGame(),
                                      () => const SimonSaysGame(),
                                      () => const TicTacToeGame(),
                                      () => const BubblePopGame(),
                                      () => const TypingSpeedGame(),
                                      () => const PuzzleSlideGame(),
                                      () => const ColorCatchGame(),
                                      () => const WordChainGame(),
                                      () => const RapidTapGame(),
                                    ];
                                    final selectedGame = gameConstructors[random.nextInt(gameConstructors.length)]();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => selectedGame),
                                    );
                                  },
                                  child: Text(
                                    "PLAY GAME",
                                    style: bodyStyle(fontSize: 10, color: Colors.black),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: NesButton(
                                  type: NesButtonType.error,
                                  onPressed: () {
                                    alarmProvider.dismissAlarm();
                                    setState(() {
                                      _activeAlarmDuration = null;
                                    });
                                    HiveStorage().saveSetting('active_alarm_duration', null);
                                  },
                                  child: Text(
                                    "DISMISS",
                                    style: bodyStyle(fontSize: 10),
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
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.2) : Colors.transparent,
          border: isSelected ? Border.all(color: primary, width: 2) : null,
        ),
        child: Icon(
          icon,
          color: isSelected ? primary : textMid,
          size: 22,
        ),
      ),
    );
  }

  void _cancelActiveAlarm() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surface,
        title: Text('Cancel Alarm?', style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to cancel this alarm?', style: bodyStyle(fontSize: 10, color: textMid)),
        actions: [
          NesButton(
            type: NesButtonType.normal,
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('No', style: bodyStyle(fontSize: 10, color: isDarkMode ? Colors.white : Colors.black)),
          ),
          NesButton(
            type: NesButtonType.error,
            onPressed: () {
              Navigator.of(ctx).pop();
              final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
              alarmProvider.updateConfig(alarmProvider.config.copyWith(isEnabled: false));
              setState(() {
                _activeAlarmDuration = null;
              });
              HiveStorage().saveSetting('active_alarm_duration', null);
              NesSnackbar.show(context, text: 'Alarm cancelled');
            },
            child: Text('Yes', style: bodyStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  void _selectPresetAndSetAlarm(Duration duration, String title, String badge) {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    
    final wakeTime = DateTime.now().add(duration);
    final timeStr = TimeOfDay(hour: wakeTime.hour, minute: wakeTime.minute).format(context);
    
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
      barrierColor: const Color(0x80000000),
      isScrollControlled: true,
      builder: (sheetContext) {
        return NesContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                badge.toUpperCase(),
                style: bodyStyle(fontSize: 10, color: textMid, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                hrText,
                style: headingStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              if (minText.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  minText,
                  style: headingStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.clock, color: Color(0xff209cee), size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "Wake up at $timeStr",
                    style: bodyStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Extra 15 mins for falling asleep",
                style: bodyStyle(fontSize: 8, color: textMid),
              ),
              const SizedBox(height: 24),
              NesButton(
                type: NesButtonType.primary,
                onPressed: () {
                  alarmProvider.updateConfig(alarmProvider.config.copyWith(
                    hour: wakeTime.hour,
                    minute: wakeTime.minute,
                    isEnabled: true,
                  ));
                  
                  setState(() {
                    _activeAlarmDuration = duration;
                  });
                  HiveStorage().saveSetting('active_alarm_duration', duration.inMinutes);
                  
                  Navigator.of(sheetContext).pop();
                  NesSnackbar.show(context, text: '$title alarm set for $timeStr');
                },
                child: const Text('SET ALARM'),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= TAB 0: DASHBOARD =================
  Widget _buildDashboardTab(double bottomPadding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pinned Header Row
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Text(
                'QUICK NAP',
                style: headingStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(20, 4, 20, bottomPadding),
            physics: const BouncingScrollPhysics(),
            children: [
              // Power Nap Card
              GestureDetector(
                onTap: _activeAlarmDuration == const Duration(minutes: 20)
                    ? _cancelActiveAlarm
                    : () => _selectPresetAndSetAlarm(const Duration(minutes: 20), "Power Nap", "Power Nap"),
                child: glassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _activeAlarmDuration == const Duration(minutes: 20)
                              ? successColor
                              : primary,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Icon(
                            _activeAlarmDuration == const Duration(minutes: 20) ? CupertinoIcons.check_mark : CupertinoIcons.bolt_fill,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "POWER NAP",
                            style: bodyStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _activeAlarmDuration == const Duration(minutes: 20) ? "Tap to cancel" : "20 Min Booster",
                            style: bodyStyle(
                              color: _activeAlarmDuration == const Duration(minutes: 20) ? successColor : textMid,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Sleep Cycles
              Text(
                "SLEEP CYCLES",
                style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
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
              const SizedBox(height: 24),

              // Recommended
              Text(
                "RECOMMENDED",
                style: headingStyle(fontSize: 12, color: primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 7h 30m Card
              GestureDetector(
                onTap: _activeAlarmDuration == const Duration(hours: 7, minutes: 30)
                    ? _cancelActiveAlarm
                    : () => _selectPresetAndSetAlarm(const Duration(hours: 7, minutes: 30), "Recommended Rest", "5 Cycles"),
                child: glassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _activeAlarmDuration == const Duration(hours: 7, minutes: 30) ? successColor : primary,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: _activeAlarmDuration == const Duration(hours: 7, minutes: 30)
                              ? const Icon(CupertinoIcons.check_mark, color: Colors.white, size: 18)
                              : Text("5", style: bodyStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("7h 30m", style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _activeAlarmDuration == const Duration(hours: 7, minutes: 30) ? successColor : primary,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    _activeAlarmDuration == const Duration(hours: 7, minutes: 30) ? "ALARM SET" : "RECOMMENDED",
                                    style: TextStyle(
                                      color: _activeAlarmDuration == const Duration(hours: 7, minutes: 30) ? successColor : warningColor,
                                      fontSize: 8,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              _activeAlarmDuration == const Duration(hours: 7, minutes: 30) ? "Tap to cancel" : "5 Cycles - Optimal",
                              style: bodyStyle(color: _activeAlarmDuration == const Duration(hours: 7, minutes: 30) ? successColor : textMid, fontSize: 8),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 9h 00m Card
              GestureDetector(
                onTap: _activeAlarmDuration == const Duration(hours: 9)
                    ? _cancelActiveAlarm
                    : () => _selectPresetAndSetAlarm(const Duration(hours: 9), "Extended Rest", "6 Cycles"),
                child: glassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _activeAlarmDuration == const Duration(hours: 9) ? successColor : surface,
                          border: Border.all(color: textMid, width: 2),
                        ),
                        child: Center(
                          child: _activeAlarmDuration == const Duration(hours: 9)
                              ? const Icon(CupertinoIcons.check_mark, color: Colors.white, size: 18)
                              : Text("6", style: bodyStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textMid)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("9h 00m", style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text(
                              _activeAlarmDuration == const Duration(hours: 9) ? "Tap to cancel" : "Full Rest (6 Cycles)",
                              style: bodyStyle(color: _activeAlarmDuration == const Duration(hours: 9) ? successColor : textMid, fontSize: 10),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Custom Alarm Button or Active Alarm Display
              () {
                final alarmProvider = Provider.of<AlarmProvider>(context);
                return alarmProvider.config.isEnabled
                    ? GestureDetector(
                        onTap: _cancelActiveAlarm,
                        child: glassCard(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: successColor,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Center(
                                  child: Icon(
                                    CupertinoIcons.alarm,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ALARM ACTIVE",
                                      style: bodyStyle(fontSize: 10, color: successColor, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Set for ${TimeOfDay(hour: alarmProvider.config.hour, minute: alarmProvider.config.minute).format(context)}",
                                      style: headingStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Tap to cancel",
                                      style: bodyStyle(fontSize: 8, color: textMid),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : NesButton(
                        type: NesButtonType.normal,
                        onPressed: _showCustomAlarmBottomSheet,
                        child: Text("CUSTOM ALARM", style: bodyStyle(fontSize: 10, color: isDarkMode ? Colors.white : Colors.black)),
                      );
              }(),
              const SizedBox(height: 16),
            ],
          ),
        ),
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
    final isActive = _activeAlarmDuration == duration;
    return GestureDetector(
      onTap: isActive
          ? _cancelActiveAlarm
          : () => _selectPresetAndSetAlarm(duration, "$cycleBadge Rest", cycleBadge),
      child: glassCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isActive ? successColor : surface,
                    border: Border.all(color: isActive ? successColor : textMid, width: 2),
                  ),
                  child: Center(
                    child: isActive
                        ? const Icon(CupertinoIcons.check_mark, color: Colors.white, size: 12)
                        : Text(cycleNumber, style: bodyStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textDark)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: isActive ? successColor.withValues(alpha: 0.2) : surface,
                    border: isActive ? Border.all(color: successColor, width: 1) : Border.all(color: textMid.withValues(alpha: 0.3), width: 1),
                  ),
                  child: Text(
                    cycleBadge,
                    style: TextStyle(
                      color: isActive ? successColor : textDark,
                      fontSize: 8,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(timeText, style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(
                  isActive ? "Tap to cancel" : subtitle,
                  style: bodyStyle(color: isActive ? successColor : textMid, fontSize: 8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= TAB 3: COACHING =================
  Widget _buildCoachingTab(double bottomPadding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pinned Header Row
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("COACHING", style: headingStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("Nap Guide", style: bodyStyle(fontSize: 8, color: textMid)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(20, 4, 20, bottomPadding),
            physics: const BouncingScrollPhysics(),
            children: [
              Text("PROS", style: bodyStyle(fontSize: 10, color: successColor, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildInfoCard(icon: CupertinoIcons.bolt_fill, color: successColor, title: "Boosts Energy", subtitle: "A short nap can quickly reduce fatigue and help you feel refreshed."),
              const SizedBox(height: 8),
              _buildInfoCard(icon: CupertinoIcons.eye_fill, color: successColor, title: "Improves Focus", subtitle: "Helps you stay alert, make fewer mistakes, and perform better."),
              const SizedBox(height: 8),
              _buildInfoCard(icon: CupertinoIcons.book_fill, color: successColor, title: "Enhances Memory", subtitle: "Can improve learning, memory retention, and problem-solving."),
              const SizedBox(height: 8),
              _buildInfoCard(icon: CupertinoIcons.smiley_fill, color: successColor, title: "Improves Mood", subtitle: "A quick nap may reduce stress, irritability, and improve mood."),
              const SizedBox(height: 8),
              _buildInfoCard(icon: CupertinoIcons.heart_fill, color: successColor, title: "Supports Heart Health", subtitle: "Some studies suggest occasional naps may help the cardiovascular system."),
              const SizedBox(height: 16),

              Text("CONS", style: bodyStyle(fontSize: 10, color: accent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildInfoCard(icon: CupertinoIcons.exclamationmark_triangle_fill, color: accent, title: "Sleep Inertia", subtitle: "Napping over 30 minutes can leave you feeling groggy and disoriented."),
              const SizedBox(height: 8),
              _buildInfoCard(icon: CupertinoIcons.moon_fill, color: accent, title: "Disrupts Night Sleep", subtitle: "Late afternoon or evening naps can make it harder to fall asleep."),
              const SizedBox(height: 8),
              _buildInfoCard(icon: CupertinoIcons.question_circle_fill, color: accent, title: "Not for Everyone", subtitle: "Some people wake up feeling more tired instead of refreshed."),
              const SizedBox(height: 16),



              Text("RECOMMENDED NAP LENGTHS", style: bodyStyle(fontSize: 10, color: textMid, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              glassCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _buildDurationRow("10-20 min", "Best for quick energy boost"),
                    const Divider(color: Color(0xff808080), height: 16),
                    _buildDurationRow("20-30 min", "Still beneficial, slight grogginess"),
                    const Divider(color: Color(0xff808080), height: 16),
                    _buildDurationRow("60 min", "Improves memory, grogginess likely"),
                    const Divider(color: Color(0xff808080), height: 16),
                    _buildDurationRow("90 min", "Full sleep cycle, reduces grogginess"),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text("OVERALL", style: bodyStyle(fontSize: 10, color: textMid, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              glassCard(
                padding: const EdgeInsets.all(12),
                child: Text(
                  "A 10-20 minute quick nap is generally the most effective choice. It provides a noticeable boost in energy, focus, and mood while minimizing grogginess.",
                  style: bodyStyle(fontSize: 10, height: 1.5),
                ),
              ),
        const SizedBox(height: 16),
      ],
    ),
  ),
],
);
}

  Widget _buildInfoCard({required IconData icon, required Color color, required String title, required String subtitle}) {
    return glassCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              border: Border.all(color: color, width: 1),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: bodyStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle, style: bodyStyle(fontSize: 8, color: textMid, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDurationRow(String duration, String effect) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.2),
            border: Border.all(color: primary, width: 1),
          ),
          child: Text(duration, style: bodyStyle(fontSize: 8, fontWeight: FontWeight.bold, color: primary)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(effect, style: bodyStyle(fontSize: 8, color: textMid, height: 1.4)),
        ),
      ],
    );
  }

  // ================= TAB 4: SETTINGS =================
  Widget _buildSettingsTab(double bottomPadding) {
    return SettingsScreen(bottomPadding: bottomPadding);
  }

  Widget _buildNotesTab(double bottomPadding) {
    return DreamNotesScreen(bottomPadding: bottomPadding);
  }

  Widget _buildBrainGamesTab(double bottomPadding) {
    return const BrainGamesScreen();
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
    final List<String> snoozes = ['shake', 'tap'];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x80000000),
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
              );
              if (picked != null) {
                setState(() {
                  selectedTime = picked;
                });
              }
            }

            return NesContainer(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("CUSTOM ALARM", style: bodyStyle(fontSize: 10, color: textMid, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    
                    // Large clock display
                    GestureDetector(
                      onTap: pickTime,
                      child: NesContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  timeStr,
                                  style: headingStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(CupertinoIcons.pencil, color: primary, size: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Smart Wake-up Window
                    Text("SMART WAKE-UP WINDOW", style: bodyStyle(fontSize: 8, color: textMid, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: windows.map((w) {
                        final isSelected = selectedWindow == w;
                        return GestureDetector(
                          onTap: () => setState(() => selectedWindow = w),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? primary : surface,
                              border: Border.all(color: isSelected ? Colors.white : textMid, width: 1),
                            ),
                            child: Text("${w}m", style: bodyStyle(
                              color: isSelected ? Colors.white : textMid,
                              fontWeight: FontWeight.bold,
                              fontSize: 8,
                            )),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),



                    // Snooze Trigger
                    Text("SNOOZE TRIGGER", style: bodyStyle(fontSize: 8, color: textMid, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: snoozes.map((s) {
                        final isSelected = selectedSnooze == s;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedSnooze = s),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? primary : surface,
                                border: Border.all(color: isSelected ? Colors.white : textMid, width: 1),
                              ),
                              child: Center(
                                child: Text(
                                  s == 'shake' ? 'SHAKE' : 'TAP',
                                  style: bodyStyle(color: isSelected ? Colors.white : textMid, fontWeight: FontWeight.bold, fontSize: 8),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Set Alarm Button
                    NesButton(
                      type: NesButtonType.primary,
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
                        this.setState(() {
                          _activeAlarmDuration = null;
                        });
                        Navigator.of(sheetContext).pop();
                        NesSnackbar.show(context, text: 'Custom alarm set for $timeStr');
                      },
                      child: const Text("SET ALARM"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
