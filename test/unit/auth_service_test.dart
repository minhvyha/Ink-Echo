import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/services/auth_service.dart';

void main() {
  group('AuthService.messageForAuthError', () {
    test('maps known FirebaseAuthException codes', () {
      expect(
        AuthService.messageForAuthError(
          FirebaseAuthException(code: 'invalid-email'),
        ),
        'Please enter a valid email address.',
      );
      expect(
        AuthService.messageForAuthError(
          FirebaseAuthException(code: 'wrong-password'),
        ),
        'Email or password is incorrect.',
      );
      expect(
        AuthService.messageForAuthError(
          FirebaseAuthException(code: 'weak-password'),
        ),
        'Password must be at least 6 characters.',
      );
    });

    test('maps additional FirebaseAuthException codes', () {
      expect(
        AuthService.messageForAuthError(
          FirebaseAuthException(code: 'user-disabled'),
        ),
        'This account has been disabled.',
      );
      expect(
        AuthService.messageForAuthError(
          FirebaseAuthException(code: 'email-already-in-use'),
        ),
        'An account already exists for this email.',
      );
      expect(
        AuthService.messageForAuthError(
          FirebaseAuthException(code: 'too-many-requests'),
        ),
        'Too many attempts. Try again later.',
      );
      expect(
        AuthService.messageForAuthError(
          FirebaseAuthException(code: 'operation-not-allowed'),
        ),
        'This sign-in method is not enabled in Firebase.',
      );
      expect(
        AuthService.messageForAuthError(
          FirebaseAuthException(code: 'invalid-credential'),
        ),
        'Email or password is incorrect.',
      );
    });

    test('falls back for unknown errors', () {
      expect(
        AuthService.messageForAuthError(
          FirebaseAuthException(code: 'custom', message: 'Custom failure'),
        ),
        'Custom failure',
      );
      expect(
        AuthService.messageForAuthError(Exception('network')),
        contains('network'),
      );
    });
  });
}
