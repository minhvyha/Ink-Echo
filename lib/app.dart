import 'package:flutter/material.dart';
import 'auth/auth_gate.dart';

class InkEchoApp extends StatelessWidget {
  const InkEchoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ink & Echo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFfffbff),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007352),
          brightness: Brightness.light,
        ),
      ),
      home: const AuthGate(),
    );
  }
}