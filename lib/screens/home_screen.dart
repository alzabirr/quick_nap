import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../themes/app_theme.dart';
import '../providers/alarm_provider.dart';
import '../widgets/ambient_background.dart';
import '../widgets/glass_card.dart';
import '../models/alarm_config.dart';
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

              // Bottom Navigation Bar
              Positioned(
                bottom: 12 + MediaQuery.of(context).padding.bottom,
                left: 24,
                right: 24,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      height: 72,
                      decoration: BoxDecoration(
                        color: surface.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: textMid.withValues(alpha: 0.15),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavBarItem(0, CupertinoIcons.house, 'Home'),
                          _buildNavBarItem(1, CupertinoIcons.doc_plaintext, 'Journal'),
                          _buildNavBarItem(2, CupertinoIcons.gamecontroller_fill, 'Games'),
                          _buildNavBarItem(3, CupertinoIcons.moon_stars_fill, 'Sleep'),
                          _buildNavBarItem(4, CupertinoIcons.gear_alt_fill, 'Settings'),
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
                                    setState(() {
                                      _activeAlarmDuration = null;
                                    });
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

  Widget _buildNavBarItem(int index, IconData icon, String label) {
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
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? primary : textMid,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: bodyStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? primary : textMid,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _cancelActiveAlarm() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF11141D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Cancel Alarm?', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
        content: Text('Are you sure you want to cancel this alarm?', style: bodyStyle(fontSize: 15, color: textMid)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('No', style: bodyStyle(color: textMid, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
              alarmProvider.updateConfig(alarmProvider.config.copyWith(isEnabled: false));
              setState(() => _activeAlarmDuration = null);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Alarm cancelled'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: Text('Yes', style: bodyStyle(color: const Color(0xFFFB4169), fontWeight: FontWeight.w700)),
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
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              
              Text(
                badge.toUpperCase(),
                style: bodyStyle(color: textMid, fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 24),
              
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
        const SizedBox(height: 48),
              
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
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.info, color: Colors.white38, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    "Extra 15 mins added for falling asleep",
                    style: bodyStyle(color: textMid, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  alarmProvider.updateConfig(alarmProvider.config.copyWith(
                    hour: wakeTime.hour,
                    minute: wakeTime.minute,
                    isEnabled: true,
                  ));
                  
                  setState(() {
                    _activeAlarmDuration = duration;
                  });
                  
                  Navigator.of(sheetContext).pop();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$title alarm set for $timeStr'),
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

  // ================= TAB 0: DASHBOARD =================
  Widget _buildDashboardTab(double bottomPadding) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding),
      physics: const BouncingScrollPhysics(),
      children: [
        // Quick Nap Section
        Text(
          "Quick Nap",
          style: bodyStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w800),
        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
        const SizedBox(height: 32),

        // Preset 1: Power Nap
        GestureDetector(
          onTap: _activeAlarmDuration == const Duration(minutes: 20)
              ? _cancelActiveAlarm
              : () => _selectPresetAndSetAlarm(const Duration(minutes: 20), "Power Nap", "Power Nap"),
          child: glassCard(
            opacity: _activeAlarmDuration == const Duration(minutes: 20) ? 0.25 : 0.15,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _activeAlarmDuration == const Duration(minutes: 20) ? Colors.green : primary,
                  ),
                  child: Center(
                    child: Icon(
                      _activeAlarmDuration == const Duration(minutes: 20) ? CupertinoIcons.check_mark : CupertinoIcons.bolt_fill,
                      color: Colors.white,
                      size: 24,
                    ),
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
                      _activeAlarmDuration == const Duration(minutes: 20) ? "Tap to cancel" : "20 Min Booster",
                      style: bodyStyle(
                        color: _activeAlarmDuration == const Duration(minutes: 20) ? Colors.green : textMid,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Preset Grid: 1-4 Cycles
        Text(
          "Sleep Cycles",
          style: bodyStyle(fontSize: 13, color: textMid, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
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
        const SizedBox(height: 20),

        // Recommended Section
        Text(
          "Recommended",
          style: bodyStyle(fontSize: 13, color: textMid, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),

        // Preset 5: Recommended 7h 30m Card
        GestureDetector(
          onTap: _activeAlarmDuration == const Duration(hours: 7, minutes: 30)
              ? _cancelActiveAlarm
              : () => _selectPresetAndSetAlarm(const Duration(hours: 7, minutes: 30), "Recommended Rest", "5 Cycles"),
          child: glassCard(
            opacity: _activeAlarmDuration == const Duration(hours: 7, minutes: 30) ? 0.25 : 0.2,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _activeAlarmDuration == const Duration(hours: 7, minutes: 30) ? Colors.green : primary,
                  ),
                  child: Center(
                    child: _activeAlarmDuration == const Duration(hours: 7, minutes: 30)
                        ? const Icon(CupertinoIcons.check_mark, color: Colors.white, size: 22)
                        : Text(
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
                              border: Border.all(
                                color: _activeAlarmDuration == const Duration(hours: 7, minutes: 30) ? Colors.green : const Color(0xFFFB4169),
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _activeAlarmDuration == const Duration(hours: 7, minutes: 30) ? "ALARM SET" : "RECOMMENDED",
                              style: TextStyle(
                                color: _activeAlarmDuration == const Duration(hours: 7, minutes: 30) ? Colors.green : const Color(0xFFA78BFA),
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _activeAlarmDuration == const Duration(hours: 7, minutes: 30) ? "Tap to cancel" : "5 CYCLES • Optimal for most adults",
                        style: bodyStyle(
                          color: _activeAlarmDuration == const Duration(hours: 7, minutes: 30) ? Colors.green : textMid,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
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
          onTap: _activeAlarmDuration == const Duration(hours: 9)
              ? _cancelActiveAlarm
              : () => _selectPresetAndSetAlarm(const Duration(hours: 9), "Extended Rest", "6 Cycles"),
          child: glassCard(
            opacity: _activeAlarmDuration == const Duration(hours: 9) ? 0.25 : 0.15,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _activeAlarmDuration == const Duration(hours: 9) ? Colors.green : const Color(0xFF1E293B),
                  ),
                  child: Center(
                    child: _activeAlarmDuration == const Duration(hours: 9)
                        ? const Icon(CupertinoIcons.check_mark, color: Colors.white, size: 22)
                        : Text(
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
                      _activeAlarmDuration == const Duration(hours: 9) ? "Tap to cancel" : "Full Rest (6 CYCLES)",
                      style: bodyStyle(
                        color: _activeAlarmDuration == const Duration(hours: 9) ? Colors.green : textMid,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
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
    final isActive = _activeAlarmDuration == duration;
    return GestureDetector(
      onTap: isActive
          ? _cancelActiveAlarm
          : () => _selectPresetAndSetAlarm(duration, "$cycleBadge Rest", cycleBadge),
      child: glassCard(
        opacity: isActive ? 0.25 : 0.15,
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? Colors.green : const Color(0xFF1E293B),
                  ),
                  child: Center(
                    child: isActive
                        ? const Icon(CupertinoIcons.check_mark, color: Colors.white, size: 14)
                        : Text(
                            cycleNumber,
                            style: headingStyle(fontSize: 12, color: textMid, fontWeight: FontWeight.w800),
                          ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green.withValues(alpha: 0.2) : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(6),
                    border: isActive ? Border.all(color: Colors.green, width: 1) : null,
                  ),
                  child: Text(
                    cycleBadge,
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
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
                  isActive ? "Tap to cancel" : subtitle,
                  style: bodyStyle(
                    color: isActive ? Colors.green : textMid,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= TAB 3: COACHING & GAMIFICATION =================
  Widget _buildCoachingTab(double bottomPadding) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPadding),
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          "Quick Nap",
          style: headingStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          "Pros & Cons",
          style: bodyStyle(color: textMid, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 24),

        Text(
          "PROS",
          style: bodyStyle(fontSize: 13, color: Colors.green, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: CupertinoIcons.bolt_fill,
          color: Colors.green,
          title: "Boosts Energy",
          subtitle: "A short nap can quickly reduce fatigue and help you feel refreshed.",
        ),
        const SizedBox(height: 10),
        _buildInfoCard(
          icon: CupertinoIcons.eye_fill,
          color: Colors.green,
          title: "Improves Focus and Concentration",
          subtitle: "Helps you stay alert, make fewer mistakes, and perform better at work or school.",
        ),
        const SizedBox(height: 10),
        _buildInfoCard(
          icon: CupertinoIcons.book_fill,
          color: Colors.green,
          title: "Enhances Memory",
          subtitle: "Can improve learning, memory retention, and problem-solving abilities.",
        ),
        const SizedBox(height: 10),
        _buildInfoCard(
          icon: CupertinoIcons.smiley_fill,
          color: Colors.green,
          title: "Improves Mood",
          subtitle: "A quick nap may reduce stress, irritability, and improve your overall mood.",
        ),
        const SizedBox(height: 10),
        _buildInfoCard(
          icon: CupertinoIcons.speedometer,
          color: Colors.green,
          title: "Increases Productivity",
          subtitle: "Many people feel more productive and efficient after a short nap.",
        ),
        const SizedBox(height: 10),
        _buildInfoCard(
          icon: CupertinoIcons.heart_fill,
          color: Colors.green,
          title: "Supports Heart Health",
          subtitle: "Some studies suggest that occasional naps may help reduce stress on the cardiovascular system.",
        ),
        const SizedBox(height: 10),
        _buildInfoCard(
          icon: CupertinoIcons.checkmark_shield_fill,
          color: Colors.green,
          title: "Safer Performance",
          subtitle: "Reduces drowsiness, which can improve reaction time when driving or operating machinery.",
        ),
        const SizedBox(height: 24),

        Text(
          "CONS",
          style: bodyStyle(fontSize: 13, color: const Color(0xFFFB4169), fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: CupertinoIcons.exclamationmark_triangle_fill,
          color: const Color(0xFFFB4169),
          title: "Sleep Inertia",
          subtitle: "Napping for too long (typically over 30 minutes) can leave you feeling groggy and disoriented.",
        ),
        const SizedBox(height: 10),
        _buildInfoCard(
          icon: CupertinoIcons.moon_fill,
          color: const Color(0xFFFB4169),
          title: "May Disrupt Nighttime Sleep",
          subtitle: "Late afternoon or evening naps can make it harder to fall asleep at night.",
        ),
        const SizedBox(height: 10),
        _buildInfoCard(
          icon: CupertinoIcons.arrow_counterclockwise,
          color: const Color(0xFFFB4169),
          title: "Can Become a Habit",
          subtitle: "Relying on naps instead of getting enough nighttime sleep isn't a healthy long-term solution.",
        ),
        const SizedBox(height: 10),
        _buildInfoCard(
          icon: CupertinoIcons.question_circle_fill,
          color: const Color(0xFFFB4169),
          title: "Not Effective for Everyone",
          subtitle: "Some people wake up feeling more tired instead of refreshed.",
        ),
        const SizedBox(height: 10),
        _buildInfoCard(
          icon: CupertinoIcons.clock_fill,
          color: const Color(0xFFFB4169),
          title: "Time Management",
          subtitle: "A nap can take longer than planned, reducing time available for work or other activities.",
        ),
        const SizedBox(height: 10),
        _buildInfoCard(
          icon: CupertinoIcons.heart_circle_fill,
          color: const Color(0xFFFB4169),
          title: "May Indicate Poor Sleep",
          subtitle: "Frequently needing naps could be a sign that you're not getting enough quality sleep at night.",
        ),
        const SizedBox(height: 24),

        Text(
          "BEST PRACTICES",
          style: bodyStyle(fontSize: 13, color: primary, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        glassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPracticeRow("Ideal Duration", "10–20 minutes"),
              const SizedBox(height: 10),
              _buildPracticeRow("Best Time", "Between 1:00 PM and 3:00 PM"),
              const SizedBox(height: 10),
              _buildPracticeRow("Avoid", "Naps after 4:00 PM if they interfere with nighttime sleep"),
              const SizedBox(height: 10),
              _buildPracticeRow("Environment", "Choose a quiet, cool, and dimly lit place if possible"),
              const SizedBox(height: 10),
              _buildPracticeRow("Optional", "Coffee nap: drink coffee just before a 20-min nap, caffeine kicks in when you wake"),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Text(
          "RECOMMENDED NAP LENGTHS",
          style: bodyStyle(fontSize: 13, color: textMid, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        glassCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              _buildDurationRow("10–20 min", "Best for a quick energy boost, alertness, and focus"),
              const Divider(color: Colors.white10, height: 20),
              _buildDurationRow("20–30 min", "Still beneficial, but some people may feel slightly groggy"),
              const Divider(color: Colors.white10, height: 20),
              _buildDurationRow("60 min", "May improve memory, but grogginess is more likely"),
              const Divider(color: Colors.white10, height: 20),
              _buildDurationRow("90 min", "Completes a full sleep cycle, reducing grogginess and supporting creativity"),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Text(
          "OVERALL",
          style: bodyStyle(fontSize: 13, color: textMid, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        glassCard(
          padding: const EdgeInsets.all(18),
          child: Text(
            "A 10–20 minute quick nap is generally considered the most effective choice. It provides a noticeable boost in energy, focus, and mood while minimizing the risk of grogginess or disrupting your nighttime sleep.",
            style: bodyStyle(fontSize: 14, height: 1.5),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoCard({required IconData icon, required Color color, required String title, required String subtitle}) {
    return glassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: headingStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: bodyStyle(fontSize: 12, color: textMid, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(CupertinoIcons.checkmark_circle_fill, color: primary, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: "$label: ", style: bodyStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                TextSpan(text: value, style: bodyStyle(fontSize: 13, color: textMid)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationRow(String duration, String effect) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            duration,
            style: bodyStyle(fontSize: 11, fontWeight: FontWeight.w700, color: primary),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            effect,
            style: bodyStyle(fontSize: 12, color: textMid, height: 1.4),
          ),
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
