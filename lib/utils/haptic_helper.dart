import 'package:flutter/services.dart';

class HapticHelper {
  // Button press
  static void light() => HapticFeedback.lightImpact();

  // Add to cart, important actions
  static void medium() => HapticFeedback.mediumImpact();

  // Success, order placed
  static void heavy() => HapticFeedback.heavyImpact();

  // Error
  static void error() => HapticFeedback.vibrate();

  // Selection change
  static void selection() => HapticFeedback.selectionClick();
}