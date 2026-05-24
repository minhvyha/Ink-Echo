// User-facing messages for Firestore and network failures.

import 'dart:async';
import 'dart:io';

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
      case 'aborted':
        return 'The request was interrupted. Please try again.';
      case 'already-exists':
        return 'This entry already exists.';
      case 'cancelled':
        return 'The request was cancelled. Try again.';
      case 'internal':
        return 'A server error occurred. Try again in a moment.';
      case 'unauthenticated':
        return 'Your session expired. Please sign in again.';
      default:
        return error.message ?? 'Could not reach the cloud. Try again.';
    }
  }
  if (error is StateError) {
    return error.message.isNotEmpty ? error.message : 'Something went wrong.';
  }
  if (error is SocketException) {
    return 'You appear to be offline. Check your connection and try again.';
  }
  if (error is TimeoutException) {
    return 'The request timed out. Check your connection and try again.';
  }
  final text = error.toString().toLowerCase();
  if (text.contains('network') ||
      text.contains('offline') ||
      text.contains('connection') ||
      text.contains('host lookup')) {
    return 'You appear to be offline. Check your connection and try again.';
  }
  return 'Could not reach the cloud. Check your connection and try again.';
}

bool isLikelyOfflineError(Object error) {
  if (error is FirebaseException) {
    return error.code == 'unavailable' || error.code == 'deadline-exceeded';
  }
  if (error is SocketException || error is TimeoutException) {
    return true;
  }
  final text = error.toString().toLowerCase();
  return text.contains('network') ||
      text.contains('offline') ||
      text.contains('connection') ||
      text.contains('host lookup');
}
