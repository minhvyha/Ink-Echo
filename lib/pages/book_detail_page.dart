import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inkandecho/models/book.dart';
import 'package:inkandecho/theme/ink_echo_palette.dart';
import 'package:inkandecho/theme/ink_echo_theme.dart';
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
    final palette = context.inkPalette;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: context.inkPrimaryText),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Ink & Echo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.inkAccent,
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
                          color: context.inkSurface,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          book.mood!.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: context.inkMuted,
                          ),
                        ),
                      ),
                    if (book.mood != null && book.mood!.isNotEmpty)
                      const SizedBox(height: 14),
                    Text(
                      book.title.isEmpty ? 'Untitled' : book.title,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: context.inkPrimaryText,
                        fontFamily: 'serif',
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 20, color: context.inkMuted),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            book.author.isEmpty
                                ? 'Unknown author'
                                : book.author,
                            style: TextStyle(
                              fontSize: 16,
                              color: context.inkMuted,
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
                      Text(
                        'COVER',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.3,
                          color: context.inkMuted,
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
                          color: palette.emptyNotice,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'No reflections or media were added for this entry.',
                          style: TextStyle(
                            color: context.inkMuted,
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
        color: context.inkSurface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: context.inkPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'THE ECHO',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: context.inkMuted,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '“$text”',
            style: TextStyle(
              fontSize: 20,
              height: 1.45,
              fontStyle: FontStyle.italic,
              color: context.inkPrimaryText,
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
    final palette = context.inkPalette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.transcriptionCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.transcriptionBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: palette.actionPeachBorder,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.mic, color: palette.actionPeachIcon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'VOICE TRANSCRIPTION',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: palette.actionPeachIcon,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: context.inkPrimaryText,
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
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: context.inkMuted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: context.inkPrimaryText,
          ),
        ),
      ],
    );
  }
}
