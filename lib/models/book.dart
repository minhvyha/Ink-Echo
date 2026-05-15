import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String echo;
  final String? mood;
  final DateTime? createdAt;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.echo,
    this.mood,
    this.createdAt,
  });

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
      createdAt: created,
    );
  }

  Map<String, dynamic> toCreateMap() {
    return {
      'title': title,
      'author': author,
      'echo': echo,
      if (mood != null && mood!.isNotEmpty) 'mood': mood,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
