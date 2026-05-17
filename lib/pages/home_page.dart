import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inkandecho/models/book.dart';
import 'package:inkandecho/services/book_service.dart';
import 'package:inkandecho/widgets/app_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                  'YOUR SHELF',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.5,
                    color: Color(0xFF8F877D),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Home',
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
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: StreamBuilder<List<Book>>(
              stream: BookService.instance.watchBooks(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _NoticeCard(
                    icon: Icons.error_outline,
                    title: 'Could not load books',
                    body: snapshot.error.toString(),
                    tone: const Color(0xFF9C5D49),
                    background: const Color(0xFFF9D5C9),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF007352),
                      ),
                    ),
                  );
                }
                final books = snapshot.data ?? const <Book>[];
                if (books.isEmpty) {
                  return const _EmptyBooksNotice();
                }
                return Column(
                  children: [
                    for (var i = 0; i < books.length; i++) ...[
                      if (i > 0) const SizedBox(height: 14),
                      _BookCard(book: books[i]),
                    ],
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

class _EmptyBooksNotice extends StatelessWidget {
  const _EmptyBooksNotice();

  @override
  Widget build(BuildContext context) {
    return const _NoticeCard(
      icon: Icons.library_books_outlined,
      title: 'No books on your shelf yet',
      body:
          'Nothing is stored in the database yet. Tap the + button below to add your first book.',
      tone: Color(0xFF5A6B62),
      background: Color(0xFFE8F2EC),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Color tone;
  final Color background;

  const _NoticeCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.tone,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: tone.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 36, color: tone),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: tone,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              fontSize: 15,
              height: 1.45,
              color: tone.withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookCoverThumb extends StatelessWidget {
  final String? coverBase64;

  const _BookCoverThumb({this.coverBase64});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF26B58C), Color(0xFF8BECC3)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(10),
    );

    final placeholder = Container(
      width: 48,
      height: 62,
      decoration: decoration,
      child: const Icon(
        Icons.menu_book_rounded,
        color: Colors.white,
        size: 26,
      ),
    );

    final b64 = coverBase64;
    if (b64 == null || b64.isEmpty) return placeholder;

    try {
      final bytes = base64Decode(b64);
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(
          bytes,
          width: 48,
          height: 62,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => placeholder,
        ),
      );
    } catch (_) {
      return placeholder;
    }
  }
}

class _BookCard extends StatelessWidget {
  final Book book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final date = book.createdAt;
    final dateLabel = date == null
        ? 'Just added'
        : '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2E7),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BookCoverThumb(coverBase64: book.coverImageBase64),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title.isEmpty ? 'Untitled' : book.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF47413C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author.isEmpty ? 'Unknown author' : book.author,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8D847B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (book.echo.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              '“${book.echo}”',
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                fontStyle: FontStyle.italic,
                color: Color(0xFF4D433D),
              ),
            ),
          ],
          if (book.transcription != null && book.transcription!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.mic, size: 16, color: Color(0xFF8D847B)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    book.transcription!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Color(0xFF5A544E),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                dateLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8D847B),
                ),
              ),
              if (book.mood != null) ...[
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF85EFC1).withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    book.mood!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D5C4A),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
