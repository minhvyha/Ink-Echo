import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/common_buttons.dart';
import '../services/book_service.dart';

class ReflectionPage extends StatefulWidget {
  final VoidCallback? onBookSaved;

  const ReflectionPage({super.key, this.onBookSaved});

  @override
  State<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _echo = TextEditingController();
  String? _mood;
  bool _saving = false;

  static const _moods = [
    'Inspiring',
    'Deeply Moving',
    'Challenging',
    'Nostalgic',
  ];

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _echo.dispose();
    super.dispose();
  }

  Future<void> _saveBook() async {
    if (_saving) return;
    final title = _title.text.trim();
    final author = _author.text.trim();
    if (title.isEmpty || author.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a title and author before saving.'),
        ),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await BookService.instance.saveBook(
        title: title,
        author: author,
        echo: _echo.text.trim(),
        mood: _mood,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book saved to your shelf.')),
      );
      _title.clear();
      _author.clear();
      _echo.clear();
      setState(() => _mood = null);
      widget.onBookSaved?.call();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

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
                  'Add a book',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF46413C),
                    fontFamily: 'serif',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Save a volume to your shelf — it will appear on Home.',
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
          _BookTextField(
            controller: _title,
            hint: 'Book title',
            icon: Icons.menu_book_outlined,
          ),
          const SizedBox(height: 18),
          const _FieldLabel('THE VOICE'),
          _BookTextField(
            controller: _author,
            hint: "Author's name",
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 18),
          const _FieldLabel('THE ECHO'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: TextField(
              controller: _echo,
              minLines: 4,
              maxLines: 8,
              style: const TextStyle(
                color: Color(0xFF4D433D),
                fontSize: 16,
                height: 1.4,
              ),
              decoration: InputDecoration(
                hintText: 'Words that stayed with you…',
                hintStyle: TextStyle(
                  color: const Color(0xFF4D433D).withValues(alpha: 0.45),
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
                filled: true,
                fillColor: const Color(0xFFF8F1E5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: const BorderSide(color: Color(0xFFE7E0D1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: const BorderSide(color: Color(0xFFE7E0D1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: const BorderSide(color: Color(0xFF1B9C7A), width: 1.4),
                ),
                contentPadding: const EdgeInsets.all(18),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const _FieldLabel('THE MOOD'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final m in _moods)
                  _MoodChip(
                    text: m,
                    selected: _mood == m,
                    onTap: () => setState(() {
                      _mood = _mood == m ? null : m;
                    }),
                  ),
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
            child: GradientButton(
              text: _saving ? 'Saving…' : 'Save book',
              icon: Icons.arrow_forward,
              gradient: const LinearGradient(
                colors: [Color(0xFF1B9C7A), Color(0xFF7FECBA)],
              ),
              onPressed: _saving ? null : _saveBook,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _BookTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;

  const _BookTextField({
    required this.controller,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: TextField(
        controller: controller,
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF4D433D),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 15,
            color: Color(0xFFC0B5A5),
          ),
          filled: true,
          fillColor: const Color(0xFFF8F1E5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF1B9C7A), width: 1.2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          suffixIcon: Icon(icon, color: const Color(0xFFBFB4A6), size: 22),
        ),
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

class _MoodChip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _MoodChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
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
