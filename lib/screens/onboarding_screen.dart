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
    // Capture state before any async gaps
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
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [primary, accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.3),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              CupertinoIcons.moon_stars_fill,
              size: 40,
              color: Colors.white,
            ),
          ).animate().slideY(begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOutBack).fadeIn(),
          const SizedBox(height: 32),
          Text(
            "Welcome to\nSmart Sleep",
            style: headingStyle(fontSize: 36, fontWeight: FontWeight.w800),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          Text(
            "Track your sleep cycles, record dreams, and wake up at the perfect moment with smart alarms.",
            style: bodyStyle(color: textMid, fontSize: 16, height: 1.5),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 40),
          glassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: CupertinoTextField(
              controller: _nameController,
              placeholder: "What's your name?",
              placeholderStyle: bodyStyle(color: textMid.withValues(alpha: 0.6), fontSize: 16),
              style: bodyStyle(fontSize: 16),
              decoration: null,
              cursorColor: primary,
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
          Text(
            "What matters most?",
            style: headingStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            "We'll tailor your sleep coaching tips to help you reach your goals.",
            style: bodyStyle(color: textMid, fontSize: 15),
          ),
          const SizedBox(height: 28),
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
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? primary.withValues(alpha: 0.12) : surface.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? primary.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.06),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
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
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? primary : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? primary : textMid.withValues(alpha: 0.4),
                                width: 2.0,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, size: 14, color: Colors.white)
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
            "Set your sleep goal",
            style: headingStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            "How many hours of sleep do you want, and when do you go to bed?",
            style: bodyStyle(color: textMid, fontSize: 15),
          ),
          const SizedBox(height: 32),
          glassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DAILY SLEEP TARGET",
                  style: bodyStyle(fontSize: 12, color: textMid, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$_targetSleepHours",
                          style: headingStyle(fontSize: 40, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          _targetSleepHours == 1 ? "hour" : "hours",
                          style: bodyStyle(color: textMid, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
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
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: surface.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                            ),
                            child: Icon(CupertinoIcons.minus, color: _targetSleepHours > 4 ? primary : textMid, size: 20),
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            if (_targetSleepHours < 12) {
                              setState(() => _targetSleepHours++);
                            }
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: surface.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                            ),
                            child: Icon(CupertinoIcons.plus, color: _targetSleepHours < 12 ? primary : textMid, size: 20),
                          ),
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
                  "BEDTIME",
                  style: bodyStyle(fontSize: 12, color: textMid, fontWeight: FontWeight.w800),
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
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surface.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _targetBedtime.format(context),
                          style: headingStyle(fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                        Icon(CupertinoIcons.clock, color: primary, size: 22),
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
