import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized Typography System for Gourmet Restaurant & Food Delivery App.
/// Uses elegant serif font (Playfair Display) for headlines to feel "fine dining",
/// and clean sans-serif (Plus Jakarta Sans) for body text and interactive UI labels.
class AppTextStyles {
  // Hero Display Headline (Serif - Fine Dining)
  static TextStyle heroHeading(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GoogleFonts.playfairDisplay(
      fontSize: width < 768 ? 40 : 64,
      fontWeight: FontWeight.w800,
      height: 1.15,
      color: AppColors.textPrimary,
      letterSpacing: -1.0,
    );
  }

  // Section Heading (Serif - Fine Dining)
  static TextStyle sectionHeading(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GoogleFonts.playfairDisplay(
      fontSize: width < 768 ? 28 : 42,
      fontWeight: FontWeight.w700,
      height: 1.25,
      color: AppColors.textPrimary,
      letterSpacing: -0.5,
    );
  }

  // Card Title (Serif or Semi-Bold Sans)
  static TextStyle cardTitle(BuildContext context) {
    return GoogleFonts.playfairDisplay(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      height: 1.3,
      color: AppColors.textPrimary,
    );
  }

  // Eyebrow Badge Text (Sans-serif)
  static TextStyle eyebrow(BuildContext context) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 12,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.5,
      color: AppColors.primaryFlame,
    );
  }

  // Lead Body Subtext (Sans-serif)
  static TextStyle leadBody(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GoogleFonts.plusJakartaSans(
      fontSize: width < 768 ? 16 : 18,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: AppColors.textSecondary,
    );
  }

  // Body Text (Sans-serif)
  static TextStyle body(BuildContext context) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: AppColors.textSecondary,
    );
  }

  // Button Label (Sans-serif)
  static TextStyle buttonLabel(BuildContext context) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      letterSpacing: 0.5,
    );
  }
}
