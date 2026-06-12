import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/sleep_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/ambient_background.dart';
import '../widgets/glass_card.dart';

class SleepJournalScreen extends StatelessWidget {
  final double? bottomPadding;

  const SleepJournalScreen({super.key, this.bottomPadding});

  @override
  Widget build(BuildContext context) {
    final sleepProvider = Provider.of<SleepProvider>(context);
    final double listBottomPadding = bottomPadding ?? (28.0 + MediaQuery.of(context).padding.bottom);
    
    // Sort sessions to show newest first
    final sessions = List.from(sleepProvider.sessions.reversed.toList());

    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          bottom: bottomPadding == null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    if (Navigator.of(context).canPop()) ...[
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(44, 44),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Icon(
                          CupertinoIcons.chevron_left,
                          color: textDark,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      'Sleep Journal',
                      style: headingStyle(
                        fontSize: 24,
                        color: textDark,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: sessions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.eye_fill, size: 64, color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                            const SizedBox(height: 16),
                            Text(
                              "No journal entries yet",
                              style: headingStyle(fontSize: 18, color: textMid, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Log your sleep to write down dreams.",
                              style: bodyStyle(fontSize: 14, color: textMid),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(20, 8, 20, listBottomPadding),
                        physics: const BouncingScrollPhysics(),
                        itemCount: sessions.length,
                        itemBuilder: (context, index) {
                          final session = sessions[index];
                          
                          // Format Dates
                          final dateStr = DateFormat('EEEE, MMMM d').format(session.startTime);
                          final startStr = DateFormat('hh:mm a').format(session.startTime);
                          final endStr = DateFormat('hh:mm a').format(session.endTime);
                          
                          // Duration
                          final hours = session.duration.inHours;
                          final mins = session.duration.inMinutes % 60;
                          final durationStr = hours > 0 ? '${hours}h ${mins}m' : '${mins}m';
                          
                          // Mood emoji map
                          final emojis = ['😫', '🥱', '😐', '🙂', '🤩'];
                          final moodEmoji = (session.moodRating >= 1 && session.moodRating <= 5)
                              ? emojis[session.moodRating - 1]
                              : '😐';

                          // Habit tags
                          final Map<String, String> habitLabels = {
                            'caffeine': 'Caffeine ☕',
                            'screen_time': 'Screen 📱',
                            'stress': 'Stress ⚡',
                            'exercise': 'Exercise 🏃‍♂️',
                          };

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: glassCard(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header Row (Date & Score)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dateStr,
                                        style: headingStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: primary.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: primary.withValues(alpha: 0.3), width: 1),
                                        ),
                                        child: Text(
                                          'Score: ${session.sleepScore}',
                                          style: bodyStyle(color: primary, fontSize: 12, fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Sleep & Wake Times
                                  Row(
                                    children: [
                                      Icon(CupertinoIcons.moon_fill, color: textMid, size: 14),
                                      const SizedBox(width: 6),
                                      Text(
                                        '$startStr - $endStr ($durationStr)',
                                        style: bodyStyle(color: textMid, fontSize: 13, fontWeight: FontWeight.w600),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Mood: $moodEmoji',
                                        style: bodyStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  
                                  // Habits display
                                  if (session.habits.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: session.habits.map<Widget>((h) {
                                        final label = habitLabels[h] ?? h;
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.04),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
                                          ),
                                          child: Text(
                                            label,
                                            style: bodyStyle(color: textMid, fontSize: 11, fontWeight: FontWeight.w600),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],

                                  // Dream Journal note
                                  if (session.notes != null && session.notes!.isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: primary.withValues(alpha: 0.05),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(color: primary.withValues(alpha: 0.1), width: 1.2),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(CupertinoIcons.sparkles, color: primary, size: 14),
                                              const SizedBox(width: 6),
                                              Text(
                                                'DREAM DIARY & NOTES',
                                                style: bodyStyle(color: primary, fontSize: 10, fontWeight: FontWeight.w800),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '"${session.notes}"',
                                            style: bodyStyle(
                                              color: textDark,
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
