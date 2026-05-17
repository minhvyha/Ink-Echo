import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inkandecho/models/book.dart';
import 'package:inkandecho/utils/book_format.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final coverBytes = _coverBytes();
    final hasEcho = book.echo.trim().isNotEmpty;
    final hasTranscription =
        book.transcription != null && book.transcription!.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFfffbff),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF4A4742)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Ink & Echo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF2BBF9B),
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (book.mood != null && book.mood!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0EBDD),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          book.mood!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: Color(0xFF6D645C),
                          ),
                        ),
                      ),
                    if (book.mood != null && book.mood!.isNotEmpty)
                      const SizedBox(height: 14),
                    Text(
                      book.title.isEmpty ? 'Untitled' : book.title,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF39382F),
                        fontFamily: 'serif',
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 20,
                          color: Color(0xFF8F877D),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            book.author.isEmpty
                                ? 'Unknown author'
                                : book.author,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF66655A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    if (hasEcho) ...[
                      _QuoteCard(text: book.echo),
                      const SizedBox(height: 18),
                    ],
                    if (hasTranscription) ...[
                      _TranscriptionCard(text: book.transcription!),
                      const SizedBox(height: 18),
                    ],
                    if (coverBytes != null) ...[
                      const Text(
                        'COVER',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.3,
                          color: Color(0xFFA39A8F),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.memory(
                          coverBytes,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                    _MetaRow(
                      label: 'Saved',
                      value: formatBookDate(book.createdAt),
                    ),
                    const SizedBox(height: 8),
                    _MetaRow(
                      label: 'Reading time',
                      value: estimateReadLabel(book),
                    ),
                    if (!hasEcho &&
                        !hasTranscription &&
                        coverBytes == null) ...[
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F2EC),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'No reflections or media were added for this entry.',
                          style: TextStyle(
                            color: Color(0xFF5A6B62),
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Uint8List? _coverBytes() {
    final b64 = book.coverImageBase64;
    if (b64 == null || b64.isEmpty) return null;
    try {
      return base64Decode(b64);
    } catch (_) {
      return null;
    }
  }
}

class _QuoteCard extends StatelessWidget {
  final String text;

  const _QuoteCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2E7),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE7E0D1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'THE ECHO',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Color(0xFFA39A8F),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '“$text”',
            style: const TextStyle(
              fontSize: 20,
              height: 1.45,
              fontStyle: FontStyle.italic,
              color: Color(0xFF39382F),
              fontFamily: 'serif',
            ),
          ),
        ],
      ),
    );
  }
}

class _TranscriptionCard extends StatelessWidget {
  final String text;

  const _TranscriptionCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDEAE4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7C3B9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4C7B6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mic, color: Color(0xFF8B4D3B)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'VOICE TRANSCRIPTION',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: Color(0xFF8B4D3B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF4D433D),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8D847B),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF47413C),
          ),
        ),
      ],
    );
  }
}
