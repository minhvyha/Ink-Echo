import 'package:flutter/material.dart';
import 'ink_echo_brand.dart';

class AppHeader extends StatelessWidget {
  final bool showSearch;
  final bool showClose;
  final VoidCallback? onClose;

  const AppHeader({
    super.key,
    this.showSearch = false,
    this.showClose = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const InkEchoBrand(),
          const Spacer(),
          if (showSearch)
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search, color: scheme.onSurfaceVariant),
              style: IconButton.styleFrom(shape: const CircleBorder()),
            )
          else if (showClose)
            IconButton(
              icon: Icon(Icons.close, color: scheme.onSurfaceVariant),
              onPressed: onClose ?? () => Navigator.of(context).maybePop(),
              style: IconButton.styleFrom(shape: const CircleBorder()),
            ),
        ],
      ),
    );
  }
}
