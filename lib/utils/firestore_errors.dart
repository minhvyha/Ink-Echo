// User-facing messages for Firestore and network failures.

import 'package:cloud_firestore/cloud_firestore.dart';

/// Maps Firestore/network errors to short UI copy with optional retry hint.
String messageForFirestoreError(Object error) {
  if (error is FirebaseException) {
    switch (error.code) {
      case 'unavailable':
      case 'deadline-exceeded':
        return 'You appear to be offline. Check your connection and try again.';
      case 'permission-denied':
        return 'You do not have permission to access this data.';
      case 'not-found':
        return 'This entry could not be found. It may have been deleted.';
      case 'resource-exhausted':
        return 'Too much data to load. Try again in a moment.';
      case 'failed-precondition':
        return 'The database needs a one-time index. See the README for markers.';
      default:
        return error.message ?? 'Could not reach the cloud. Try again.';
    }
  }
  if (error is StateError) {
    return error.message ?? 'Something went wrong.';
  }
  return 'Could not reach the cloud. Check your connection and try again.';
}

bool isLikelyOfflineError(Object error) {
  if (error is FirebaseException) {
    return error.code == 'unavailable' || error.code == 'deadline-exceeded';
  }
  return false;
}
