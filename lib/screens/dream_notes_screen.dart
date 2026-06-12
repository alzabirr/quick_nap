import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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
    
    // Sort notes to show newest first
    final notes = List.from(notesProvider.notes.reversed.toList());

    final Map<String, String> categoryLabels = {
      'dream': 'Dream 🌌',
      'lucid': 'Lucid ⚡',
      'nightmare': 'Nightmare 👺',
      'reflection': 'Reflection 🧠',
    };

    final Map<String, Color> categoryColors = {
      'dream': Colors.blueAccent,
      'lucid': Colors.purpleAccent,
      'nightmare': Colors.redAccent,
      'reflection': Colors.tealAccent,
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
                    Text(
                      'Dream Diary',
                      style: headingStyle(
                        fontSize: 24,
                        color: textDark,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _showAddNoteBottomSheet(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [primary, accent]),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.plus, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Add Note',
                              style: bodyStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: notes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.doc_plaintext, size: 64, color: textMid.withValues(alpha: 0.3)),
                            const SizedBox(height: 16),
                            Text(
                              "No notes yet",
                              style: headingStyle(fontSize: 18, color: textMid, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Write down your dreams and thoughts.",
                              style: bodyStyle(fontSize: 14, color: textMid),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(20, 8, 20, listBottomPadding),
                        physics: const BouncingScrollPhysics(),
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index] as DreamNote;
                          
                          // Format Dates
                          final dateStr = DateFormat('EEEE, MMMM d').format(note.date);
                          final catLabel = categoryLabels[note.category] ?? note.category;
                          final catColor = categoryColors[note.category] ?? primary;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: glassCard(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header Row (Date & Category)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dateStr,
                                        style: headingStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textMid),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: catColor.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: catColor.withValues(alpha: 0.3), width: 1),
                                            ),
                                            child: Text(
                                              catLabel.toUpperCase(),
                                              style: bodyStyle(color: catColor, fontSize: 10, fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            minSize: 24,
                                            onPressed: () => _confirmDelete(context, notesProvider, note),
                                            child: const Icon(CupertinoIcons.trash, color: Colors.redAccent, size: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Title
                                  Text(
                                    note.title,
                                    style: headingStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),

                                  // Content
                                  Text(
                                    note.content,
                                    style: bodyStyle(
                                      color: textDark.withValues(alpha: 0.85),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Lucidity & Mood
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Lucidity: ',
                                            style: bodyStyle(color: textMid, fontSize: 12, fontWeight: FontWeight.w600),
                                          ),
                                          Row(
                                            children: List.generate(5, (starIdx) {
                                              final active = starIdx < note.lucidityScore;
                                              return Icon(
                                                active ? CupertinoIcons.sparkles : CupertinoIcons.circle,
                                                color: active ? Colors.amber : Colors.white24,
                                                size: 13,
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Dream Mood: ${note.moodEmoji}',
                                        style: bodyStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                                      ),
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
    showCupertinoDialog<void>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this dream note permanently?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                provider.deleteNote(note.id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
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
    final categoryLabels = {
      'dream': 'Dream 🌌',
      'lucid': 'Lucid ⚡',
      'nightmare': 'Nightmare 👺',
      'reflection': 'Reflection 🧠',
    };

    final moods = ['😫', '🥱', '😐', '🙂', '🤩'];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
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
              child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top drag handle
                      Center(
                        child: Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      Text(
                        "LOG A NEW DREAM",
                        style: bodyStyle(color: textMid, fontSize: 13, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Title field
                      glassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: CupertinoTextField(
                          controller: titleController,
                          placeholder: "Title (e.g. Lost in the Stars)",
                          placeholderStyle: bodyStyle(color: textMid.withValues(alpha: 0.6), fontSize: 15),
                          style: bodyStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          decoration: null,
                          cursorColor: primary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Content field
                      glassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: CupertinoTextField(
                          controller: contentController,
                          placeholder: "Describe your dream details here...",
                          placeholderStyle: bodyStyle(color: textMid.withValues(alpha: 0.6), fontSize: 14),
                          style: bodyStyle(fontSize: 14),
                          maxLines: 5,
                          minLines: 3,
                          decoration: null,
                          cursorColor: primary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Category Grid
                      Text(
                        "DREAM CATEGORY",
                        style: bodyStyle(color: textMid, fontSize: 11, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: categories.map((cat) {
                          final isSelected = selectedCategory == cat;
                          return GestureDetector(
                            onTap: () => setState(() => selectedCategory = cat),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? primary : surface.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? Colors.transparent : Colors.white10,
                                ),
                              ),
                              child: Text(
                                categoryLabels[cat] ?? cat,
                                style: bodyStyle(
                                  color: isSelected ? Colors.white : textDark,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),

                      // Lucidity level
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "LUCIDITY LEVEL",
                            style: bodyStyle(color: textMid, fontSize: 11, fontWeight: FontWeight.w800),
                          ),
                          Row(
                            children: List.generate(5, (starIdx) {
                              final active = starIdx < selectedLucidity;
                              return GestureDetector(
                                onTap: () => setState(() => selectedLucidity = starIdx + 1),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Icon(
                                    active ? CupertinoIcons.sparkles : CupertinoIcons.circle,
                                    color: active ? Colors.amber : Colors.white24,
                                    size: 20,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Mood Emoji Selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "DREAM MOOD",
                            style: bodyStyle(color: textMid, fontSize: 11, fontWeight: FontWeight.w800),
                          ),
                          Row(
                            children: moods.map((m) {
                              final isSelected = selectedMood == m;
                              return GestureDetector(
                                onTap: () => setState(() => selectedMood = m),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? primary.withValues(alpha: 0.2) : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected ? primary : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    m,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Save button
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          final title = titleController.text.trim();
                          final content = contentController.text.trim();
                          
                          if (title.isEmpty || content.isEmpty) {
                            showCupertinoDialog<void>(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: const Text('Missing Fields'),
                                content: const Text('Please fill out both the title and content.'),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('OK'),
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
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
                        child: Container(
                          height: 54,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [primary, accent]),
                            borderRadius: BorderRadius.circular(16),
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
                              "Save Dream Note",
                              style: bodyStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
