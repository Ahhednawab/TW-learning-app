import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Lightweight responsive utilities leveraging GetX.
class Responsive {
  Responsive._();

  /// Tablet heuristic based on shortestSide.
  static bool isTablet(BuildContext context) {
    final shortest = MediaQuery.of(context).size.shortestSide;
    return shortest >= 600; // common Material breakpoint
  }

  /// Width percentage of the screen (0..1).
  static double wp(double fraction) => Get.width * fraction;

  /// Height percentage of the screen (0..1).
  static double hp(double fraction) => Get.height * fraction;

  /// Scale font size using current TextScaler from MediaQuery and add a
  /// subtle bump for tablets to improve readability.
  static double sp(BuildContext context, double fontSize) {
    final scaled = MediaQuery.of(context).textScaler.scale(fontSize);
    return isTablet(context) ? scaled * 1.05 : scaled;
  }

  /// Constrain a dimension between min and max values.
  static double clamp(double value, {double? min, double? max}) {
    double v = value;
    if (min != null) v = v < min ? min : v;
    if (max != null) v = v > max ? max : v;
    return v;
  }
}
