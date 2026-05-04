import 'package:flutter/material.dart';
import 'pages/main_shell.dart';

class InkEchoApp extends StatelessWidget {
  const InkEchoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ink & Echo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFDF8F4),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2BBF9B),
          brightness: Brightness.light,
        ),
      ),
      home: const MainShell(),
    );
  }
}