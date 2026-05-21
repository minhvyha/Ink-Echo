// Domain model for one vault entry stored under users/{uid}/books/{id}.

import 'package:cloud_firestore/cloud_firestore.dart';

/// A single reading journal entry (book + reflection metadata).
///
/// Maps to Firestore fields: title, author, echo, mood, coverImageBase64,
/// transcription, createdAt.
class Book {
  final String id;
  final String title;
  final String author;
  final String echo;
  final String? mood;
  final String? coverImageBase64;
  final String? transcription;
  final DateTime? createdAt;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.echo,
    this.mood,
    this.coverImageBase64,
    this.transcription,
    this.createdAt,
  });

  /// Builds a [Book] from a Firestore document snapshot.
  factory Book.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final raw = data['createdAt'];
    DateTime? created;
    if (raw is Timestamp) {
      created = raw.toDate();
    }
    return Book(
      id: doc.id,
      title: data['title'] as String? ?? '',
      author: data['author'] as String? ?? '',
      echo: data['echo'] as String? ?? '',
      mood: data['mood'] as String?,
      coverImageBase64: data['coverImageBase64'] as String?,
      transcription: data['transcription'] as String?,
      createdAt: created,
    );
  }

  /// Payload for [BookService.saveBook]; sets server timestamp on create.
  Map<String, dynamic> toCreateMap() {
    return {
      'title': title,
      'author': author,
      'echo': echo,
      if (mood != null && mood!.isNotEmpty) 'mood': mood,
      if (coverImageBase64 != null && coverImageBase64!.isNotEmpty)
        'coverImageBase64': coverImageBase64,
      if (transcription != null && transcription!.isNotEmpty)
        'transcription': transcription,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  /// Payload for [BookService.updateBook]; omits createdAt, clears empty optionals.
  static Map<String, dynamic> fieldsForUpdate({
    required String title,
    required String author,
    required String echo,
    String? mood,
    String? coverImageBase64,
    String? transcription,
  }) {
    final map = <String, dynamic>{
      'title': title.trim(),
      'author': author.trim(),
      'echo': echo.trim(),
    };

    final trimmedMood = mood?.trim();
    if (trimmedMood != null && trimmedMood.isNotEmpty) {
      map['mood'] = trimmedMood;
    } else {
      map['mood'] = FieldValue.delete();
    }

    if (coverImageBase64 != null && coverImageBase64.isNotEmpty) {
      map['coverImageBase64'] = coverImageBase64;
    } else {
      map['coverImageBase64'] = FieldValue.delete();
    }

    final trimmedTranscription = transcription?.trim();
    if (trimmedTranscription != null && trimmedTranscription.isNotEmpty) {
      map['transcription'] = trimmedTranscription;
    } else {
      map['transcription'] = FieldValue.delete();
    }

    return map;
  }
}
