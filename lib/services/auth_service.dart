import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inkandecho/config/google_auth_config.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> init() async {
    final webClientId = GoogleAuthConfig.webClientId;

    if (kIsWeb) {
      await _googleSignIn.initialize(
        clientId: webClientId.isNotEmpty ? webClientId : null,
      );
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await _googleSignIn.initialize(
        serverClientId: webClientId.isNotEmpty ? webClientId : null,
      );
      return;
    }

    await _googleSignIn.initialize();
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      if (!GoogleAuthConfig.isConfigured) {
        throw StateError(_missingWebClientIdMessage);
      }
      final provider = GoogleAuthProvider();
      return _auth.signInWithPopup(provider);
    }

    if (!GoogleAuthConfig.isConfigured) {
      throw StateError(_missingWebClientIdMessage);
    }

    final googleUser = await _googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return _auth.signInWithCredential(credential);
  }

  static const _missingWebClientIdMessage =
      'Google Sign-In is not configured. Add your Firebase Web Client ID in '
      'lib/config/google_auth_config.dart (see README).';

  static String messageForAuthError(Object error) {
    if (error is GoogleSignInException) {
      switch (error.code) {
        case GoogleSignInExceptionCode.clientConfigurationError:
          return _missingWebClientIdMessage;
        case GoogleSignInExceptionCode.canceled:
          return 'Google sign-in was cancelled.';
        default:
          return error.description ?? 'Google sign-in failed.';
      }
    }
    if (error is StateError && error.message == _missingWebClientIdMessage) {
      return _missingWebClientIdMessage;
    }
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email or password is incorrect.';
        case 'email-already-in-use':
          return 'An account already exists for this email.';
        case 'weak-password':
          return 'Password must be at least 6 characters.';
        case 'too-many-requests':
          return 'Too many attempts. Try again later.';
        case 'operation-not-allowed':
          return 'This sign-in method is not enabled in Firebase.';
        default:
          return error.message ?? 'Authentication failed.';
      }
    }
    return error.toString();
  }
}
