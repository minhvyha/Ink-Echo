// Device network status for offline banners and retry UX.

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Tracks whether the device has a usable network connection.
class ConnectivityService {
  ConnectivityService._({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  static final ConnectivityService instance = ConnectivityService._();

  final Connectivity _connectivity;
  final StreamController<bool> _onlineController =
      StreamController<bool>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isOnline = true;
  bool _initialized = false;

  bool get isOnline => _isOnline;

  /// Emits the current value immediately, then updates on connectivity changes.
  Stream<bool> get onOnlineChanged async* {
    yield _isOnline;
    yield* _onlineController.stream;
  }

  /// Call once at app start ([main]) before reading vault data.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final results = await _connectivity.checkConnectivity();
    _setOnline(_isConnected(results));

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _setOnline(_isConnected(results));
    });
  }

  @visibleForTesting
  void setOnlineForTesting(bool online) {
    _setOnline(online);
  }

  void _setOnline(bool online) {
    if (_isOnline == online) return;
    _isOnline = online;
    _onlineController.add(online);
  }

  bool _isConnected(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }

  @visibleForTesting
  Future<void> disposeForTesting() async {
    await _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }
}
