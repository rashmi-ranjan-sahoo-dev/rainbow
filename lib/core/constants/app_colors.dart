import 'package:flutter/material.dart';

/// Central color palette for the Rainbow Eye Hospital app.
class AppColors {
  AppColors._();

  // ── Primary Brand ──
  static const Color primary = Color(0xFF0891B2);       // Vibrant Medical Cyan/Teal
  static const Color primaryDark = Color(0xFF0E7490);   // Deep Cyan
  static const Color primaryDeep = Color(0xFF155E75);   // Darkest Teal
  static const Color primaryLight = Color(0xFF22D3EE);  // Bright Aqua
  static const Color primaryUltraLight = Color(0xFFECFEFF); // Tinted soft bg

  // ── Secondary / Dark Navy & Petrol Teal ──
  static const Color secondary = Color(0xFF0F172A);     // Slate 900
  static const Color secondaryNavy = Color(0xFF1E293B); // Slate 800
  static const Color secondaryLight = Color(0xFF334155);// Slate 700

  // ── Text ──
  static const Color textPrimary = Color(0xFF1E293B);   // Dark charcoal
  static const Color textSecondary = Color(0xFF64748B); // Cool gray
  static const Color textMuted = Color(0xFF94A3B8);     // Muted gray
  static const Color textLight = Color(0xFFE2E8F0);     // Light slate
  static const Color textWhite = Color(0xFFFFFFFF);

  // ── Backgrounds & Surfaces ──
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color surfaceDark = Color(0xFFF1F5F9);
  static const Color surfaceCard = Color(0xFFFFFFFF);

  // ── Accents & Badges ──
  static const Color accent = Color(0xFFF59E0B);        // Amber gold
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color success = Color(0xFF10B981);       // Emerald green
  static const Color badgeBg = Color(0xFFFEF3C7);
  static const Color badgeText = Color(0xFFB45309);

  // ── Utility & Glassmorphism ──
  static const Color divider = Color(0xFFE2E8F0);
  static const Color dividerDark = Color(0x20FFFFFF);
  static const Color shadow = Color(0x12000000);
  static const Color shadowMedium = Color(0x20000000);
  static const Color overlayDark = Color(0xB30F172A);

  // ── Gradients ──
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0891B2), Color(0xFF0E7490)],
  );

  static const LinearGradient heroOverlayDesktop = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xEE0B192C), Color(0xAA0F172A), Color(0x100F172A)],
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient heroOverlayMobile = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [Color(0xF00B192C), Color(0x880F172A)],
    stops: [0.0, 1.0],
  );

  static const LinearGradient statsGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF0E7490), Color(0xFF0891B2), Color(0xFF0E7490)],
  );

  static const LinearGradient cardGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x100891B2), Color(0x020891B2)],
  );
}
