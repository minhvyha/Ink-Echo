import 'package:flutter/material.dart';

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
          const Icon(Icons.menu_book, color: Color(0xFF2BBF9B), size: 28),
          const SizedBox(width: 8),
          const Text(
            'Ink & Echo',
            style: TextStyle(
              color: Color(0xFF2BBF9B),
              fontSize: 24,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (showSearch)
            const Icon(Icons.search, color: Color(0xFF4A4742), size: 26)
          else if (showClose)
            const Icon(Icons.close, color: Color(0xFF4A4742), size: 26),
        ],
      ),
    );
  }
}