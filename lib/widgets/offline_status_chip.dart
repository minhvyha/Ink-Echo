// Compact offline badge for app bars (vault, reflection, detail).

import 'package:flutter/material.dart';
import 'package:inkandecho/services/connectivity_service.dart';

/// Visible when [ConnectivityService] reports no network.
class OfflineStatusChip extends StatelessWidget {
  const OfflineStatusChip({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ConnectivityService.instance.onOnlineChanged,
      initialData: ConnectivityService.instance.isOnline,
      builder: (context, snapshot) {
        final online = snapshot.data ?? true;
        if (online) return const SizedBox.shrink();

        final scheme = Theme.of(context).colorScheme;
        return Tooltip(
          message:
              'You are offline. Cached entries stay available; changes sync when you reconnect.',
          child: Semantics(
            label: 'Offline. Changes sync when you reconnect.',
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: scheme.errorContainer,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: scheme.onErrorContainer.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_off_outlined,
                    size: 16,
                    color: scheme.onErrorContainer,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: scheme.onErrorContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
