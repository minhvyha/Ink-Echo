// Screen reader announcements for important action outcomes.

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Speaks [message] with TalkBack / VoiceOver (in addition to SnackBars).
void announceForAccessibility(BuildContext context, String message) {
  final view = View.maybeOf(context);
  if (view == null) return;
  SemanticsService.sendAnnouncement(
    view,
    message,
    Directionality.of(context),
  );
}
