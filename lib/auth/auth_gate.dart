import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/main_shell.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isSignedIn = false;

  void _handleLogin() {
    setState(() {
      _isSignedIn = true;
    });
  }

  void _handleLogout() {
    setState(() {
      _isSignedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn) {
      return MainShell(onLogout: _handleLogout);
    }

    return LoginPage(
      onLogin: _handleLogin,
    );
  }
}