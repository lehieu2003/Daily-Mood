import 'package:flutter/material.dart';

/// Design tokens and helpers for calm, accessibility-aware motion.
class AppMotion {
  AppMotion._();

  static const Duration none = Duration.zero;
  static const Duration reduced = Duration(milliseconds: 80);
  static const Duration fastFeedback = Duration(milliseconds: 160);
  static const Duration standardFeedback = Duration(milliseconds: 180);
  static const Duration chartReveal = Duration(milliseconds: 220);
  static const Duration saveConfirmation = Duration(milliseconds: 350);
  static const Duration gardenGrowth = Duration(milliseconds: 750);

  static const Curve standardCurve = Curves.easeOutCubic;
  static const Curve calmCurve = Curves.easeOut;
  static const Curve reducedCurve = Curves.linear;

  static bool shouldReduceMotion(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery == null) return false;

    return mediaQuery.disableAnimations || mediaQuery.accessibleNavigation;
  }

  static Duration duration(
    BuildContext context,
    Duration fullDuration, {
    Duration reducedDuration = reduced,
  }) {
    return shouldReduceMotion(context) ? reducedDuration : fullDuration;
  }

  static Curve curve(
    BuildContext context,
    Curve fullCurve, {
    Curve reducedMotionCurve = reducedCurve,
  }) {
    return shouldReduceMotion(context) ? reducedMotionCurve : fullCurve;
  }
}
