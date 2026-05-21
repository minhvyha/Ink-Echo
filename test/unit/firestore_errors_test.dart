import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/utils/firestore_errors.dart';

void main() {
  group('messageForFirestoreError', () {
    test('maps offline-related codes', () {
      expect(
        messageForFirestoreError(
          FirebaseException(code: 'unavailable', plugin: 'cloud_firestore'),
        ),
        contains('offline'),
      );
      expect(
        isLikelyOfflineError(
          FirebaseException(code: 'deadline-exceeded', plugin: 'cloud_firestore'),
        ),
        isTrue,
      );
    });

    test('maps permission and not-found codes', () {
      expect(
        messageForFirestoreError(
          FirebaseException(code: 'permission-denied', plugin: 'cloud_firestore'),
        ),
        contains('permission'),
      );
    });
  });
}
