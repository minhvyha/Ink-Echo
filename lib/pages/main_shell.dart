import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'vault_page.dart';
import 'settings_page.dart';

class MainShell extends StatefulWidget {
  final VoidCallback onLogout;

  const MainShell({
    super.key,
    required this.onLogout,
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
          VaultPage(onOpenSettings: () => setState(() => _index = 1)),
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
