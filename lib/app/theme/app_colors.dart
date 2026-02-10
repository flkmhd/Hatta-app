import 'package:flutter/material.dart';

/// Hatta Design System Colors
/// Mediterranean-inspired palette extracted from React app
class AppColors {
  AppColors._();

  // ============ LIGHT THEME ============

  /// Jasmin White - Primary background
  static const Color background = Color(0xFFFDFDF9);

  /// Anthracite - Primary text color
  static const Color foreground = Color(0xFF2D3436);

  /// Pure white cards
  static const Color card = Color(0xFFFFFFFF);

  /// Mediterranean Blue - Primary action color
  static const Color primary = Color(0xFF0077CC);

  /// White text on primary
  static const Color primaryForeground = Color(0xFFFFFFFF);

  /// Sand Yellow - Accent/highlight color
  static const Color accent = Color(0xFFF2C94C);

  /// Dark text on accent
  static const Color accentForeground = Color(0xFF2D3436);

  /// Light cream secondary
  static const Color secondary = Color(0xFFF5F5F0);

  /// Muted background
  static const Color muted = Color(0xFFEDEDE8);

  /// Muted text
  static const Color mutedForeground = Color(0xFF6B7280);

  /// Error/destructive red
  static const Color destructive = Color(0xFFEF4444);

  /// Border color
  static const Color border = Color(0xFFE5E5DD);

  /// Input border
  static const Color input = Color(0xFFE5E5DD);

  // ============ DARK THEME ============

  static const Color backgroundDark = Color(0xFF161A1D);
  static const Color foregroundDark = Color(0xFFFDFDF9);
  static const Color cardDark = Color(0xFF1E2529);
  static const Color primaryDark = Color(0xFF0099FF);
  static const Color secondaryDark = Color(0xFF2A3238);
  static const Color mutedDark = Color(0xFF333D44);
  static const Color mutedForegroundDark = Color(0xFFA3B3C2);
  static const Color borderDark = Color(0xFF3A4550);

  // ============ SEMANTIC COLORS ============

  /// Success green
  static const Color success = Color(0xFF22C55E);

  /// Warning orange
  static const Color warning = Color(0xFFF59E0B);

  /// Info blue
  static const Color info = Color(0xFF3B82F6);

  // ============ GRADIENTS ============

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0077CC), Color(0xFF0099FF)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF2C94C), Color(0xFFF7DC8A)],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFDFDF9), Color(0xFFF5EFE6)],
  );
}
