import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/accessibility_settings.dart';
import '../theme/ink_echo_theme.dart';
import '../widgets/ink_echo_brand.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback onLogout;

  const SettingsPage({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Signed in';
    final a11y = AccessibilitySettings.instance;

    return ListenableBuilder(
      listenable: a11y,
      builder: (context, _) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: const Center(child: InkEchoBrand()),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PREFERENCES',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.5,
                        color: context.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: context.inkPrimaryText,
                        fontFamily: 'serif',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _SettingsGroup(
                title: 'ACCESSIBILITY',
                children: [
                  _SettingsSwitchTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark mode',
                    subtitle: 'Easier on the eyes in low light',
                    value: a11y.darkMode,
                    onChanged: a11y.setDarkMode,
                  ),
                  _SettingsSliderTile(
                    icon: Icons.format_size,
                    title: 'Text size',
                    subtitle: a11y.textScaleLabel,
                    value: a11y.textScale,
                    min: 0.85,
                    max: 1.35,
                    divisions: 4,
                    label: a11y.textScaleLabel,
                    onChanged: a11y.setTextScale,
                  ),
                  _SettingsSwitchTile(
                    icon: Icons.format_bold,
                    title: 'Bold text',
                    subtitle: 'Increase text weight across the app',
                    value: a11y.boldText,
                    onChanged: a11y.setBoldText,
                  ),
                  _SettingsSwitchTile(
                    icon: Icons.contrast,
                    title: 'High contrast',
                    subtitle: 'Stronger colors for readability',
                    value: a11y.highContrast,
                    onChanged: a11y.setHighContrast,
                  ),
                  _SettingsSwitchTile(
                    icon: Icons.motion_photos_off_outlined,
                    title: 'Reduce motion',
                    subtitle: 'Limit animations and transitions',
                    value: a11y.reduceMotion,
                    onChanged: a11y.setReduceMotion,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SettingsGroup(
                title: 'ACCOUNT',
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    leading: Icon(Icons.person_outline, color: context.inkMuted),
                    title: Text(
                      email,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.inkPrimaryText,
                      ),
                    ),
                    subtitle: Text(
                      user?.providerData.isNotEmpty == true &&
                              user!.providerData.first.providerId == 'google.com'
                          ? 'Signed in with Google'
                          : 'Signed in with email',
                      style: TextStyle(color: context.inkMuted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: onLogout,
                    icon: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    label: Text(
                      'Sign out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .errorContainer
                          .withValues(alpha: 0.35),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsGroup({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: context.inkMuted,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: context.inkSurface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.6),
              ),
            ),
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      indent: 56,
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                    ),
                  children[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon, color: context.inkAccent),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: context.inkPrimaryText,
        ),
      ),
      subtitle: Text(subtitle, style: TextStyle(color: context.inkMuted)),
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class _SettingsSliderTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String label;
  final ValueChanged<double> onChanged;

  const _SettingsSliderTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: context.inkAccent),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.inkPrimaryText,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: context.inkMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: label,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
