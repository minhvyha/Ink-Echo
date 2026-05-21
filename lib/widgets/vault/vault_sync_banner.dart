// Banners for offline mode, sync status, and load errors on the vault.

import 'package:flutter/material.dart';
import 'package:inkandecho/models/vault_books_state.dart';
import 'package:inkandecho/theme/ink_echo_typography.dart';
import 'package:inkandecho/utils/firestore_errors.dart';

/// Shown above the vault list when offline, syncing from cache, or on error.
class VaultSyncBanner extends StatelessWidget {
  final VaultBooksState state;
  final VoidCallback? onRetry;

  const VaultSyncBanner({
    super.key,
    required this.state,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (state.hasError) {
      return _BannerShell(
        background: Theme.of(context).colorScheme.errorContainer,
        foreground: Theme.of(context).colorScheme.onErrorContainer,
        icon: Icons.cloud_off_outlined,
        message: messageForFirestoreError(state.error!),
        actionLabel: onRetry != null ? 'Retry' : null,
        onAction: onRetry,
      );
    }

    if (state.showOfflineNotice) {
      return _BannerShell(
        background: Theme.of(context).colorScheme.tertiaryContainer,
        foreground: Theme.of(context).colorScheme.onTertiaryContainer,
        icon: Icons.wifi_off_rounded,
        message: state.hasPendingWrites
            ? 'You\'re offline. Showing your cached vault — changes will sync when you reconnect.'
            : 'You\'re offline. Showing your cached vault.',
        actionLabel: onRetry != null ? 'Retry' : null,
        onAction: onRetry,
      );
    }

    if (state.showSyncingNotice) {
      return _BannerShell(
        background: Theme.of(context).colorScheme.primaryContainer.withValues(
              alpha: 0.65,
            ),
        foreground: Theme.of(context).colorScheme.onPrimaryContainer,
        icon: Icons.cloud_sync_outlined,
        message: 'Syncing your latest entries…',
      );
    }

    return const SizedBox.shrink();
  }
}

class _BannerShell extends StatelessWidget {
  final Color background;
  final Color foreground;
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _BannerShell({
    required this.background,
    required this.foreground,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: foreground, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: context.vaultBodyLg.copyWith(
                  color: foreground,
                  fontSize: 14,
                  height: 1.35,
                ),
              ),
            ),
            if (actionLabel != null && onAction != null)
              TextButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
          ],
        ),
      ),
    );
  }
}
