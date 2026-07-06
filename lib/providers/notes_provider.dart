import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/dream_note.dart';
import '../storage/hive_storage.dart';

class NotesProvider with ChangeNotifier {
  final HiveStorage _storage = HiveStorage();
  List<DreamNote> _notes = [];
  List<DreamNote> _trash = [];

  List<DreamNote> get notes => _notes;
  List<DreamNote> get trash => _trash;

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

    final trashJson = _storage.getSetting('dream_notes_trash', null);
    if (trashJson != null) {
      try {
        final decoded = jsonDecode(trashJson as String) as List<dynamic>;
        _trash = decoded.map((item) => DreamNote.fromJson(item as Map<String, dynamic>)).toList();
      } catch (e) {
        _trash = [];
      }
    } else {
      _trash = [];
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

  /// Soft delete: moves note to trash
  Future<void> deleteNote(String id) async {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _trash.add(_notes[index]);
      _notes.removeAt(index);
      await _saveNotes();
      await _saveTrash();
      notifyListeners();
    }
  }

  /// Restore note from trash back to notes
  Future<void> restoreNote(String id) async {
    final index = _trash.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notes.add(_trash[index]);
      _trash.removeAt(index);
      await _saveNotes();
      await _saveTrash();
      notifyListeners();
    }
  }

  /// Permanently delete a note from trash
  Future<void> permanentlyDeleteNote(String id) async {
    _trash.removeWhere((n) => n.id == id);
    await _saveTrash();
    notifyListeners();
  }

  /// Empty the entire trash
  Future<void> emptyTrash() async {
    _trash = [];
    await _saveTrash();
    notifyListeners();
  }

  Future<void> _saveNotes() async {
    await _storage.saveSetting('dream_notes_list', jsonEncode(_notes.map((n) => n.toJson()).toList()));
  }

  Future<void> _saveTrash() async {
    await _storage.saveSetting('dream_notes_trash', jsonEncode(_trash.map((n) => n.toJson()).toList()));
  }
}
