import 'package:flutter/material.dart';
import 'package:inkandecho/models/book.dart';

String formatBookDate(DateTime? date) {
  if (date == null) return 'Recently';
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}';
}

String estimateReadLabel(Book book) {
  final words = '${book.echo} ${book.transcription ?? ''}'
      .trim()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .length;
  final minutes = (words / 200).ceil().clamp(1, 99);
  return '$minutes min read';
}

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
