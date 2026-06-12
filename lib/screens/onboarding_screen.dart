import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
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

  // Question answers
  final TextEditingController _nameController = TextEditingController();
  int _targetSleepHours = 8;
  TimeOfDay _targetBedtime = const TimeOfDay(hour: 23, minute: 0);
  final List<String> _selectedReasons = [];

  final List<String> _reasons = [
    'Wake up refreshed ☀️',
    'Fall asleep faster 😴',
    'Track sleep quality scientifically 📊',
    'Reduce night disturbances (snore, cough) 🎙️',
    'Maintain a consistent schedule ⏰',
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
    await storage.saveSetting('profileName', name);
    await storage.saveSetting('onboarding_complete', true);

    // Save sleep goal config
    final sleepProvider = Provider.of<SleepProvider>(context, listen: false);
    final goal = SleepGoal(
      targetSleepMinutes: _targetSleepHours * 60,
      targetBedtimeHour: _targetBedtime.hour,
      targetBedtimeMinute: _targetBedtime.minute,
    );
    await sleepProvider.saveGoal(goal);

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
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
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          color: isSelected ? primary : textMid.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
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
                      CupertinoButton(
                        child: Text(
                          'Back',
                          style: bodyStyle(color: textMid, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOutCubic,
                          );
                        },
                      )
                    else
                      const SizedBox(width: 44),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: _nextPage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [primary, accent]),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withValues(alpha: 0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currentPage == _totalPages - 1 ? 'Start sleeping' : 'Continue',
                              style: bodyStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(width: 8),
                            const Icon(CupertinoIcons.arrow_right, color: Colors.white, size: 18),
                          ],
                        ),
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
          const Icon(
            CupertinoIcons.moon_stars_fill,
            size: 80,
            color: Color(0xFFA78BFA),
          ).animate().slideY(begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOutBack).fadeIn(),
          const SizedBox(height: 24),
          Text(
            "Welcome to\nSmart Sleep Cycle",
            style: headingStyle(fontSize: 34, fontWeight: FontWeight.w800),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 12),
          Text(
            "Track your phases, record nighttime disruptions, and wake up fresh with optimized AI smart alarms.",
            style: bodyStyle(color: textMid, fontSize: 16, height: 1.5),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 36),
          glassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CupertinoTextField(
              controller: _nameController,
              placeholder: "Enter your first name",
              placeholderStyle: bodyStyle(color: textMid.withValues(alpha: 0.6), fontSize: 16),
              style: bodyStyle(fontSize: 16),
              decoration: null,
              cursorColor: primary,
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
          Text(
            "What brings you here?",
            style: headingStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            "We'll customize your AI coaching tips based on your goals.",
            style: bodyStyle(color: textMid, fontSize: 15),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reasons.length,
              itemBuilder: (context, index) {
                final reason = _reasons[index];
                final isSelected = _selectedReasons.contains(reason);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
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
                    child: glassCard(
                      opacity: isSelected ? 0.28 : 0.1,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              reason,
                              style: bodyStyle(
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? primary : textMid.withValues(alpha: 0.4),
                                width: 2.0,
                              ),
                              color: isSelected ? primary : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, size: 12, color: Colors.white)
                                : null,
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
          Text(
            "Schedule your sleep",
            style: headingStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            "How much sleep would you like to achieve nightly, and when is bedtime?",
            style: bodyStyle(color: textMid, fontSize: 15),
          ),
          const SizedBox(height: 32),
          glassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sleep Duration Target",
                  style: bodyStyle(fontSize: 14, color: textMid, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$_targetSleepHours Hours",
                      style: headingStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    Row(
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 36,
                          child: Icon(CupertinoIcons.minus_circle, color: primary, size: 28),
                          onPressed: () {
                            if (_targetSleepHours > 4) {
                              setState(() => _targetSleepHours--);
                            }
                          },
                        ),
                        const SizedBox(width: 12),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 36,
                          child: Icon(CupertinoIcons.plus_circle, color: primary, size: 28),
                          onPressed: () {
                            if (_targetSleepHours < 12) {
                              setState(() => _targetSleepHours++);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(color: Colors.white10),
                ),
                Text(
                  "Target Bedtime",
                  style: bodyStyle(fontSize: 14, color: textMid, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _targetBedtime,
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
                    if (time != null) {
                      setState(() {
                        _targetBedtime = time;
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _targetBedtime.format(context),
                        style: headingStyle(fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      Icon(CupertinoIcons.clock, color: primary),
                    ],
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
