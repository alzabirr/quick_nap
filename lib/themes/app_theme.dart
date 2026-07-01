import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

/// Global ValueNotifier to hold the current dark mode status
final ValueNotifier<bool> darkModeNotifier = ValueNotifier<bool>(true);

bool get isDarkMode => darkModeNotifier.value;

// ============================================================
// Color constants for the NES retro theme
// These are used throughout the screens
// ============================================================

/// NES primary blue (was red in old theme)
Color get primary => const Color(0xff209cee);

/// NES accent/error red
Color get accent => const Color(0xffe76e55);

/// Background color (switches with dark/light mode)
Color get bgLight => isDarkMode ? const Color(0xff0d0d0d) : const Color(0xffe5e5e5);

/// Surface/card color
Color get surface => isDarkMode ? const Color(0xff212529) : const Color(0xffffffff);

/// Primary text color
Color get textDark => isDarkMode ? const Color(0xffffffff) : const Color(0xff000000);

/// Muted/secondary text color
Color get textMid => isDarkMode ? const Color(0xff808080) : const Color(0xff555555);

/// Card border radius for NES pixel style
double get cardRadius => 8.0;

/// NES button success green
Color get successColor => const Color(0xff92cc41);

/// NES button warning yellow
Color get warningColor => const Color(0xfff7d51d);

/// Creates a NES-themed ThemeData for the app.
/// Uses flutterNesTheme() from nes_ui with our custom color scheme.
ThemeData buildNesTheme({required Brightness brightness}) {
  final isDark = brightness == Brightness.dark;

  return flutterNesTheme(
    primaryColor: primary,
    brightness: brightness,
    nesTheme: const NesTheme(pixelSize: 4),
    nesButtonTheme: NesButtonTheme(
      normal: isDark ? const Color(0xff212529) : const Color(0xffffffff),
      primary: primary,
      success: successColor,
      warning: warningColor,
      error: accent,
      lightLabelColor: const Color(0xffffffff),
      darkLabelColor: const Color(0xff000000),
      lightIconTheme: const NesIconTheme(
        primary: Color(0xffffffff),
        secondary: Color(0xff000000),
        accent: Color(0xff9badb7),
        shadow: Color(0xff696a6a),
      ),
      darkIconTheme: const NesIconTheme(
        primary: Color(0xff000000),
        secondary: Color(0xffffffff),
        accent: Color(0xff696a6a),
        shadow: Color(0xff9badb7),
      ),
    ),
    nesIconTheme: isDark
        ? const NesIconTheme(
            primary: Color(0xff808080),
            secondary: Color(0xffe5e5e5),
            accent: Color(0xff696a6a),
            shadow: Color(0xff9badb7),
          )
        : const NesIconTheme(
            primary: Color(0xff000000),
            secondary: Color(0xffffffff),
            accent: Color(0xff9badb7),
            shadow: Color(0xff696a6a),
          ),
    nesContainerTheme: NesContainerTheme(
      backgroundColor: isDark ? const Color(0xff212529) : const Color(0xffffffff),
      borderColor: isDark ? const Color(0xff808080) : const Color(0xff000000),
      labelTextStyle: TextStyle(
        color: isDark ? const Color(0xffffffff) : const Color(0xff000000),
        fontSize: 12,
      ),
      padding: const EdgeInsets.all(16),
    ),
    nesSnackbarTheme: const NesSnackbarTheme(
      normal: Color(0xffffffff),
      success: Color(0xff92cc41),
      warning: Color(0xfff7d51d),
      error: Color(0xffe76e55),
    ),
  );
}

// ============================================================
// Text style helpers
// These inherit the Press Start 2P font from the theme's
// DefaultTextStyle, so no fontFamily is needed.
// ============================================================

/// NES-style heading text. Uses the global theme font (Press Start 2P).
/// Keep sizes modest — Press Start 2P renders large.
TextStyle headingStyle({
  double fontSize = 18.0,
  Color? color,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color ?? textDark,
    fontWeight: fontWeight,
    decoration: TextDecoration.none,
  );
}

/// NES-style body text.
TextStyle bodyStyle({
  double fontSize = 12.0,
  Color? color,
  FontWeight fontWeight = FontWeight.normal,
  double? height,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color ?? textDark,
    fontWeight: fontWeight,
    height: height,
    decoration: TextDecoration.none,
  );
}
