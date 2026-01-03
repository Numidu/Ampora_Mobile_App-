import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF00C896);
  static const Color darkGreen = Color(0xFF27AE60);
  static const Color bgWhite = Color(0xFFF9F9F9);

  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF0F1419)
          : const Color(0xFFE8F9F5);

  static Color card(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1A1F2E)
          : Colors.white;

  static Color text(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFE8F0F2)
          : const Color(0xFF1A2332);

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF8B95A5)
          : const Color(0xFF5A6C7D);

  static Color border(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF2A3441)
          : const Color(0xFFE0E7ED);

  static Color iconBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E3A34)
          : const Color(0xFFE8F9F5);

  static Color searchField(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF252D3C)
          : Colors.white;
}
