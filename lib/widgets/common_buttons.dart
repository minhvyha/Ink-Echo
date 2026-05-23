// Reusable CTA styles for reflection and login screens.

import 'package:flutter/material.dart';

/// Primary action with gradient fill and icon (e.g. Save reflection).
class GradientButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  const GradientButton({
    super.key,
    required this.text,
    required this.icon,
    required this.gradient,
    this.onPressed,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: semanticLabel ?? text,
      child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          height: 60,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B9C7A).withOpacity(0.22),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(icon, color: Colors.white, size: 22),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}

/// Outlined pill for secondary actions (e.g. mood chips).
class PillButton extends StatelessWidget {
  final String text;
  final Color background;
  final Color textColor;

  const PillButton({
    super.key,
    required this.text,
    required this.background,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// Compact toggle on login (Sign in / Sign up mode).
class MiniLoginChip extends StatelessWidget {
  final double width;
  final Widget child;

  const MiniLoginChip({
    super.key,
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2E7),
        borderRadius: BorderRadius.circular(22),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}