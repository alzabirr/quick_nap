import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dream_note.dart';
import '../providers/notes_provider.dart';
import '../themes/app_theme.dart';

class DreamNoteEditorScreen extends StatefulWidget {
  final DreamNote? note;

  const DreamNoteEditorScreen({super.key, this.note});

  @override
  State<DreamNoteEditorScreen> createState() => _DreamNoteEditorScreenState();
}

class _DreamNoteEditorScreenState extends State<DreamNoteEditorScreen> {
  late final TextEditingController _contentController;
  late bool _isPinned;
  late bool _isReadOnly;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _isPinned = widget.note?.isPinned ?? false;
    _isReadOnly = widget.note != null; // Start read-only if we are viewing an existing note
  }

  @override
  void dispose() {
    _contentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _saveAndPop() {
    final contentText = _contentController.text.trim();

    if (contentText.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    final finalTitle = contentText.split('\n').first.trim().length > 25
        ? '${contentText.split('\n').first.trim().substring(0, 25)}...'
        : contentText.split('\n').first.trim();

    final notesProvider = Provider.of<NotesProvider>(context, listen: false);

    if (widget.note == null) {
      notesProvider.addNote(DreamNote(
        date: DateTime.now(),
        title: finalTitle,
        content: contentText,
        lucidityScore: 3,
        moodEmoji: '',
        category: 'dream',
        isPinned: _isPinned,
      ));
    } else {
      notesProvider.updateNote(DreamNote(
        id: widget.note!.id,
        date: widget.note!.date,
        title: finalTitle,
        content: contentText,
        lucidityScore: widget.note!.lucidityScore,
        moodEmoji: widget.note!.moodEmoji,
        category: widget.note!.category,
        isPinned: _isPinned,
      ));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(CupertinoIcons.left_chevron, color: textDark),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),

                  IconButton(
                    icon: Icon(
                      _isPinned ? CupertinoIcons.pin_fill : CupertinoIcons.pin,
                      color: _isPinned ? primary : textDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPinned = !_isPinned;
                      });
                      // If we are just toggling pin while viewing, let's auto-save the pin status directly
                      if (widget.note != null && _isReadOnly) {
                        final notesProvider = Provider.of<NotesProvider>(context, listen: false);
                        notesProvider.updateNote(DreamNote(
                          id: widget.note!.id,
                          date: widget.note!.date,
                          title: widget.note!.title,
                          content: _contentController.text,
                          lucidityScore: widget.note!.lucidityScore,
                          moodEmoji: widget.note!.moodEmoji,
                          category: widget.note!.category,
                          isPinned: _isPinned,
                        ));
                      }
                    },
                  ),
                  // Save button (only enabled/visible if not read-only or we want to save changes)
                  TextButton(
                    onPressed: _saveAndPop,
                    child: Text(
                      'SAVE',
                      style: bodyStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            
            // Note Fields Area (Only Description, NO Title box)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _contentController,
                  focusNode: _focusNode,
                  readOnly: _isReadOnly,
                  style: bodyStyle(fontSize: 11, height: 1.5),
                  decoration: InputDecoration(
                    hintText: 'Add your dream...',
                    hintStyle: bodyStyle(fontSize: 11, color: textMid.withValues(alpha: 0.5)),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  autofocus: widget.note == null,
                  onTap: () {
                    if (_isReadOnly) {
                      setState(() {
                        _isReadOnly = false;
                      });
                      _focusNode.requestFocus();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
