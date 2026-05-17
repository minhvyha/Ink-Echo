import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inkandecho/models/book.dart';
import 'package:inkandecho/theme/ink_echo_palette.dart';
import 'package:inkandecho/theme/ink_echo_theme.dart';
import 'package:inkandecho/utils/book_format.dart';

class BookJournalCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookJournalCard({
    super.key,
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = bookCardPalette(book.id, Theme.of(context).brightness);
    final bg = palette.$1;
    final accent = palette.$2;
    final quote = book.echo.trim().isEmpty
        ? (book.transcription?.trim().isNotEmpty == true
            ? book.transcription!
            : 'No echo yet…')
        : book.echo;
    final meta =
        '${formatBookDate(book.createdAt)} • ${estimateReadLabel(book)}';

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_coverBytes(book) != null)
                    Image.memory(
                      _coverBytes(book)!,
                      fit: BoxFit.cover,
                    )
                  else
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 102,
                        height: 130,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              accent.withValues(alpha: 0.22),
                              accent.withValues(alpha: 0.62),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 18,
                    left: 18,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: accent, width: 4),
                      ),
                    ),
                  ),
                  if (book.transcription != null &&
                      book.transcription!.isNotEmpty)
                    Positioned(
                      top: 18,
                      right: 18,
                      child: Icon(Icons.mic, size: 18, color: context.inkMuted),
                    ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.inkPalette.quoteOverlay,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        '“$quote”',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: context.inkPrimaryText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            book.title.isEmpty ? 'Untitled' : book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: context.inkPrimaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            meta,
            style: TextStyle(
              fontSize: 12,
              color: context.inkMuted,
            ),
          ),
        ],
      ),
    );
  }

  Uint8List? _coverBytes(Book book) {
    final b64 = book.coverImageBase64;
    if (b64 == null || b64.isEmpty) return null;
    try {
      return base64Decode(b64);
    } catch (_) {
      return null;
    }
  }
}
