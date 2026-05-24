// Page route transitions that respect reduce-motion accessibility.

import 'package:flutter/material.dart';

/// No slide/fade — shows the new route immediately.
class InkEchoInstantPageTransitionsBuilder extends PageTransitionsBuilder {
  const InkEchoInstantPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

/// [PageTransitionsTheme] with instant builders on all platforms when motion is reduced.
PageTransitionsTheme inkEchoPageTransitions({required bool reduceMotion}) {
  if (!reduceMotion) return const PageTransitionsTheme();

  const builder = InkEchoInstantPageTransitionsBuilder();
  return const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: builder,
      TargetPlatform.iOS: builder,
      TargetPlatform.macOS: builder,
      TargetPlatform.linux: builder,
      TargetPlatform.windows: builder,
      TargetPlatform.fuchsia: builder,
    },
  );
}
