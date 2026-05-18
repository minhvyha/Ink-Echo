import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inkandecho/models/book.dart';
import 'package:inkandecho/theme/ink_echo_theme.dart';
import 'package:inkandecho/theme/ink_echo_tokens.dart';
import 'package:inkandecho/theme/ink_echo_typography.dart';
import 'package:inkandecho/utils/book_format.dart';

class VaultFeaturedCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const VaultFeaturedCard({
    super.key,
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: context.vaultCardDecoration,
        padding: const EdgeInsets.all(InkEchoTokens.gap),
        child: wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _Cover(book: book, aspectRatio: 4 / 3)),
                  const SizedBox(width: InkEchoTokens.gap),
                  Expanded(child: _Body(book: book, usePrimaryDate: true)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Cover(book: book, aspectRatio: 4 / 3),
                  const SizedBox(height: InkEchoTokens.gap),
                  _Body(book: book, usePrimaryDate: true),
                ],
              ),
      ),
    );
  }
}

class VaultEntryCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  final bool squareImage;
  final bool useSecondaryDate;

  const VaultEntryCard({
    super.key,
    required this.book,
    required this.onTap,
    this.squareImage = true,
    this.useSecondaryDate = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: context.vaultCardDecoration,
        padding: const EdgeInsets.all(InkEchoTokens.gap),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Cover(
              book: book,
              aspectRatio: squareImage ? 1 : 4 / 5,
              showBadge: true,
            ),
            const SizedBox(height: InkEchoTokens.gap),
            _Body(
              book: book,
              usePrimaryDate: !useSecondaryDate,
              compact: true,
            ),
          ],
        ),
      ),
    );
  }
}

class VaultNewEntryCard extends StatelessWidget {
  final VoidCallback onWrite;

  const VaultNewEntryCard({super.key, required this.onWrite});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(InkEchoTokens.gap),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(InkEchoTokens.radiusMd),
        border: Border.all(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.edit_note,
              color: scheme.onPrimaryContainer,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Start a New Entry',
            textAlign: TextAlign.center,
            style: context.vaultHeadline,
          ),
          const SizedBox(height: 8),
          Text(
            'Capture a fleeting thought or an evening reflection.',
            textAlign: TextAlign.center,
            style: context.vaultBodyLg,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: onWrite,
            child: const Text('Write Now'),
          ),
        ],
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  final Book book;
  final double aspectRatio;
  final bool showBadge;

  const _Cover({
    required this.book,
    required this.aspectRatio,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bytes = _coverBytes(book);

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(InkEchoTokens.radiusMd),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (bytes != null)
              Image.memory(bytes, fit: BoxFit.cover)
            else
              Container(
                color: scheme.surfaceContainer,
                child: Icon(
                  Icons.auto_stories_outlined,
                  size: 48,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                ),
              ),
            if (showBadge) Positioned(top: 12, right: 12, child: _MediaBadges(book: book)),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final Book book;
  final bool usePrimaryDate;
  final bool compact;

  const _Body({
    required this.book,
    required this.usePrimaryDate,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dateColor = usePrimaryDate ? scheme.primary : scheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              formatBookDateLabel(book.createdAt),
              style: context.vaultLabelSm.copyWith(color: dateColor),
            ),
            const SizedBox(width: 8),
            if (!compact) _MediaBadges(book: book),
          ],
        ),
        if (compact) ...[
          const SizedBox(height: 4),
          _MediaBadges(book: book),
        ],
        if (book.title.isNotEmpty) ...[
          SizedBox(height: compact ? 8 : 12),
          Text(
            book.title,
            style: context.vaultHeadline,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 8),
        Text(
          '"${quoteForBook(book)}"',
          style: context.vaultQuote,
          maxLines: compact ? 4 : 6,
          overflow: TextOverflow.ellipsis,
        ),
        if (!compact) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in tagsForBook(book)) _TagChip(label: tag),
            ],
          ),
        ],
      ],
    );
  }
}

class _MediaBadges extends StatelessWidget {
  final Book book;

  const _MediaBadges({required this.book});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasVoice =
        book.transcription != null && book.transcription!.isNotEmpty;
    final hasPhoto =
        book.coverImageBase64 != null && book.coverImageBase64!.isNotEmpty;

    if (!hasVoice && !hasPhoto) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasVoice)
          _Badge(
            icon: Icons.mic,
            background: scheme.primaryContainer,
            foreground: scheme.onPrimaryContainer,
          ),
        if (hasVoice && hasPhoto) const SizedBox(width: 4),
        if (hasPhoto)
          _Badge(
            icon: Icons.photo_library_outlined,
            background: scheme.secondaryContainer,
            foreground: scheme.onSecondaryContainer,
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color foreground;

  const _Badge({
    required this.icon,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 14, color: foreground),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: context.vaultLabelSm.copyWith(
          color: scheme.onSurfaceVariant,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
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
