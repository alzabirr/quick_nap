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
}
