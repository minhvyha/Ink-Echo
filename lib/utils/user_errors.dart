// Unified user-facing errors, offline detection, and trust feedback snackbars.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inkandecho/services/auth_service.dart';
import 'package:inkandecho/utils/firestore_errors.dart';

export 'firestore_errors.dart' show isLikelyOfflineError, messageForFirestoreError;

/// Parsed error for consistent UI copy and retry behaviour.
class UserFacingError {
  final String message;
  final bool isOffline;
  final bool canRetry;

  const UserFacingError({
    required this.message,
    this.isOffline = false,
    this.canRetry = true,
  });

  factory UserFacingError.from(Object error) {
    if (error is UserFacingError) return error;

    if (error is FirebaseAuthException || error is GoogleSignInException) {
      return UserFacingError(
        message: AuthService.messageForAuthError(error),
        canRetry: true,
      );
    }

    if (error is StateError) {
      final msg = error.message.isNotEmpty
          ? error.message
          : 'Something went wrong.';
      final authMapped = AuthService.messageForAuthError(error);
      if (authMapped != error.toString() &&
          (msg.contains('Google Sign-In') ||
              msg.contains('Web Client ID') ||
              msg.contains('SHA-1'))) {
        return UserFacingError(message: authMapped, canRetry: true);
      }
      if (msg.contains('No signed-in user')) {
        return UserFacingError(
          message: 'Your session expired. Please sign in again.',
          canRetry: false,
        );
      }
      if (msg.contains('too large')) {
        return UserFacingError(message: msg, canRetry: false);
      }
      return UserFacingError(message: msg);
    }

    final offline = isLikelyOfflineError(error);
    return UserFacingError(
      message: messageForFirestoreError(error),
      isOffline: offline,
      canRetry: true,
    );
  }

  /// Full snackbar text with optional offline reassurance.
  String snackbarText({String? offlineNote}) {
    if (isOffline && offlineNote != null && offlineNote.isNotEmpty) {
      return '$message $offlineNote';
    }
    return message;
  }
}

/// Default reassurance when a write fails while offline (Firestore may queue).
const String kOfflineWriteNote =
    'Your change will sync when you reconnect.';

const String kOfflineDeleteNote =
    'The entry will be removed when you reconnect.';

/// Shows a floating snackbar with optional Retry action.
void showTrustSnackBar(
  BuildContext context, {
  required String message,
  VoidCallback? onRetry,
  Duration duration = const Duration(seconds: 5),
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: duration,
      action: onRetry != null
          ? SnackBarAction(
              label: 'Retry',
              onPressed: onRetry,
            )
          : null,
    ),
  );
}

/// Maps [error] to friendly copy and shows a trust snackbar.
void showTrustErrorSnackBar(
  BuildContext context,
  Object error, {
  VoidCallback? onRetry,
  String? offlineNote,
}) {
  final parsed = UserFacingError.from(error);
  showTrustSnackBar(
    context,
    message: parsed.snackbarText(offlineNote: offlineNote),
    onRetry: parsed.canRetry ? onRetry : null,
  );
}

void showTrustSuccessSnackBar(BuildContext context, String message) {
  showTrustSnackBar(
    context,
    message: message,
    duration: const Duration(seconds: 3),
  );
}

/// Confirms destructive actions (sign out, delete, discard).
Future<bool> confirmTrustAction(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool destructive = false,
}) async {
  final scheme = Theme.of(context).colorScheme;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: destructive
              ? TextButton.styleFrom(foregroundColor: scheme.error)
              : null,
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
