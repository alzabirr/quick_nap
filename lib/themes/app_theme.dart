import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Global ValueNotifier to hold the current dark mode status
final ValueNotifier<bool> darkModeNotifier = ValueNotifier<bool>(true);

bool get isDarkMode => darkModeNotifier.value;

Color get primary => const Color(0xFFD7494C);
Color get accent => isDarkMode 
    ? const Color(0xFFE86B6E) 
    : const Color(0xFFB83A3D);

Color get bgLight => isDarkMode ? const Color(0xFF000000) : const Color(0xFFF2F2F7);
Color get surface => isDarkMode ? const Color(0xFF121212) : const Color(0xFFFFFFFF);
Color get textDark => isDarkMode ? const Color(0xFFF5F5F7) : const Color(0xFF1C1C1E);
Color get textMid => isDarkMode ? const Color(0xFF98989D) : const Color(0xFF8E8E93);

const double cardRadius = 24.0;

// Inter helper (Apple minimalist headings)
TextStyle headingStyle({
  double fontSize = 24.0,
  Color? color,
  FontWeight fontWeight = FontWeight.w300, // Thin modern aesthetic
}) {
  return GoogleFonts.inter(
    fontSize: fontSize,
    color: color ?? textDark,
    fontWeight: fontWeight,
    letterSpacing: -0.5,
    decoration: TextDecoration.none,
  );
}

// Inter helper (Apple minimalist body)
TextStyle bodyStyle({
  double fontSize = 14.0,
  Color? color,
  FontWeight fontWeight = FontWeight.w300, // Thin/Light modern aesthetic
  double? height,
}) {
  return GoogleFonts.inter(
    fontSize: fontSize,
    color: color ?? textDark,
    fontWeight: fontWeight,
    height: height,
    letterSpacing: -0.2,
    decoration: TextDecoration.none,
  );
}
