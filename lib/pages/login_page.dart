import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfffbff),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.menu_book, color: Color(0xFF3EB489), size: 28),
                    SizedBox(width: 8),
                    Text(
                      'Ink & Echo',
                      style: TextStyle(
                        color: Color(0xFF3EB489),
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 360,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F3EA),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(15, 57, 56, 47),
                                blurRadius: 32,
                                offset: Offset(0, 24),
                              ),
                            ],
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCZtRjN2vfMJxIzWgteS0h1Vop90OXWs8oIt3jF3obODPKHSHKDHC1ZuMSmyjrNZad0B8vQi4NyJnhp-4O65S6lBlppft4c-Ab3mp1E1jyF4seqI_GPHJAmEneF4RzOigkkA3xA-fXUTr3flZrzdQIsDPVq2Z7SILbGnfcRcojsYS1wB1w7WGo7sCbUtkgekfJ-HEYLtcr24M80thobnc9Y9PTiXT6_rxfwkJTKLsva31rZ4IUbtSdXwkAFCA5dMas0HEjwD9tudg',
                              ),
                              fit: BoxFit.cover,
                              opacity: 0.8,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -2,
                          top: -10,
                          child: Transform.rotate(
                            angle: 0.15,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDBCF),
                                borderRadius: BorderRadius.circular(999),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(18, 57, 56, 47),
                                    blurRadius: 18,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'New Chapter',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF7A432F),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFfffbff).withOpacity(0.45),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.25),
                              ),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '"A room without books is like a body without a soul."',
                                  style: TextStyle(
                                    fontSize: 18,
                                    height: 1.5,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFF39382F),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'CICERO',
                                  style: TextStyle(
                                    fontSize: 11,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF66655A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: -8,
                          bottom: -16,
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF86f8c8),
                            ),
                            child: const Icon(
                              Icons.auto_stories,
                              color: Color(0xFF004933),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Welcome Home',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF39382F),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Your personal digital sanctuary for thoughts, highlights, and literary journeys.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Color(0xFF66655A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: () async {
  try {
    await AuthService().signInWithGoogle();
  } catch (e) {
    debugPrint(e.toString());
  }
},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007352),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          elevation: 8,
                          shadowColor: const Color(0x22007352),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Start Your Journal',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: OutlinedButton(
                        onPressed: () async {
                          try {
                            await AuthService().signInWithGoogle();
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFF1EEE2),
                          foregroundColor: const Color(0xFF39382F),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: const Text(
                          'Sign In to Vault',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      width: 96,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6E3D3),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Or continue with',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 2,
                        color: Color(0xFF66655A),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _QuickAuthButton(
                          icon: Icons.g_mobiledata,
                          onTap: () async {
                            try {
                              await AuthService().signInWithGoogle();
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        _QuickAuthButton(
                          icon: Icons.apple,
                          onTap: () async {
                            try {
                              await AuthService().signInWithGoogle();
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        _QuickAuthButton(
                          icon: Icons.email_outlined,
                          onTap: () async {
                            try {
                              await AuthService().signInWithGoogle();
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'By entering the sanctuary, you agree to our Terms of Ink and Privacy Echoes.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: Color(0xFF66655A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAuthButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAuthButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F3EA),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(14, 57, 56, 47),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF39382F)),
      ),
    );
  }
}