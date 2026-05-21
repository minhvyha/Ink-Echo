// Vault list state from Firestore snapshots + device connectivity.

import 'package:inkandecho/models/book.dart';

/// Combined read model for [BookService.watchVault]: data, cache, and errors.
class VaultBooksState {
  final List<Book> books;
  final bool isLoading;
  final bool isFromCache;
  final bool isOffline;
  final bool hasPendingWrites;
  final Object? error;

  const VaultBooksState({
    required this.books,
    this.isLoading = false,
    this.isFromCache = false,
    this.isOffline = false,
    this.hasPendingWrites = false,
    this.error,
  });

  const VaultBooksState.loading()
      : books = const [],
        isLoading = true,
        isFromCache = false,
        isOffline = false,
        hasPendingWrites = false,
        error = null;

  bool get hasError => error != null;

  /// Show offline / cached-data notice while the user can still browse.
  bool get showOfflineNotice =>
      isOffline && books.isNotEmpty && !isLoading && !hasError;

  /// Offline with no cached entries yet (first launch or cleared cache).
  bool get showOfflineEmpty =>
      isOffline && books.isEmpty && !isLoading && !hasError;

  /// Waiting for server data while online.
  bool get showSyncingNotice =>
      !isOffline &&
      !isLoading &&
      !hasError &&
      (isFromCache || hasPendingWrites) &&
      books.isNotEmpty;

  VaultBooksState copyWith({
    List<Book>? books,
    bool? isLoading,
    bool? isFromCache,
    bool? isOffline,
    bool? hasPendingWrites,
    Object? error,
    bool clearError = false,
  }) {
    return VaultBooksState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      isFromCache: isFromCache ?? this.isFromCache,
      isOffline: isOffline ?? this.isOffline,
      hasPendingWrites: hasPendingWrites ?? this.hasPendingWrites,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
