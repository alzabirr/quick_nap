import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:nes_ui/nes_ui.dart';
import '../models/dream_note.dart';
import '../providers/notes_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/ambient_background.dart';
import '../widgets/glass_card.dart';

class DreamNotesScreen extends StatelessWidget {
  final double? bottomPadding;

  const DreamNotesScreen({super.key, this.bottomPadding});

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final double listBottomPadding = bottomPadding ?? (28.0 + MediaQuery.of(context).padding.bottom);
    
    final notes = List.from(notesProvider.notes.reversed.toList());

    final Map<String, String> categoryLabels = {
      'dream': 'DREAM',
      'lucid': 'LUCID',
      'nightmare': 'NIGHTMARE',
      'reflection': 'REFLECTION',
    };

    final Map<String, Color> categoryColors = {
      'dream': primary,
      'lucid': const Color(0xff92cc41),
      'nightmare': accent,
      'reflection': const Color(0xfff7d51d),
    };

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text('DREAM DIARY', style: headingStyle(fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                    ),
                    NesButton(
                      type: NesButtonType.primary,
                      onPressed: () => _showAddNoteBottomSheet(context),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.plus, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text('NEW NOTE', style: bodyStyle(fontSize: 8)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: notes.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NesContainer(
                                padding: const EdgeInsets.all(20),
                                child: const Icon(CupertinoIcons.sparkles, size: 32, color: Color(0xff92cc41)),
                              ),
                              const SizedBox(height: 16),
                              Text("No dreams recorded", style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text("Capture your dreams and reflections.", style: bodyStyle(fontSize: 10, color: textMid, height: 1.5), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(20, 8, 20, listBottomPadding),
                        physics: const BouncingScrollPhysics(),
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index] as DreamNote;
                          final dateStr = DateFormat('EEEE, MMMM d').format(note.date);
                          final catLabel = categoryLabels[note.category] ?? note.category.toUpperCase();
                          final catColor = categoryColors[note.category] ?? primary;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: glassCard(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(dateStr, style: bodyStyle(fontSize: 8, fontWeight: FontWeight.bold, color: textMid)),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: catColor.withValues(alpha: 0.2),
                                              border: Border.all(color: catColor, width: 1),
                                            ),
                                            child: Text(catLabel, style: TextStyle(color: catColor, fontSize: 8, decoration: TextDecoration.none, fontWeight: FontWeight.bold)),
                                          ),
                                          const SizedBox(width: 6),
                                          NesButton(
                                            type: NesButtonType.normal,
                                            onPressed: () => _confirmDelete(context, notesProvider, note),
                                            child: const Icon(CupertinoIcons.trash, color: Color(0xffe76e55), size: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(note.title, style: headingStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text(note.content, style: bodyStyle(fontSize: 8, color: textDark.withValues(alpha: 0.85), height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Lucidity: ', style: bodyStyle(fontSize: 8, color: textMid, fontWeight: FontWeight.bold)),
                                          Row(
                                            children: List.generate(5, (starIdx) {
                                              final active = starIdx < note.lucidityScore;
                                              return Icon(active ? CupertinoIcons.sparkles : CupertinoIcons.circle, color: active ? const Color(0xfff7d51d) : Colors.white24, size: 10);
                                            }),
                                          ),
                                        ],
                                      ),
                                      Text('Dream Mood: ${note.moodEmoji}', style: bodyStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
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

  void _confirmDelete(BuildContext context, NotesProvider provider, DreamNote note) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: surface,
          title: Text('Delete Note', style: headingStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          content: Text('Delete this dream note permanently?', style: bodyStyle(fontSize: 10, color: textMid)),
          actions: [
            NesButton(
              type: NesButtonType.normal,
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: bodyStyle(fontSize: 10, color: Colors.black)),
            ),
            NesButton(
              type: NesButtonType.error,
              onPressed: () {
                provider.deleteNote(note.id);
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: bodyStyle(fontSize: 10)),
            ),
          ],
        );
      },
    );
  }

  void _showAddNoteBottomSheet(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    
    String selectedCategory = 'dream';
    String selectedMood = '🙂';
    int selectedLucidity = 3;

    final categories = ['dream', 'lucid', 'nightmare', 'reflection'];
    final categoryLabels = {'dream': 'DREAM', 'lucid': 'LUCID', 'nightmare': 'NIGHTMARE', 'reflection': 'REFLECTION'};
    final moods = ['😫', '🥱', '😐', '🙂', '🤩'];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x80000000),
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return NesContainer(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(width: 40, height: 4, decoration: BoxDecoration(color: textMid, border: Border.all(color: Colors.white, width: 1))),
                    ),
                    const SizedBox(height: 16),
                    Text("LOG A NEW DREAM", style: bodyStyle(fontSize: 10, color: textMid, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    const SizedBox(height: 16),

                    // Title
                    glassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title', border: InputBorder.none),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Content
                    glassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: TextField(
                        controller: contentController,
                        decoration: const InputDecoration(labelText: 'Describe your dream...', border: InputBorder.none, alignLabelWithHint: true),
                        style: const TextStyle(fontSize: 10),
                        maxLines: 4,
                        minLines: 2,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Category
                    Text("DREAM CATEGORY", style: bodyStyle(fontSize: 8, color: textMid, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: categories.map((cat) {
                        final isSelected = selectedCategory == cat;
                        return GestureDetector(
                          onTap: () => setState(() => selectedCategory = cat),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? primary : surface,
                              border: Border.all(color: isSelected ? Colors.white : textMid, width: 1),
                            ),
                            child: Text(categoryLabels[cat] ?? cat, style: bodyStyle(color: isSelected ? Colors.white : textDark, fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    // Lucidity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("LUCIDITY LEVEL", style: bodyStyle(fontSize: 8, color: textMid, fontWeight: FontWeight.bold)),
                        Row(
                          children: List.generate(5, (starIdx) {
                            final active = starIdx < selectedLucidity;
                            return GestureDetector(
                              onTap: () => setState(() => selectedLucidity = starIdx + 1),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3),
                                child: Icon(active ? CupertinoIcons.sparkles : CupertinoIcons.circle, color: active ? const Color(0xfff7d51d) : Colors.white24, size: 16),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Mood
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("DREAM MOOD", style: bodyStyle(fontSize: 8, color: textMid, fontWeight: FontWeight.bold)),
                        Row(
                          children: moods.map((m) {
                            final isSelected = selectedMood == m;
                            return GestureDetector(
                              onTap: () => setState(() => selectedMood = m),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(6),
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: isSelected ? primary.withValues(alpha: 0.2) : Colors.transparent,
                                  border: Border.all(color: isSelected ? primary : Colors.transparent, width: 1),
                                ),
                                child: Text(m, style: const TextStyle(fontSize: 16)),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Save
                    NesButton(
                      type: NesButtonType.primary,
                      onPressed: () {
                        final title = titleController.text.trim();
                        final content = contentController.text.trim();
                        
                        if (title.isEmpty || content.isEmpty) {
                          showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: surface,
                              title: Text('Missing Fields', style: headingStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              content: Text('Please fill out both title and content.', style: bodyStyle(fontSize: 10, color: textMid)),
                              actions: [
                                NesButton(type: NesButtonType.primary, onPressed: () => Navigator.of(context).pop(), child: Text('OK', style: bodyStyle(fontSize: 10))),
                              ],
                            ),
                          );
                          return;
                        }

                        notesProvider.addNote(DreamNote(
                          date: DateTime.now(),
                          title: title,
                          content: content,
                          lucidityScore: selectedLucidity,
                          moodEmoji: selectedMood,
                          category: selectedCategory,
                        ));

                        Navigator.of(sheetContext).pop();
                      },
                      child: const Text("SAVE DREAM NOTE"),
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
