import 'package:flutter/material.dart';

class NeumorphicColors {
  static const Color background = Color(0xFFE0E5EC);
  static const Color lightShadow = Color(0xFFFFFFFF);
  static const Color darkShadow = Color(0xFFA3B1C6);
  static const Color text = Color(0xFF52575D);
}

// Standard 3D Elevated Look
BoxDecoration neumorphicDecoration({double borderRadius = 12}) {
  return BoxDecoration(
    color: NeumorphicColors.background,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: const [
      BoxShadow(
        color: NeumorphicColors.lightShadow,
        offset: Offset(-5, -5),
        blurRadius: 15,
      ),
      BoxShadow(
        color: NeumorphicColors.darkShadow,
        offset: Offset(5, 5),
        blurRadius: 15,
      ),
    ],
  );
}

// Inset/Pressed Look (Good for clicked buttons)
BoxDecoration neumorphicInsetDecoration({double borderRadius = 12}) {
  return BoxDecoration(
    color: NeumorphicColors.background,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: NeumorphicColors.darkShadow.withValues(alpha: 0.5),
        offset: const Offset(2, 2),
        blurRadius: 2,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: NeumorphicColors.lightShadow.withValues(alpha: 0.5),
        offset: const Offset(-2, -2),
        blurRadius: 2,
        spreadRadius: 1,
      ),
    ],
  );
}
