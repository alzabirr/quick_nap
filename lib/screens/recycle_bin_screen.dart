import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:intl/intl.dart';
import '../providers/notes_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/ambient_background.dart';
import '../widgets/glass_card.dart';

class RecycleBinScreen extends StatelessWidget {
  const RecycleBinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotesProvider>(context);
    final trash = List.from(provider.trash)
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    NesButton(
                      type: NesButtonType.normal,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(CupertinoIcons.chevron_left,
                          color: isDarkMode ? Colors.white : Colors.black, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Text('RECYCLE BIN',
                        style: headingStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    if (trash.isNotEmpty)
                      NesButton(
                        type: NesButtonType.error,
                        onPressed: () => _confirmEmptyTrash(context, provider),
                        child: Text('EMPTY',
                            style: bodyStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: trash.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(CupertinoIcons.trash,
                                color: Color(0xff808080), size: 48),
                            const SizedBox(height: 16),
                            Text('Recycle bin is empty',
                                style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('Deleted notes will appear here.',
                                style: bodyStyle(fontSize: 10, color: textMid)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                            20, 8, 20, 28.0 + MediaQuery.of(context).padding.bottom),
                        physics: const BouncingScrollPhysics(),
                        itemCount: trash.length,
                        itemBuilder: (context, index) {
                          final note = trash[index];
                          final dateStr =
                              DateFormat('EEEE, MMMM d • h:mm a').format(note.date);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: glassCard(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(note.content,
                                      style: bodyStyle(
                                          fontSize: 8,
                                          color: textDark.withValues(alpha: 0.7),
                                          height: 1.4),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Text(dateStr,
                                            style: bodyStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                                color: textMid)),
                                      ),
                                      Row(
                                        children: [
                                          NesButton(
                                            type: NesButtonType.success,
                                            onPressed: () async {
                                              await provider.restoreNote(note.id);
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Note restored',
                                                        style: bodyStyle(fontSize: 10)),
                                                    backgroundColor: surface,
                                                    duration:
                                                        const Duration(seconds: 2),
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Icon(
                                                CupertinoIcons.arrow_counterclockwise,
                                                color: Colors.white,
                                                size: 12),
                                          ),
                                          const SizedBox(width: 6),
                                          NesButton(
                                            type: NesButtonType.error,
                                            onPressed: () =>
                                                _confirmPermanentDelete(
                                                    context, provider, note.id),
                                            child: const Icon(CupertinoIcons.trash_fill,
                                                color: Colors.white, size: 12),
                                          ),
                                        ],
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

  void _confirmEmptyTrash(BuildContext context, NotesProvider provider) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surface,
        title: Text('Empty Recycle Bin?',
            style: headingStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        content: Text('All deleted notes will be permanently removed. This cannot be undone.',
            style: bodyStyle(fontSize: 10, color: textMid)),
        actions: [
          NesButton(
            type: NesButtonType.normal,
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel',
                style: bodyStyle(
                    fontSize: 10,
                    color: isDarkMode ? Colors.white : Colors.black)),
          ),
          NesButton(
            type: NesButtonType.error,
            onPressed: () async {
              Navigator.of(ctx).pop();
              await provider.emptyTrash();
            },
            child: Text('Empty', style: bodyStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  void _confirmPermanentDelete(
      BuildContext context, NotesProvider provider, String id) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surface,
        title: Text('Delete Permanently?',
            style: headingStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        content: Text('This note will be permanently deleted and cannot be recovered.',
            style: bodyStyle(fontSize: 10, color: textMid)),
        actions: [
          NesButton(
            type: NesButtonType.normal,
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel',
                style: bodyStyle(
                    fontSize: 10,
                    color: isDarkMode ? Colors.white : Colors.black)),
          ),
          NesButton(
            type: NesButtonType.error,
            onPressed: () async {
              Navigator.of(ctx).pop();
              await provider.permanentlyDeleteNote(id);
            },
            child: Text('Delete', style: bodyStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }
}
