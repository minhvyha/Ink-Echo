// Read-only vault entry view with edit and delete actions.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inkandecho/models/book.dart';
import 'package:inkandecho/pages/reflection_page.dart';
import 'package:inkandecho/services/book_service.dart';
import 'package:inkandecho/theme/ink_echo_palette.dart';
import 'package:inkandecho/theme/ink_echo_theme.dart';
import 'package:inkandecho/utils/book_format.dart';
import 'package:inkandecho/utils/a11y_announce.dart';
import 'package:inkandecho/utils/user_errors.dart';
import 'package:inkandecho/widgets/ink_echo_brand.dart';
import 'package:inkandecho/widgets/offline_status_chip.dart';

/// Shows one [Book]; edit opens [ReflectionPage], delete calls [BookService.deleteBook].
class BookDetailPage extends StatefulWidget {
  final Book book;
  final BookService? bookService;

  const BookDetailPage({
    super.key,
    required this.book,
    this.bookService,
  });

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool _deleting = false;

  Book get book => widget.book;
  BookService get _bookService => widget.bookService ?? BookService.instance;

  /// Pushes [ReflectionPage]; pops detail when save succeeds.
  Future<void> _openEdit() async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (ctx) => ReflectionPage(
          book: book,
          bookService: widget.bookService,
          onBookSaved: () => Navigator.of(ctx).pop(true),
        ),
      ),
    );
    if (updated == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  /// Confirms, deletes from Firestore, then pops back to vault.
  Future<void> _confirmDelete() async {
    final scheme = Theme.of(context).colorScheme;
    final title = book.title.isEmpty ? 'this entry' : book.title;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete entry?'),
        content: Text(
          'Remove "$title" from your vault? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: scheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await _bookService.deleteBook(book.id);
      if (!mounted) return;
      const deletedMessage = 'Entry deleted.';
      showTrustSuccessSnackBar(context, deletedMessage);
      announceForAccessibility(context, deletedMessage);
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      final parsed = UserFacingError.from(e);
      showTrustErrorSnackBar(
        context,
        e,
        onRetry: _confirmDelete,
        offlineNote: parsed.isOffline ? kOfflineDeleteNote : null,
      );
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
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

  @override
  Widget build(BuildContext context) {
    final coverBytes = _coverBytes();
    final hasEcho = book.echo.trim().isNotEmpty;
    final hasTranscription =
        book.transcription != null && book.transcription!.trim().isNotEmpty;
    final palette = context.inkPalette;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: context.inkPrimaryText),
                    tooltip: 'Back to vault',
                    onPressed: _deleting ? null : () => Navigator.of(context).pop(),
                  ),
                  const Expanded(child: Center(child: InkEchoBrand())),
                  const OfflineStatusChip(),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
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
                      label: 'Added',
                      value: formatBookDateLong(book.createdAt),
                    ),
                    if (book.updatedAt != null) ...[
                      const SizedBox(height: 8),
                      _MetaRow(
                        label: 'Last updated',
                        value: formatBookDateLong(book.updatedAt),
                      ),
                    ],
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
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: Semantics(
                            button: true,
                            label: 'Edit this entry',
                            enabled: !_deleting,
                            child: OutlinedButton.icon(
                            onPressed: _deleting ? null : _openEdit,
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text('Edit'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: scheme.primary,
                              side: BorderSide(color: scheme.primary),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Semantics(
                            button: true,
                            label: 'Delete this entry',
                            enabled: !_deleting,
                            child: FilledButton.icon(
                            onPressed: _deleting ? null : _confirmDelete,
                            icon: _deleting
                                ? SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: scheme.onError,
                                    ),
                                  )
                                : const Icon(Icons.delete_outline),
                            label: Text(_deleting ? 'Deleting…' : 'Delete'),
                            style: FilledButton.styleFrom(
                              backgroundColor: scheme.error,
                              foregroundColor: scheme.onError,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
