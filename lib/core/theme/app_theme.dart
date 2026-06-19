import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData dark() {
    const Color base = Color(0xFF0A0F1E); // deep navy background
    const Color panel = Color(0xFF141C33); // dark card surface
    const Color panelAlt = Color(0xFF1E2845); // lighter container background
    const Color accent = Color(0xFFFFD700); // premium gold accent
    const Color accentHot = Color(0xFF3B82F6); // bright blue highlight
    const Color textPrimary = Colors.white; // high emphasis text
    const Color textSecondary = Colors.white70; // medium emphasis text

    final TextTheme textTheme = GoogleFonts.spaceGroteskTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ).apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    );

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: base,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        surface: panel,
        surfaceContainerHighest: panelAlt,
        primary: accent,
        secondary: accentHot,
        onPrimary: base,
        onSurface: textPrimary,
        primaryContainer: panel,
        onPrimaryContainer: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: base,
        foregroundColor: textPrimary,
      ),
      cardTheme: CardThemeData(
        color: panel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: panelAlt,
        hintStyle: const TextStyle(color: textSecondary),
        labelStyle: const TextStyle(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      dividerColor: const Color(0xFF1E293B),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: panel,
        indicatorColor: accent.withOpacity(0.16),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((Set<WidgetState> states) {
          final bool selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? textPrimary : textSecondary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
      ),
      iconTheme: const IconThemeData(color: textPrimary),
    );
  }
}
