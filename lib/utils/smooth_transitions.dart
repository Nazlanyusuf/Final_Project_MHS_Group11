import 'package:flutter/material.dart';

class _FadeSlideTransitionsBuilder extends PageTransitionsBuilder {
  const _FadeSlideTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final fadeCurve = CurvedAnimation(parent: animation, curve: Curves.easeOut);
    final slideCurve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: fadeCurve,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.035),
          end: Offset.zero,
        ).animate(slideCurve),
        child: child,
      ),
    );
  }
}

const smoothPageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: _FadeSlideTransitionsBuilder(),
    TargetPlatform.iOS: _FadeSlideTransitionsBuilder(),
    TargetPlatform.windows: _FadeSlideTransitionsBuilder(),
    TargetPlatform.macOS: _FadeSlideTransitionsBuilder(),
    TargetPlatform.linux: _FadeSlideTransitionsBuilder(),
  },
);
