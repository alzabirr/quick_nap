import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:nes_ui/nes_ui.dart';
import '../models/sleep_goal.dart';
import '../providers/sleep_provider.dart';
import '../storage/hive_storage.dart';
import '../themes/app_theme.dart';
import '../widgets/ambient_background.dart';
import '../widgets/glass_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  final TextEditingController _nameController = TextEditingController();
  int _targetSleepHours = 8;
  TimeOfDay _targetBedtime = const TimeOfDay(hour: 23, minute: 0);
  final List<String> _selectedReasons = [];

  final List<String> _reasons = [
    'Wake up refreshed',
    'Fall asleep faster',
    'Track sleep quality',
    'Reduce disturbances',
    'Consistent schedule',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    final storage = HiveStorage();
    final name = _nameController.text.trim().isEmpty ? 'Sleep Companion' : _nameController.text.trim();
    final sleepProvider = Provider.of<SleepProvider>(context, listen: false);
    final goal = SleepGoal(
      targetSleepMinutes: _targetSleepHours * 60,
      targetBedtimeHour: _targetBedtime.hour,
      targetBedtimeMinute: _targetBedtime.minute,
    );
    
    await storage.saveSetting('profileName', name);
    await storage.saveSetting('onboarding_complete', true);
    await sleepProvider.saveGoal(goal);

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicators
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  children: List.generate(_totalPages, (index) {
                    final isSelected = index == _currentPage;
                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          color: isSelected ? primary : textMid.withValues(alpha: 0.3),
                          border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: 1),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Page Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    _buildWelcomePage(),
                    _buildSleepGoalPage(),
                    _buildBedtimePage(),
                  ],
                ),
              ),

              // Footer Button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      NesButton(
                        type: NesButtonType.normal,
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOutCubic,
                          );
                        },
                        child: Text('BACK', style: bodyStyle(fontSize: 10, color: Colors.black)),
                      )
                    else
                      const SizedBox(width: 80),
                    NesButton(
                      type: NesButtonType.primary,
                      onPressed: _nextPage,
                      child: Text(
                        _currentPage == _totalPages - 1 ? 'START SLEEPING' : 'CONTINUE',
                        style: bodyStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NesContainer(
            padding: const EdgeInsets.all(20),
            child: const Icon(CupertinoIcons.moon_stars_fill, size: 40, color: Color(0xff209cee)),
          ).animate().slideY(begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOutBack).fadeIn(),
          const SizedBox(height: 24),
          Text(
            "WELCOME TO\nSMART SLEEP",
            style: headingStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 12),
          Text(
            "Track your sleep cycles, record dreams, and wake up at the perfect moment with smart alarms.",
            style: bodyStyle(fontSize: 10, color: textMid, height: 1.5),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 32),
          glassCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "What's your name?",
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 12),
              textCapitalization: TextCapitalization.words,
            ),
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildSleepGoalPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("WHAT MATTERS MOST?", style: headingStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("We'll tailor your sleep coaching tips.", style: bodyStyle(fontSize: 10, color: textMid)),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reasons.length,
              itemBuilder: (context, index) {
                final reason = _reasons[index];
                final isSelected = _selectedReasons.contains(reason);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedReasons.remove(reason);
                        } else {
                          _selectedReasons.add(reason);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? primary.withValues(alpha: 0.2) : surface.withValues(alpha: 0.5),
                        border: Border.all(
                          color: isSelected ? primary : textMid.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(reason, style: bodyStyle(fontSize: 10, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isSelected ? primary : Colors.transparent,
                              border: Border.all(color: isSelected ? primary : textMid, width: 2),
                            ),
                            child: isSelected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBedtimePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("SET YOUR SLEEP GOAL", style: headingStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("How many hours and when do you go to bed?", style: bodyStyle(fontSize: 10, color: textMid)),
          const SizedBox(height: 24),
          glassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("DAILY SLEEP TARGET", style: bodyStyle(fontSize: 8, color: textMid, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$_targetSleepHours", style: headingStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        Text(_targetSleepHours == 1 ? "hour" : "hours", style: bodyStyle(fontSize: 10, color: textMid)),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_targetSleepHours > 4) {
                              setState(() => _targetSleepHours--);
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: surface,
                              border: Border.all(color: _targetSleepHours > 4 ? primary : textMid, width: 1),
                            ),
                            child: Icon(CupertinoIcons.minus, color: _targetSleepHours > 4 ? primary : textMid, size: 16),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            if (_targetSleepHours < 12) {
                              setState(() => _targetSleepHours++);
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: surface,
                              border: Border.all(color: _targetSleepHours < 12 ? primary : textMid, width: 1),
                            ),
                            child: Icon(CupertinoIcons.plus, color: _targetSleepHours < 12 ? primary : textMid, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: Color(0xff808080)),
                ),
                Text("BEDTIME", style: bodyStyle(fontSize: 8, color: textMid, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _targetBedtime,
                    );
                    if (time != null) {
                      setState(() {
                        _targetBedtime = time;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: surface,
                      border: Border.all(color: textMid, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_targetBedtime.format(context), style: headingStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Icon(CupertinoIcons.clock, color: primary, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
