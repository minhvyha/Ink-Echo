// Side menu: sort order, settings shortcut, add reflection.

import 'package:flutter/material.dart';
import 'package:inkandecho/theme/ink_echo_typography.dart';
import 'package:inkandecho/utils/vault_book_list.dart';
import 'package:inkandecho/widgets/ink_echo_brand.dart';

/// Opened from [VaultPage] hamburger; sort is applied client-side in vault state.
class VaultDrawer extends StatelessWidget {
  final VaultSortOrder sortOrder;
  final ValueChanged<VaultSortOrder> onSortChanged;
  final VoidCallback onOpenSettings;
  final VoidCallback onAddReflection;

  const VaultDrawer({
    super.key,
    required this.sortOrder,
    required this.onSortChanged,
    required this.onOpenSettings,
    required this.onAddReflection,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: scheme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InkEchoBrand(),
                  const SizedBox(height: 8),
                  Text(
                    'Your reading journal',
                    style: context.vaultBodyLg,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            _DrawerTile(
              icon: Icons.auto_stories_outlined,
              label: 'Vault',
              selected: true,
              onTap: () => Navigator.pop(context),
            ),
            _DrawerTile(
              icon: Icons.add_circle_outline,
              label: 'Add reflection',
              onTap: () {
                Navigator.pop(context);
                onAddReflection();
              },
            ),
            _DrawerTile(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () {
                Navigator.pop(context);
                onOpenSettings();
              },
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Text(
                'SORT ENTRIES',
                style: context.vaultLabelSm.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            _SortTile(
              label: 'Newest first',
              value: VaultSortOrder.newest,
              groupValue: sortOrder,
              onChanged: onSortChanged,
            ),
            _SortTile(
              label: 'Oldest first',
              value: VaultSortOrder.oldest,
              groupValue: sortOrder,
              onChanged: onSortChanged,
            ),
            _SortTile(
              label: 'Title A–Z',
              value: VaultSortOrder.title,
              groupValue: sortOrder,
              onChanged: onSortChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: selected ? scheme.primary : scheme.onSurfaceVariant,
      ),
      title: Text(
        label,
        style: context.vaultHeadline.copyWith(
          color: selected ? scheme.primary : scheme.onSurface,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      selected: selected,
      selectedTileColor: scheme.primaryContainer.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }
}

class _SortTile extends StatelessWidget {
  final String label;
  final VaultSortOrder value;
  final VaultSortOrder groupValue;
  final ValueChanged<VaultSortOrder> onChanged;

  const _SortTile({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = value == groupValue;

    return ListTile(
      title: Text(label, style: context.vaultLabelMd),
      trailing: selected
          ? Icon(Icons.check, color: scheme.primary, size: 22)
          : null,
      dense: true,
      visualDensity: VisualDensity.compact,
      onTap: () => onChanged(value),
    );
  }
}
