import 'package:flutter/material.dart';
import '../theme/ink_echo_theme.dart';

class AppHeader extends StatelessWidget {
  final bool showSearch;
  final bool showClose;

  const AppHeader({
    super.key,
    this.showSearch = false,
    this.showClose = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.menu_book, color: context.inkAccent, size: 28),
          const SizedBox(width: 8),
          Text(
            'Ink & Echo',
            style: TextStyle(
              color: context.inkAccent,
              fontSize: 24,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (showSearch)
            Icon(Icons.search, color: context.inkPrimaryText, size: 26)
          else if (showClose)
            Icon(Icons.close, color: context.inkPrimaryText, size: 26),
        ],
      ),
    );
  }
}