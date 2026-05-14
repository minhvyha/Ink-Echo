// auth_gate.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inkandecho/services/auth_service.dart';
import 'package:inkandecho/pages/login_page.dart';
import 'package:inkandecho/pages/home_page.dart';
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        debugPrint(
          'AuthGate: connection=${snapshot.connectionState}, '
          'hasData=${snapshot.hasData}, user=${snapshot.data?.email}',
        );

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Auth error: ${snapshot.error}'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data != null) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}