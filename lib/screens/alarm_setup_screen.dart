import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alarm_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/ambient_background.dart';
import '../widgets/glass_card.dart';

class AlarmSetupScreen extends StatefulWidget {
  const AlarmSetupScreen({super.key});

  @override
  State<AlarmSetupScreen> createState() => _AlarmSetupScreenState();
}

class _AlarmSetupScreenState extends State<AlarmSetupScreen> {
  late TimeOfDay _selectedTime;
  late int _selectedWindow;
  late String _selectedSound;
  late bool _gradualVolume;
  late String _selectedSnooze;

  final List<int> _windows = [15, 30, 45, 60, 90];
  final List<String> _sounds = ['Morning Ambient', 'Forest Rain', 'Soft Chimes', 'Ocean Breath', 'Birds Chorus'];
  final List<String> _snoozes = ['shake', 'tap'];

  @override
  void initState() {
    super.initState();
    final config = Provider.of<AlarmProvider>(context, listen: false).config;
    _selectedTime = TimeOfDay(hour: config.hour, minute: config.minute);
    _selectedWindow = config.smartWindowMinutes;
    _selectedSound = config.soundName;
    _gradualVolume = config.gradualVolume;
    _selectedSnooze = config.snoozeType;
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
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
        _selectedTime = picked;
      });
    }
  }

  void _saveAlarm() {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    final updated = alarmProvider.config.copyWith(
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
      smartWindowMinutes: _selectedWindow,
      soundName: _selectedSound,
      gradualVolume: _gradualVolume,
      snoozeType: _selectedSnooze,
      isEnabled: true,
    );
    alarmProvider.updateConfig(updated);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Smart alarm configured for ${_selectedTime.format(context)}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            physics: const BouncingScrollPhysics(),
            children: [
              // Header
              Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(44, 44),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Icon(CupertinoIcons.chevron_left, color: textDark, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Configure Alarm',
                    style: headingStyle(fontSize: 18, color: textDark, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Time selector card
              GestureDetector(
                onTap: _pickTime,
                child: glassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        "TARGET WAKE TIME",
                        style: bodyStyle(fontSize: 12, color: textMid, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _selectedTime.format(context),
                            style: headingStyle(fontSize: 48, fontWeight: FontWeight.w200),
                          ),
                          const SizedBox(width: 12),
                          Icon(CupertinoIcons.pencil, color: primary, size: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Smart wake-up window selector
              _buildSection(
                title: 'Smart Wake-Up Window',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'AI detects your lightest sleep phase within this window prior to target time to wake you up gently.',
                      style: bodyStyle(fontSize: 13, color: textMid),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _windows.map((w) {
                        final isSelected = _selectedWindow == w;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedWindow = w),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
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
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Audio & snoozing card
              _buildSection(
                title: 'Wake Up Sounds & Volume',
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Alarm Sound', style: bodyStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        DropdownButton<String>(
                          value: _selectedSound,
                          dropdownColor: surface,
                          style: bodyStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primary),
                          underline: const SizedBox(),
                          items: _sounds.map((sound) {
                            return DropdownMenuItem(value: sound, child: Text(sound));
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) setState(() => _selectedSound = value);
                          },
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white10, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Gradual Volume', style: bodyStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        CupertinoSwitch(
                          value: _gradualVolume,
                          activeTrackColor: primary,
                          onChanged: (value) => setState(() => _gradualVolume = value),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Smart snooze card
              _buildSection(
                title: 'Smart Snooze Trigger',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _snoozes.map((s) {
                    final isSelected = _selectedSnooze == s;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedSnooze = s),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? primary : surface.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? Colors.transparent : textDark.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              s == 'shake' ? '👋 Shake to Snooze' : '👆 Tap screen',
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
              ),
              const SizedBox(height: 36),

              // Save Button
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _saveAlarm,
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [primary, accent]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Apply alarm schedule",
                      style: bodyStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: textDark.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: bodyStyle(fontSize: 13, color: textMid, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
