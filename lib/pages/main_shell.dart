import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'vault_page.dart';
import 'reflection_page.dart';

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

  final _pages = const [
    VaultPage(),
    ReflectionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_index]),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _index,
        onChanged: (index) => setState(() => _index = index),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onLogout,
        backgroundColor: const Color(0xFF007352),
        child: const Icon(Icons.logout, color: Colors.white),
      ),
    );
  }
}