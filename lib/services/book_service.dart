// Firestore CRUD for per-user book entries (users/{uid}/books).

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:inkandecho/models/book.dart';
import 'package:inkandecho/utils/image_base64_encoder.dart';

/// Singleton gateway to the signed-in user's `books` subcollection.
///
/// All paths are scoped by [FirebaseAuth.currentUser] so each account
/// only sees its own vault data.
class BookService {
  BookService._({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  static final BookService instance = BookService._();

  /// Injected Firestore/Auth for unit tests ([fake_cloud_firestore]).
  @visibleForTesting
  factory BookService.forTesting({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) {
    return BookService._(firestore: firestore, auth: auth);
  }

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  /// Returns `users/{uid}/books` or null when signed out.
  CollectionReference<Map<String, dynamic>>? _booksRef() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('books');
  }

  /// Live list of entries, newest first (requires Firestore index on createdAt).
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

  /// Creates a new document with auto-generated id.
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

    _ensureCoverSizeAllowed(coverImageBase64);

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

  /// Overwrites fields on an existing entry; clears optional fields when empty.
  Future<void> updateBook({
    required String bookId,
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

    _ensureCoverSizeAllowed(coverImageBase64);

    await ref.doc(bookId).update(
      Book.fieldsForUpdate(
        title: title,
        author: author,
        echo: echo,
        mood: mood,
        coverImageBase64: coverImageBase64,
        transcription: transcription,
      ),
    );
  }

  /// Permanently removes one entry from the vault.
  Future<void> deleteBook(String bookId) async {
    final ref = _booksRef();
    if (ref == null) {
      throw StateError('No signed-in user');
    }
    await ref.doc(bookId).delete();
  }

  void _ensureCoverSizeAllowed(String? coverImageBase64) {
    if (coverImageBase64 != null &&
        coverImageBase64.length > maxCoverBase64Length) {
      throw StateError(
        'Cover image is too large. Please use a smaller photo.',
      );
    }
  }
}
