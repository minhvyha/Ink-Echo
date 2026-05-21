// Signed-in shell: Vault + Settings tabs with bottom navigation.

import 'package:flutter/material.dart';
import '../services/book_service.dart';
import '../widgets/bottom_nav_bar.dart';
import 'vault_page.dart';
import 'settings_page.dart';

/// Hosts [VaultPage] and [SettingsPage]; preserves tab state via [IndexedStack].
class MainShell extends StatefulWidget {
  final VoidCallback onLogout;
  final BookService? bookService;

  const MainShell({
    super.key,
    required this.onLogout,
    this.bookService,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          VaultPage(
            onOpenSettings: () => setState(() => _index = 1),
            bookService: widget.bookService,
          ),
          SettingsPage(onLogout: widget.onLogout),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _index,
        onChanged: (index) => setState(() => _index = index),
      ),
    );
  }
}
