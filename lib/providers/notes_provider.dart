import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/dream_note.dart';
import '../storage/hive_storage.dart';

class NotesProvider with ChangeNotifier {
  final HiveStorage _storage = HiveStorage();
  List<DreamNote> _notes = [];

  List<DreamNote> get notes => _notes;

  NotesProvider() {
    _loadNotes();
  }

  void _loadNotes() {
    final notesJson = _storage.getSetting('dream_notes_list', null);
    if (notesJson != null) {
      try {
        final decoded = jsonDecode(notesJson as String) as List<dynamic>;
        _notes = decoded.map((item) => DreamNote.fromJson(item as Map<String, dynamic>)).toList();
      } catch (e) {
        _notes = [];
      }
    } else {
      _notes = [];
    }
    notifyListeners();
  }

  Future<void> addNote(DreamNote note) async {
    _notes.add(note);
    await _saveNotes();
    notifyListeners();
  }

  Future<void> updateNote(DreamNote updatedNote) async {
    final index = _notes.indexWhere((n) => n.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      await _saveNotes();
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((n) => n.id == id);
    await _saveNotes();
    notifyListeners();
  }

  Future<void> _saveNotes() async {
    await _storage.saveSetting('dream_notes_list', jsonEncode(_notes.map((n) => n.toJson()).toList()));
  }

  void _seedInitialNotes() {
    final now = DateTime.now();
    _notes = [
      DreamNote(
        date: now.subtract(const Duration(days: 1)),
        title: 'Flying over mountains 🏔️',
        content: 'I had a vivid dream where I was soaring high above a range of snowy mountains. The wind felt so real and cold. I could control my flight by leaning forward.',
        lucidityScore: 4,
        moodEmoji: '🤩',
        category: 'lucid',
      ),
      DreamNote(
        date: now.subtract(const Duration(days: 3)),
        title: 'Lost in a neon library 📚',
        content: 'Walking through endless rows of books glowing in purple and cyan lights. I was trying to find a specific book about stars but the letters kept changing whenever I looked closely.',
        lucidityScore: 2,
        moodEmoji: '🙂',
        category: 'dream',
      ),
    ];
    _saveNotes();
  }
}
