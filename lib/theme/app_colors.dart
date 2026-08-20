import 'package:flutter/material.dart';

/// Centralized Color Tokens for the Gourmet Food Delivery Application.
/// Design System: Warm off-white base (#FFF8F0), rich charcoal dark contrast (#1A1410),
/// appetizing red-orange primary (#E85D3F), golden mustard secondary (#F2A93B),
/// and forest green deep accent (#2D5C3E).
class AppColors {
  // Background Colors
  static const Color bgCream = Color(0xFFFFF8F0);
  static const Color bgDarkCharcoal = Color(0xFF1A1410);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color bgCardSoft = Color(0xFFFFFBF5);

  // Aliases for Dark Mode & Glass Sections
  static const Color bgDark = bgDarkCharcoal;
  static const Color bgCardHover = Color(0xFFFFFBF5);

  // Accent Colors
  static const Color primaryFlame = Color(0xFFE85D3F); // Warm appetizing red-orange
  static const Color secondaryGold = Color(0xFFF2A93B); // Golden mustard
  static const Color forestGreen = Color(0xFF2D5C3E); // Deep forest green
  static const Color accentEmerald = Color(0xFF2D5C3E); // Forest green alias
  static const Color accentEmber = Color(0xFFFF9200); // Warm amber glow

  // Neutral Typography & UI Colors
  static const Color textPrimary = Color(0xFF1A1410); // Dark Charcoal
  static const Color textSecondary = Color(0xFF6E5D4F); // Warm Muted Brown
  static const Color textMuted = Color(0xFF9E8C7C); // Soft Tan
  static const Color textLight = Color(0xFFFFF8F0); // Off-white for dark cards

  // Borders & Glassmorphism
  static const Color borderLight = Color(0xFFF3E7DB);
  static const Color borderDark = Color(0xFF332921);
  static const Color glassBorder = borderLight;
  static Color glassBackground = Colors.white.withValues(alpha: 0.85);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryFlame, secondaryGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient heroGlowGradient = RadialGradient(
    colors: [
      Color(0x33E85D3F),
      Color(0x1AF2A93B),
      Colors.transparent,
    ],
    radius: 0.85,
  );

  static const LinearGradient ctaGradient = LinearGradient(
    colors: [primaryFlame, secondaryGold],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient forestGradient = LinearGradient(
    colors: [forestGreen, Color(0xFF1E3E2A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
