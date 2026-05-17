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

(int bg, int accent) paletteForBook(String id) {
  final palettes = [
    (0xFFF0EBDD, 0xFFB5E5E0),
    (0xFFDFF2D7, 0xFF355745),
    (0xFFF3D5A8, 0xFFC88D52),
    (0xFFDCEFF7, 0xFF7CD6E6),
    (0xFFF7E8E0, 0xFFE8A598),
    (0xFFE8E0F7, 0xFF9B8FD9),
  ];
  final i = id.hashCode.abs() % palettes.length;
  return palettes[i];
}
