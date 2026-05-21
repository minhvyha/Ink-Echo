import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/services/book_service.dart';
import 'package:inkandecho/services/connectivity_service.dart';
import 'package:inkandecho/utils/image_base64_encoder.dart';

void main() {
  group('BookService', () {
    late FakeFirebaseFirestore firestore;
    late MockFirebaseAuth auth;
    late BookService service;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'user-123', email: 'reader@test.com'),
      );
      service = BookService.forTesting(firestore: firestore, auth: auth);
    });

    test('watchBooks emits empty list when signed out', () async {
      final signedOut = BookService.forTesting(
        firestore: firestore,
        auth: MockFirebaseAuth(),
      );

      expect(signedOut.watchBooks(), emits(const []));
    });

    test('saveBook writes document under user books collection', () async {
      await service.saveBook(
        title: '  Piranesi  ',
        author: ' Susanna Clarke ',
        echo: 'The House',
        mood: '  Atmospheric ',
        transcription: '  hello  ',
      );

      final snap = await firestore
          .collection('users')
          .doc('user-123')
          .collection('books')
          .get();

      expect(snap.docs, hasLength(1));
      final data = snap.docs.first.data();
      expect(data['title'], 'Piranesi');
      expect(data['author'], 'Susanna Clarke');
      expect(data['echo'], 'The House');
      expect(data['mood'], 'Atmospheric');
      expect(data['transcription'], 'hello');
    });

    test('saveBook throws when cover exceeds size limit', () async {
      final huge = 'x' * (maxCoverBase64Length + 1);

      expect(
        () => service.saveBook(
          title: 'T',
          author: 'A',
          echo: '',
          coverImageBase64: huge,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('saveBook throws when user is not signed in', () async {
      final signedOut = BookService.forTesting(
        firestore: firestore,
        auth: MockFirebaseAuth(),
      );

      expect(
        () => signedOut.saveBook(title: 'T', author: 'A', echo: ''),
        throwsA(isA<StateError>()),
      );
    });

    test('watchVault reflects offline connectivity', () async {
      ConnectivityService.instance.setOnlineForTesting(false);
      addTearDown(() => ConnectivityService.instance.setOnlineForTesting(true));

      await service.saveBook(title: 'Cached', author: 'A', echo: 'E');

      final state = await service.watchVault().firstWhere(
        (s) => !s.isLoading && s.books.isNotEmpty,
      );
      expect(state.isOffline, isTrue);
      expect(state.books.first.title, 'Cached');
    });

    test('watchBooks emits saved books for signed-in user', () async {
      await service.saveBook(
        title: 'Book A',
        author: 'Author A',
        echo: 'Echo A',
      );

      final books = await service.watchBooks().firstWhere((b) => b.isNotEmpty);
      expect(books, hasLength(1));
      expect(books.first.title, 'Book A');
      expect(books.first.author, 'Author A');
    });

    test('updateBook changes an existing document', () async {
      await service.saveBook(
        title: 'Original',
        author: 'Author',
        echo: 'Echo',
        mood: 'Calm',
      );

      final id = (await firestore
              .collection('users')
              .doc('user-123')
              .collection('books')
              .get())
          .docs
          .first
          .id;

      await service.updateBook(
        bookId: id,
        title: 'Revised',
        author: 'New Author',
        echo: 'New echo',
        mood: null,
      );

      final data = (await firestore
              .collection('users')
              .doc('user-123')
              .collection('books')
              .doc(id)
              .get())
          .data()!;

      expect(data['title'], 'Revised');
      expect(data['author'], 'New Author');
      expect(data['echo'], 'New echo');
      expect(data.containsKey('mood'), isFalse);
    });

    test('updateBook throws when user is not signed in', () async {
      final signedOut = BookService.forTesting(
        firestore: firestore,
        auth: MockFirebaseAuth(),
      );

      expect(
        () => signedOut.updateBook(
          bookId: 'any',
          title: 'T',
          author: 'A',
          echo: '',
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('deleteBook throws when user is not signed in', () async {
      final signedOut = BookService.forTesting(
        firestore: firestore,
        auth: MockFirebaseAuth(),
      );

      expect(
        () => signedOut.deleteBook('any'),
        throwsA(isA<StateError>()),
      );
    });

    test('deleteBook removes document', () async {
      await service.saveBook(title: 'Gone', author: 'A', echo: '');
      final id = (await firestore
              .collection('users')
              .doc('user-123')
              .collection('books')
              .get())
          .docs
          .first
          .id;

      await service.deleteBook(id);

      final snap = await firestore
          .collection('users')
          .doc('user-123')
          .collection('books')
          .get();
      expect(snap.docs, isEmpty);
    });
  });
}
