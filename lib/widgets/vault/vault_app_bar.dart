import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:inkandecho/theme/ink_echo_typography.dart';
import '../ink_echo_brand.dart';

class VaultAppBar extends StatelessWidget {
  /// Height of the bar content below the system status / notch inset.
  static const double toolbarHeight = 64;

  final bool searchActive;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback onMenuTap;
  final VoidCallback onSearchTap;
  final VoidCallback onSearchClose;
  final ValueChanged<String> onSearchChanged;

  /// Total height including [MediaQuery.viewPadding] top (notch, status bar).
  static double totalHeight(BuildContext context) =>
      MediaQuery.viewPaddingOf(context).top + toolbarHeight;

  const VaultAppBar({
    super.key,
    required this.searchActive,
    required this.searchController,
    required this.searchFocusNode,
    required this.onMenuTap,
    required this.onSearchTap,
    required this.onSearchClose,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final topInset = MediaQuery.viewPaddingOf(context).top;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: topInset + toolbarHeight,
          padding: EdgeInsets.only(top: topInset, left: 8, right: 8),
          decoration: BoxDecoration(
            color: scheme.surface.withValues(alpha: 0.82),
          ),
          child: searchActive ? _buildSearchRow(context) : _buildDefaultRow(context),
        ),
      ),
    );
  }

  Widget _buildDefaultRow(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        IconButton(
          onPressed: onMenuTap,
          icon: Icon(Icons.menu, color: scheme.onSurfaceVariant),
          tooltip: 'Menu',
          style: IconButton.styleFrom(shape: const CircleBorder()),
        ),
        const Expanded(child: Center(child: InkEchoBrand())),
        IconButton(
          onPressed: onSearchTap,
          icon: Icon(Icons.search, color: scheme.onSurfaceVariant),
          tooltip: 'Search',
          style: IconButton.styleFrom(shape: const CircleBorder()),
        ),
      ],
    );
  }

  Widget _buildSearchRow(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        IconButton(
          onPressed: onSearchClose,
          icon: Icon(Icons.arrow_back, color: scheme.onSurfaceVariant),
          tooltip: 'Close search',
          style: IconButton.styleFrom(shape: const CircleBorder()),
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: searchController,
            builder: (context, _) {
              return TextField(
                controller: searchController,
                focusNode: searchFocusNode,
                autofocus: true,
                onChanged: onSearchChanged,
                style: context.vaultLabelMd.copyWith(color: scheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search title, author, mood…',
                  hintStyle: context.vaultLabelMd.copyWith(
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                  isDense: true,
                  filled: true,
                  fillColor:
                      scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  suffixIcon: searchController.text.isEmpty
                      ? null
                      : IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 20,
                            color: scheme.onSurfaceVariant,
                          ),
                          onPressed: () {
                            searchController.clear();
                            onSearchChanged('');
                          },
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
