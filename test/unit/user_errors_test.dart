import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/utils/user_errors.dart';

void main() {
  group('UserFacingError', () {
    test('maps Firestore offline codes', () {
      final err = UserFacingError.from(
        FirebaseException(code: 'unavailable', plugin: 'cloud_firestore'),
      );
      expect(err.isOffline, isTrue);
      expect(err.message, contains('offline'));
      expect(err.canRetry, isTrue);
    });

    test('maps cover size StateError without retry', () {
      final err = UserFacingError.from(
        StateError('Cover image is too large. Please use a smaller photo.'),
      );
      expect(err.canRetry, isFalse);
      expect(err.message, contains('too large'));
    });

    test('snackbarText appends offline note', () {
      final err = UserFacingError(
        message: 'Offline.',
        isOffline: true,
      );
      expect(
        err.snackbarText(offlineNote: kOfflineWriteNote),
        contains(kOfflineWriteNote),
      );
    });
  });
}
