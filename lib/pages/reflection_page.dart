import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/common_buttons.dart';

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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: GradientButton(
              text: 'Preserve Reflection',
              icon: Icons.arrow_forward,
              gradient: LinearGradient(
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