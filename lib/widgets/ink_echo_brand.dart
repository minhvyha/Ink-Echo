import 'package:flutter/material.dart';
import '../theme/ink_echo_typography.dart';

/// Logo + wordmark used in app chrome (vault bar, reflection header, etc.).
class InkEchoBrand extends StatelessWidget {
  const InkEchoBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
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
    );
  }
}
