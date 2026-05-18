import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/models/book.dart';

void main() {
  group('Book', () {
    test('toCreateMap includes core fields and server timestamp', () {
      const book = Book(
        id: 'x',
        title: '  Dune  ',
        author: ' Herbert ',
        echo: 'Fear is the mind-killer',
        mood: 'Inspiring',
        transcription: '  spoken note  ',
        coverImageBase64: 'abc123',
      );

      final map = book.toCreateMap();

      expect(map['title'], '  Dune  ');
      expect(map['author'], ' Herbert ');
      expect(map['echo'], 'Fear is the mind-killer');
      expect(map['mood'], 'Inspiring');
      expect(map['transcription'], '  spoken note  ');
      expect(map['coverImageBase64'], 'abc123');
      expect(map['createdAt'], isA<FieldValue>());
    });

    test('toCreateMap omits empty optional fields', () {
      const book = Book(
        id: 'x',
        title: 'Title',
        author: 'Author',
        echo: '',
        mood: '',
        transcription: '',
        coverImageBase64: '',
      );

      final map = book.toCreateMap();

      expect(map.containsKey('mood'), isFalse);
      expect(map.containsKey('transcription'), isFalse);
      expect(map.containsKey('coverImageBase64'), isFalse);
    });

    test('fromDoc maps Firestore document fields', () async {
      final firestore = FakeFirebaseFirestore();
      final created = DateTime(2024, 8, 12);

      await firestore.collection('books').doc('doc-1').set({
        'title': 'Piranesi',
        'author': 'Susanna Clarke',
        'echo': 'The Beauty of the House is immeasurable.',
        'mood': 'Atmospheric',
        'transcription': 'A voice note',
        'createdAt': Timestamp.fromDate(created),
      });

      final doc = await firestore.collection('books').doc('doc-1').get();
      final book = Book.fromDoc(doc);

      expect(book.id, 'doc-1');
      expect(book.title, 'Piranesi');
      expect(book.author, 'Susanna Clarke');
      expect(book.echo, 'The Beauty of the House is immeasurable.');
      expect(book.mood, 'Atmospheric');
      expect(book.transcription, 'A voice note');
      expect(book.createdAt, created);
    });

    test('fromDoc uses defaults for missing fields', () async {
      final firestore = FakeFirebaseFirestore();
      await firestore.collection('books').doc('empty').set({});

      final doc = await firestore.collection('books').doc('empty').get();
      final book = Book.fromDoc(doc);

      expect(book.title, '');
      expect(book.author, '');
      expect(book.echo, '');
      expect(book.mood, isNull);
      expect(book.createdAt, isNull);
    });
  });
}
