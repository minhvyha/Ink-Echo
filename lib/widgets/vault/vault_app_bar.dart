import 'dart:ui';

import 'package:flutter/material.dart';
import '../../theme/ink_echo_typography.dart';

class VaultAppBar extends StatelessWidget {
  const VaultAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: scheme.surface.withValues(alpha: 0.82),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.menu, color: scheme.onSurfaceVariant),
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                ),
              ),
              Expanded(
                child: Text(
                  'Ink & Echo',
                  textAlign: TextAlign.center,
                  style: context.vaultDisplayMd,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search, color: scheme.onSurfaceVariant),
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
