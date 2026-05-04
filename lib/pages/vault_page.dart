import 'package:flutter/material.dart';
import '../widgets/app_header.dart';

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
              children: const [
                Expanded(
                  child: _StatCard(
                    background: Color(0xFFF7F2E7),
                    icon: Icons.menu_book_outlined,
                    title: '42',
                    subtitle: 'ENTRIES COLLECTED',
                    iconColor: Color(0xFF007D64),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: _StatCard(
                    background: Color(0xFFF9D5C9),
                    icon: Icons.calendar_month_outlined,
                    title: '12',
                    subtitle: 'DAILY STREAK',
                    iconColor: Color(0xFF9C5D49),
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