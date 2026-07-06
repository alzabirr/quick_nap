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
import 'dream_note_editor_screen.dart';

class DreamNotesScreen extends StatelessWidget {
  final double? bottomPadding;

  const DreamNotesScreen({super.key, this.bottomPadding});

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final double listBottomPadding = bottomPadding ?? (28.0 + MediaQuery.of(context).padding.bottom);
    
    final notes = List<DreamNote>.from(notesProvider.notes);
    notes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.date.compareTo(a.date); // Newest first
    });

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
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DreamNoteEditorScreen(),
                          ),
                        );
                      },
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
                          final note = notes[index];
                          final dateStr = DateFormat('EEEE, MMMM d • h:mm a').format(note.date);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => DreamNoteEditorScreen(note: note),
                                  ),
                                );
                              },
                              child: glassCard(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(note.content, style: bodyStyle(fontSize: 8, color: textDark.withValues(alpha: 0.85), height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 14),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              if (note.isPinned) ...[
                                                Icon(CupertinoIcons.pin_fill, color: primary, size: 10),
                                                const SizedBox(width: 4),
                                              ],
                                              Expanded(
                                                child: Text(dateStr, style: bodyStyle(fontSize: 8, fontWeight: FontWeight.bold, color: textMid)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        NesButton(
                                          type: NesButtonType.normal,
                                          onPressed: () => _confirmDelete(context, notesProvider, note),
                                          child: const Icon(CupertinoIcons.trash, color: Color(0xffe76e55), size: 12),
                                        ),
                                      ],
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
              child: Text('Cancel', style: bodyStyle(fontSize: 10, color: isDarkMode ? Colors.white : Colors.black)),
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

}
