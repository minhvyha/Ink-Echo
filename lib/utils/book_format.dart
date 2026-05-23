// Display helpers for vault cards and detail (dates, quotes, tags, palettes).

import 'package:flutter/material.dart';
import 'package:inkandecho/models/book.dart';

/// Short date label for cards, e.g. "May 17".
String formatBookDate(DateTime? date) {
  if (date == null) return 'Recently';
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}';
}

/// Uppercase variant for card metadata chips.
String formatBookDateLabel(DateTime? date) =>
    formatBookDate(date).toUpperCase();

/// Longer date for detail metadata, e.g. "May 17, 2025".
String formatBookDateLong(DateTime? date) {
  if (date == null) return 'Recently';
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

/// Primary quote: echo text, else transcription, else placeholder.
String quoteForBook(Book book) {
  final echo = book.echo.trim();
  if (echo.isNotEmpty) return echo;
  final transcription = book.transcription?.trim();
  if (transcription != null && transcription.isNotEmpty) return transcription;
  return 'A quiet moment waiting to be remembered.';
}

/// Chips shown on bento cards (mood, voice note, photo, etc.).
List<String> tagsForBook(Book book) {
  final tags = <String>[];
  if (book.mood != null && book.mood!.isNotEmpty) {
    tags.add(book.mood!);
  }
  if (book.transcription != null && book.transcription!.isNotEmpty) {
    tags.add('Voice note');
  }
  if (book.coverImageBase64 != null && book.coverImageBase64!.isNotEmpty) {
    tags.add('Photo');
  }
  if (book.echo.isNotEmpty) tags.add('Reflections');
  if (tags.isEmpty) tags.add('Journal');
  return tags.take(3).toList();
}

/// Rough reading time from word count (200 wpm).
String estimateReadLabel(Book book) {
  final words = '${book.echo} ${book.transcription ?? ''}'
      .trim()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .length;
  final minutes = (words / 200).ceil().clamp(1, 99);
  return '$minutes min read';
}

/// Stable accent colors per book id for card variety in light/dark mode.
(Color bg, Color accent) bookCardPalette(String id, Brightness brightness) {
  final palettes = [
    (const Color(0xFFF0EBDD), const Color(0xFFB5E5E0)),
    (const Color(0xFFDFF2D7), const Color(0xFF355745)),
    (const Color(0xFFF3D5A8), const Color(0xFFC88D52)),
    (const Color(0xFFDCEFF7), const Color(0xFF7CD6E6)),
    (const Color(0xFFF7E8E0), const Color(0xFFE8A598)),
    (const Color(0xFFE8E0F7), const Color(0xFF9B8FD9)),
  ];
  final i = id.hashCode.abs() % palettes.length;
  final pair = palettes[i];
  if (brightness == Brightness.light) return pair;
  return (
    Color.lerp(pair.$1, const Color(0xFF252522), 0.55)!,
    Color.lerp(pair.$2, const Color(0xFF2BBF9B), 0.3)!,
  );
}
