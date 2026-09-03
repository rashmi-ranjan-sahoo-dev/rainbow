import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/section_navigator.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/rainbow_logo.dart';
import '../../../../shared/widgets/scroll_aware_header.dart';
import '../booking/booking_modal.dart';
import 'mobile_drawer.dart';
import 'nav_menu.dart';

/// Section 2 — Main dynamic header with official Rainbow hospital logo, navigation, and CTA button.
///
/// Supports 3 interaction modes matching the reference design:
/// 1. Floating Card (Top / Hero): Sits as a floating rounded card with margin & shadow over hero section.
/// 2. Hidden Upwards (Scrolling Down): Vanishes smoothly upwards to maximize reading view.
/// 3. Attached Sticky Header (Scrolling Up): Slides down attached edge-to-edge with frosted glass & shadow.
class HeaderWidget extends StatelessWidget {
  final HeaderState headerState;

  const HeaderWidget({
    super.key,
    this.headerState = HeaderState.expanded,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Responsive tiers:
    // >= 1080px: Desktop / Laptop (Logo + Center Nav + CTA Button)
    // 650px - 1079px: Tablet (Logo + CTA Button + Hamburger Drawer)
    // < 650px: Mobile (Logo + Hamburger Drawer)
    final isDesktop = screenWidth >= 1080;
    final isMobile = screenWidth < 650;

    final isFloating = headerState == HeaderState.expanded;
    final isSticky = headerState == HeaderState.compact;

    // ── Floating Margin (Top on Hero) vs Edge-to-Edge (Sticky Scroll Up) ──
    final margin = isFloating
        ? EdgeInsets.fromLTRB(
            isMobile ? 10 : 20,
            isMobile ? 3 : 5,
            isMobile ? 10 : 20,
            0,
          )
        : EdgeInsets.zero;

    final borderRadius = isFloating
        ? BorderRadius.circular(isMobile ? 12 : 16)
        : BorderRadius.zero;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1360),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeInOutCubic,
          margin: margin,
          decoration: BoxDecoration(
            color: isSticky
                ? AppColors.background.withValues(alpha: 0.95)
                : AppColors.background,
            borderRadius: borderRadius,
            border: Border.all(
              color: isFloating
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : Colors.transparent,
              width: 1,
            ),
            boxShadow: [
              if (isFloating)
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                )
              else if (isSticky)
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 3),
                )
              else
                BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 0,
                  offset: Offset.zero,
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: isSticky
                ? BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: _buildContent(context, isSticky, isFloating, isMobile, isDesktop, screenWidth),
                  )
                : _buildContent(context, isSticky, isFloating, isMobile, isDesktop, screenWidth),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isSticky, bool isFloating, bool isMobile, bool isDesktop, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isFloating
            ? (isMobile ? 12.0 : 20.0)
            : ResponsiveHelper.horizontalPadding(context),
        vertical: isMobile ? (isSticky ? 4.0 : 5.5) : (isSticky ? 5.0 : 7.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── 1. Official Logo Emblem & Typography ──
          RainbowLogo(
            height: isDesktop
                ? (isSticky ? 22.0 : 26.0) // Reduced size specifically for PC / Laptop screens
                : (isMobile
                    ? (isSticky ? 25.0 : 26.0) // Just more than previous size (28.0 -> 33.0)
                    : (isSticky ? 26.0 : 32.0)), // Tablet
            onTap: () => SectionNavigator.scrollTo(SectionNavigator.heroKey),
          ),

          // ── 2. Desktop Navigation Menu (Screens >= 1080px) ──
          if (isDesktop)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: NavMenu(isCompact: screenWidth < 1220),
                ),
              ),
            )
          else
            const Spacer(),

          // ── 3. Actions (CTA Button + Hamburger) ──
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Book Appointment Button (Visible on tablet & desktop)
              if (!isMobile) ...[
                HeaderButton(
                  label: 'Book Appointment',
                  onPressed: () => showBookingDialog(context),
                ),
              ],

              // Hamburger Button (Visible on tablet & mobile < 1080px)
              if (!isDesktop) ...[
                if (!isMobile) const SizedBox(width: 10),
                _HamburgerButton(showLabel: isMobile),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Hamburger menu button that opens the mobile/tablet drawer with smooth slide animation.
class _HamburgerButton extends StatefulWidget {
  final bool showLabel;

  const _HamburgerButton({this.showLabel = false});

  @override
  State<_HamburgerButton> createState() => _HamburgerButtonState();
}

class _HamburgerButtonState extends State<_HamburgerButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => openSmoothDrawer(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: widget.showLabel ? 9 : 8,
            vertical: widget.showLabel ? 4.5 : 6,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.primary.withValues(alpha: 0.10)
                : (widget.showLabel
                    ? AppColors.primary.withValues(alpha: 0.05)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
            border: widget.showLabel
                ? Border.all(
                    color: _isHovered
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.20),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_rounded,
                color: _isHovered ? AppColors.primary : AppColors.textPrimary,
                size: widget.showLabel ? 22 : 24,
              ),
              if (widget.showLabel) ...[
                const SizedBox(width: 4),
                Text(
                  'Menu',
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: _isHovered ? AppColors.primary : AppColors.textPrimary,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
