import 'package:uuid/uuid.dart';

class DreamNote {
  final String id;
  final DateTime date;
  final String title;
  final String content;
  final int lucidityScore; // 1-5
  final String moodEmoji; // Emoji representing dream mood
  final String category; // 'dream', 'nightmare', 'lucid', 'reflection'

  DreamNote({
    String? id,
    required this.date,
    required this.title,
    required this.content,
    required this.lucidityScore,
    required this.moodEmoji,
    required this.category,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'title': title,
        'content': content,
        'lucidityScore': lucidityScore,
        'moodEmoji': moodEmoji,
        'category': category,
      };

  factory DreamNote.fromJson(Map<String, dynamic> json) => DreamNote(
        id: json['id'] as String?,
        date: DateTime.parse(json['date'] as String),
        title: json['title'] as String? ?? '',
        content: json['content'] as String? ?? '',
        lucidityScore: json['lucidityScore'] as int? ?? 1,
        moodEmoji: json['moodEmoji'] as String? ?? '😐',
        category: json['category'] as String? ?? 'dream',
      );
}
