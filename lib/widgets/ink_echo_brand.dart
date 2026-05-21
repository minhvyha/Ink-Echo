// Shared logo + wordmark used on vault, settings, and drawer.

import 'package:flutter/material.dart';
import '../theme/ink_echo_typography.dart';

/// Scales down on narrow widths via [FittedBox] to avoid overflow.
class InkEchoBrand extends StatelessWidget {
  const InkEchoBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu_book_rounded,
            color: scheme.primary,
            size: 28,
          ),
          const SizedBox(width: 8),
          Text(
            'Ink & Echo',
            style: context.vaultDisplayMd.copyWith(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
