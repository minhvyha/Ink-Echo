import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/common_buttons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppHeader(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 420,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(34),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF0C39B), Color(0xFF8B5E3C)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 16,
                            right: 18,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7D8CF),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Text(
                                'New Chapter',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF7A5148),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            right: 20,
                            bottom: 24,
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE1D2C8).withOpacity(0.92),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '"A room without books is like\na body without a soul."',
                                    style: TextStyle(
                                      fontSize: 20,
                                      height: 1.4,
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFF3D3128),
                                    ),
                                  ),
                                  SizedBox(height: 14),
                                  Text(
                                    'CICERO',
                                    style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: 12,
                                      color: Color(0xFF76665D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: -10,
                      bottom: -18,
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF86F2C6),
                        ),
                        child: const Icon(Icons.menu_book, color: Color(0xFF0D5C4A)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                const Text(
                  'Welcome Home',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF46413C),
                    fontFamily: 'serif',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Your personal digital sanctuary for thoughts, highlights, and literary journeys.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.6,
                      color: Color(0xFF7D746C),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const GradientButton(
                  text: 'Start Your Journal',
                  icon: Icons.arrow_forward,
                  gradient: LinearGradient(
                    colors: [Color(0xFF1B9C7A), Color(0xFF7FECBA)],
                  ),
                ),
                const SizedBox(height: 16),
                const PillButton(
                  text: 'Sign In to Vault',
                  background: Color(0xFFF0EBDD),
                  textColor: Color(0xFF534F48),
                ),
                const SizedBox(height: 34),
                Container(
                  width: 96,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7E1D1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 34),
                const Text(
                  'OR CONTINUE WITH',
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 2.2,
                    color: Color(0xFF8B847B),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const MiniLoginChip(
                      width: 138,
                      child: Text(
                        'GOOGLE',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const MiniLoginChip(
                      width: 56,
                      child: Text(
                        'iOS',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const MiniLoginChip(
                      width: 56,
                      child: Icon(Icons.email_outlined, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26),
                  child: Text.rich(
                    TextSpan(
                      text: 'By entering the sanctuary, you agree to our\n',
                      style: TextStyle(fontSize: 12, color: Color(0xFF8C847D), height: 1.5),
                      children: [
                        TextSpan(
                          text: 'Terms of Ink',
                          style: TextStyle(
                            color: Color(0xFF2BBF9B),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' and Privacy Echoes.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}