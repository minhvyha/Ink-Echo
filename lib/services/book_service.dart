import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inkandecho/models/book.dart';
import 'package:inkandecho/utils/image_base64_encoder.dart';

class BookService {
  BookService._();
  static final BookService instance = BookService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>>? _booksRef() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('books');
  }

  Stream<List<Book>> watchBooks() {
    final ref = _booksRef();
    if (ref == null) {
      return Stream.value(const <Book>[]);
    }
    return ref
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Book.fromDoc).toList());
  }

  Future<void> saveBook({
    required String title,
    required String author,
    required String echo,
    String? mood,
    String? coverImageBase64,
    String? transcription,
  }) async {
    final ref = _booksRef();
    if (ref == null) {
      throw StateError('No signed-in user');
    }

    if (coverImageBase64 != null &&
        coverImageBase64.length > maxCoverBase64Length) {
      throw StateError(
        'Cover image is too large. Please use a smaller photo.',
      );
    }

    final trimmedMood = mood?.trim();
    final book = Book(
      id: '',
      title: title.trim(),
      author: author.trim(),
      echo: echo.trim(),
      mood: (trimmedMood == null || trimmedMood.isEmpty) ? null : trimmedMood,
      coverImageBase64: coverImageBase64,
      transcription: transcription?.trim().isEmpty ?? true
          ? null
          : transcription!.trim(),
    );

    await ref.add(book.toCreateMap());
  }
}
