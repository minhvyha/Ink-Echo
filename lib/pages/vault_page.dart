import 'package:flutter/material.dart';
import 'package:inkandecho/models/book.dart';
import 'package:inkandecho/pages/book_detail_page.dart';
import 'package:inkandecho/pages/reflection_page.dart';
import 'package:inkandecho/services/book_service.dart';
import 'package:inkandecho/widgets/app_header.dart';
import 'package:inkandecho/widgets/book_journal_card.dart';

class VaultPage extends StatelessWidget {
  const VaultPage({super.key});

  void _openAdd(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReflectionPage(
          onBookSaved: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, Book book) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BookDetailPage(book: book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Book>>(
          stream: BookService.instance.watchBooks(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final books = snapshot.data ?? const <Book>[];
            final loading = snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData;

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
                            title: loading ? '—' : '${books.length}',
                            subtitle: 'ENTRIES COLLECTED',
                            iconColor: const Color(0xFF007D64),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: _StatCard(
                            background: Color(0xFFF9D5C9),
                            icon: Icons.calendar_month_outlined,
                            title: '—',
                            subtitle: 'DAILY STREAK',
                            iconColor: Color(0xFF9C5D49),
                            compact: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF007352),
                        ),
                      ),
                    )
                  else if (books.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F2EC),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.library_books_outlined,
                              size: 40,
                              color: Color(0xFF5A6B62),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Your vault is empty',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF5A6B62),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tap + to add your first book with photos, echoes, and voice notes.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.45,
                                color: Color(0xFF5A6B62),
                              ),
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: () => _openAdd(context),
                              icon: const Icon(Icons.add),
                              label: const Text('Add entry'),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF007352),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: books.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.82,
                        ),
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return BookJournalCard(
                            book: book,
                            onTap: () => _openDetail(context, book),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAdd(context),
        backgroundColor: const Color(0xFF26B58C),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
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
              color: Colors.white.withValues(alpha: 0.5),
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
