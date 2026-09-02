import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Central typography for the Rainbow Eye Hospital app.
/// Uses Poppins for headings/CTAs and Inter for body/utility text.
class AppTypography {
  AppTypography._();

  // ── Hero ──
  static TextStyle heroHeadline(double fontSize) => GoogleFonts.poppins(
    fontSize: fontSize,
    fontWeight: FontWeight.w800,
    color: AppColors.textWhite,
    height: 1.18,
    letterSpacing: -0.5,
    shadows: [
      Shadow(
        color: Colors.black.withValues(alpha: 0.60),
        offset: const Offset(0, 2),
        blurRadius: 10,
      ),
    ],
  );

  static TextStyle heroEyebrow = GoogleFonts.poppins(
    fontSize: 12.5,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 1.8,
  );

  static TextStyle sectionEyebrow({
    Color? color,
    double? fontSize,
    double? letterSpacing,
  }) =>
      GoogleFonts.poppins(
        fontSize: fontSize ?? 11.5,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.primary,
        letterSpacing: letterSpacing ?? 1.1,
      );

  static TextStyle heroSubtext(double fontSize) => GoogleFonts.inter(
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF00E5FF),
    height: 1.6,
    shadows: [
      Shadow(
        color: Colors.black.withValues(alpha: 0.70),
        offset: const Offset(0, 1.5),
        blurRadius: 8,
      ),
    ],
  );

  // ── Navigation ──
  static TextStyle navLink = GoogleFonts.inter(
    fontSize: 15.5,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle navLinkActive = GoogleFonts.inter(
    fontSize: 15.5,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  // ── Dropdown Typography ──
  static TextStyle dropdownTitle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle dropdownSubtitle = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  static TextStyle dropdownBadge = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryDark,
  );

  static TextStyle dropdownHeader = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textMuted,
    letterSpacing: 1.2,
  );

  // ── Utility Bar ──
  static TextStyle utilityBar = GoogleFonts.inter(
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  // ── Buttons ──
  static TextStyle buttonPrimary = GoogleFonts.poppins(
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    letterSpacing: 0.3,
  );

  static TextStyle buttonOutlined = GoogleFonts.poppins(
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    letterSpacing: 0.3,
  );

  // ── Stats ──
  static TextStyle statNumber(double fontSize) => GoogleFonts.poppins(
    fontSize: fontSize,
    fontWeight: FontWeight.w800,
    color: AppColors.textWhite,
    letterSpacing: -0.5,
  );

  static TextStyle statLabel(double fontSize) => GoogleFonts.inter(
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
    color: Colors.white.withValues(alpha: 0.95),
    height: 1.3,
  );

  // ── Mobile Drawer ──
  static TextStyle drawerItem = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle drawerSubItem = GoogleFonts.inter(
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle drawerSubDescription = GoogleFonts.inter(
    fontSize: 11.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}
