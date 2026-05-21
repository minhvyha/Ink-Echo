// Routes between LoginPage and MainShell based on Firebase auth state.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inkandecho/services/auth_service.dart';
import 'package:inkandecho/pages/login_page.dart';
import 'package:inkandecho/pages/main_shell.dart';

/// Root navigator: shows login until [User] is non-null, then the main app.
///
/// Uses [AuthService.authStateChanges] and falls back to [currentUser] while
/// the stream is waiting to avoid flashing the login screen on cold start.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        User? user = snapshot.data;
        if (user == null &&
            snapshot.connectionState == ConnectionState.waiting) {
          user = AuthService.instance.currentUser;
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Auth error: ${snapshot.error}'),
            ),
          );
        }

        if (user != null) {
          return MainShell(
            onLogout: () async {
              await FirebaseAuth.instance.signOut();
            },
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return const LoginPage();
      },
    );
  }
}
