// One-time Firestore setup: offline persistence on mobile, desktop, and web.

import 'package:cloud_firestore/cloud_firestore.dart';

/// Enables local cache so the vault works offline and syncs when back online.
Future<void> configureFirestore() async {
  final db = FirebaseFirestore.instance;
  db.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
}
