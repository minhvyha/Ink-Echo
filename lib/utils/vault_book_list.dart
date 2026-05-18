import 'package:inkandecho/models/book.dart';

enum VaultSortOrder {
  newest,
  oldest,
  title,
}

List<Book> filterVaultBooks(List<Book> books, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return books;

  return books.where((book) {
    final haystack = [
      book.title,
      book.author,
      book.echo,
      book.mood ?? '',
      book.transcription ?? '',
    ].join(' ').toLowerCase();
    return haystack.contains(q);
  }).toList();
}

List<Book> sortVaultBooks(List<Book> books, VaultSortOrder order) {
  final sorted = List<Book>.from(books);
  switch (order) {
    case VaultSortOrder.newest:
      sorted.sort((a, b) {
        final ad = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bd = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bd.compareTo(ad);
      });
    case VaultSortOrder.oldest:
      sorted.sort((a, b) {
        final ad = a.createdAt ?? DateTime.now();
        final bd = b.createdAt ?? DateTime.now();
        return ad.compareTo(bd);
      });
    case VaultSortOrder.title:
      sorted.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
  }
  return sorted;
}
