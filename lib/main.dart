import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // generated in next step

  void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const InkEchoApp());
}


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

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _pages = const [
    HomePage(),
    VaultPage(),
    ReflectionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_index]),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.menu_book_outlined,
            label: 'Vault',
            selected: _index == 0,
            onTap: () => setState(() => _index = 0),
          ),
          _CenterAddButton(
            selected: _index == 2,
            onTap: () => setState(() => _index = 2),
          ),
          _NavItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            selected: _index == 2,
            onTap: () => setState(() => _index = 2),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF2BBF9B) : Colors.grey;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 0.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterAddButton extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _CenterAddButton({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF26B58C), Color(0xFF8BECC3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF26B58C).withOpacity(0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

class AppHeader extends StatelessWidget {
  final bool showSearch;
  final bool showClose;
  const AppHeader({super.key, this.showSearch = false, this.showClose = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.menu_book, color: Color(0xFF2BBF9B), size: 28),
          const SizedBox(width: 8),
          const Text(
            'Ink & Echo',
            style: TextStyle(
              color: Color(0xFF2BBF9B),
              fontSize: 24,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (showSearch)
            const Icon(Icons.search, color: Color(0xFF4A4742), size: 26)
          else if (showClose)
            const Icon(Icons.close, color: Color(0xFF4A4742), size: 26),
        ],
      ),
    );
  }
}

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
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(34),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF9B6B43).withOpacity(0.42),
                                      const Color(0xFFF8E2B5).withOpacity(0.18),
                                      const Color(0xFF4A2E1E).withOpacity(0.45),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                _GradientButton(
                  text: 'Start Your Journal',
                  icon: Icons.arrow_forward,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B9C7A), Color(0xFF7FECBA)],
                  ),
                ),
                const SizedBox(height: 16),
                _PillButton(
                  text: 'Sign In to Vault',
                  background: const Color(0xFFF0EBDD),
                  textColor: const Color(0xFF534F48),
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
                    _MiniLoginChip(
                      width: 138,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'GOOGLE',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, letterSpacing: 1.2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    const _MiniLoginChip(
                      width: 56,
                      child: Text(
                        'iOS',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const _MiniLoginChip(
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

class VaultPage extends StatelessWidget {
  const VaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppHeader(showSearch: true),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR SANCTUARY',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.5,
                    color: Color(0xFF8F877D),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'The Vault',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF46413C),
                    fontFamily: 'serif',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    background: const Color(0xFFF7F2E7),
                    icon: Icons.menu_book_outlined,
                    title: '42',
                    subtitle: 'ENTRIES COLLECTED',
                    iconColor: const Color(0xFF007D64),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _StatCard(
                    background: const Color(0xFFF9D5C9),
                    icon: Icons.calendar_month_outlined,
                    title: '12',
                    subtitle: 'DAILY STREAK',
                    iconColor: const Color(0xFF9C5D49),
                    compact: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (context, index) {
                return _JournalCard(index: index);
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final Color background;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final bool compact;

  const _StatCard({
    required this.background,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: compact ? 26 : 30),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4C4540),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.8,
                  color: Color(0xFF6D645C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _JournalCard extends StatelessWidget {
  final int index;
  const _JournalCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final palettes = [
      (const Color(0xFFF0EBDD), const Color(0xFFB5E5E0), 'The Quiet Room', 'Oct 24 • 3 min read'),
      (const Color(0xFFDFF2D7), const Color(0xFF355745), 'Secret Flora', 'Oct 22 • 5 min read'),
      (const Color(0xFFF3D5A8), const Color(0xFFC88D52), 'Morning Echoes', 'Oct 19 • 2 min read'),
      (const Color(0xFFDCEFF7), const Color(0xFF7CD6E6), 'Stellar Ink', 'Oct 15 • 8 min read'),
    ];
    final item = palettes[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: item.$1,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 18,
                left: 18,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: item.$2, width: 4),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 102,
                  height: 130,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [item.$2.withOpacity(0.22), item.$2.withOpacity(0.62)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.42),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Text(
                    '“A small quote placeholder that echoes the journal tone.”',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF4D433D),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          item.$3,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF47413C),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.$4,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF8D847B),
          ),
        ),
      ],
    );
  }
}

class ReflectionPage extends StatelessWidget {
  const ReflectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppHeader(showClose: true),
          const SizedBox(height: 6),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              children: [
                Text(
                  'New Reflection',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF46413C),
                    fontFamily: 'serif',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Capture a moment from your latest read.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF7E756D),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: const [
                Expanded(
                  child: _ActionCard(
                    label: 'SNAP A PHOTO',
                    icon: Icons.camera_alt_outlined,
                    background: Color(0xFFD8FAEF),
                    borderColor: Color(0xFF9FDCC8),
                    iconBackground: Color(0xFF8CEFD1),
                    textColor: Color(0xFF0F6A57),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: _ActionCard(
                    label: 'RECORD A THOUGHT',
                    icon: Icons.mic_none,
                    background: Color(0xFFFDEAE4),
                    borderColor: Color(0xFFE7C3B9),
                    iconBackground: Color(0xFFF4C7B6),
                    textColor: Color(0xFF8B4D3B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const _FieldLabel('THE VOLUME'),
          const _TextFieldMock(hint: 'What are you reading?', icon: Icons.menu_book_outlined),
          const SizedBox(height: 18),
          const _FieldLabel('THE VOICE'),
          const _TextFieldMock(hint: "Author's name"),
          const SizedBox(height: 18),
          const _FieldLabel('THE ECHO'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Container(
              height: 190,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F1E5),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFE7E0D1)),
              ),
              child: Stack(
                children: [
                  const Text(
                    '“Words that stayed with you...”',
                    style: TextStyle(
                      color: Color(0xFFC2B7A8),
                      fontSize: 22,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5D6CA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '★ FAVORITE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF8C5341),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          const _FieldLabel('THE MOOD'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _MoodChip(text: 'Inspiring', selected: false),
                _MoodChip(text: 'Deeply Moving', selected: true),
                _MoodChip(text: 'Challenging', selected: false),
                _MoodChip(text: 'Nostalgic', selected: false),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFD6E8DE),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0xFFB1D4C2)),
              ),
              child: Center(
                child: Container(
                  width: 150,
                  height: 210,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F2E8),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      'Upload Cover Art',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF7C756E),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: _GradientButton(
              text: 'Preserve Reflection',
              icon: Icons.arrow_forward,
              gradient: const LinearGradient(
                colors: [Color(0xFF1B9C7A), Color(0xFF7FECBA)],
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.3,
          color: Color(0xFFA39A8F),
        ),
      ),
    );
  }
}

class _TextFieldMock extends StatelessWidget {
  final String hint;
  final IconData? icon;
  const _TextFieldMock({required this.hint, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F1E5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hint,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFFC0B5A5),
                ),
              ),
            ),
            if (icon != null)
              Icon(icon, color: const Color(0xFFBFB4A6), size: 22),
          ],
        ),
      ),
    );
  }
}

class _MoodChip extends StatelessWidget {
  final String text;
  final bool selected;
  const _MoodChip({required this.text, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF85EFC1) : const Color(0xFFF0EBDD),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: selected ? const Color(0xFF0D5C4A) : const Color(0xFF5A544E),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final Color borderColor;
  final Color iconBackground;
  final Color textColor;

  const _ActionCard({
    required this.label,
    required this.icon,
    required this.background,
    required this.borderColor,
    required this.iconBackground,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: textColor, size: 26),
          ),
          const SizedBox(height: 14),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: textColor,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final LinearGradient gradient;

  const _GradientButton({
    required this.text,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B9C7A).withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 10),
            Icon(icon, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String text;
  final Color background;
  final Color textColor;

  const _PillButton({
    required this.text,
    required this.background,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _MiniLoginChip extends StatelessWidget {
  final double width;
  final Widget child;
  const _MiniLoginChip({required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2E7),
        borderRadius: BorderRadius.circular(22),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
