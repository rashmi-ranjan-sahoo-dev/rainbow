import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/section_navigator.dart';

/// Desktop & Laptop Horizontal Navigation Menu with clean, direct section navigation.
class NavMenu extends StatelessWidget {
  final bool isCompact;

  const NavMenu({super.key, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    final horizontalItemPadding = isCompact ? 9.0 : 13.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavMenuItem(
          title: 'Home',
          isActive: true,
          isCompact: isCompact,
          horizontalPadding: horizontalItemPadding,
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.heroKey),
        ),
        _NavMenuItem(
          title: 'About',
          isCompact: isCompact,
          horizontalPadding: horizontalItemPadding,
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.aboutKey),
        ),
        _NavMenuItem(
          title: 'Services',
          isCompact: isCompact,
          horizontalPadding: horizontalItemPadding,
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.servicesKey),
        ),
        _NavMenuItem(
          title: 'Doctors',
          isCompact: isCompact,
          horizontalPadding: horizontalItemPadding,
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.doctorsKey),
        ),
        _NavMenuItem(
          title: 'Gallery',
          isCompact: isCompact,
          horizontalPadding: horizontalItemPadding,
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.galleryKey),
        ),
        _NavMenuItem(
          title: 'Testimonials',
          isCompact: isCompact,
          horizontalPadding: horizontalItemPadding,
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.testimonialsKey),
        ),
        _NavMenuItem(
          title: 'Blogs',
          isCompact: isCompact,
          horizontalPadding: horizontalItemPadding,
          onTap: () => Navigator.pushNamed(context, '/blogs'),
        ),
        _NavMenuItem(
          title: 'Contact',
          isCompact: isCompact,
          horizontalPadding: horizontalItemPadding,
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.contactKey),
        ),
      ],
    );
  }
}

class _NavMenuItem extends StatefulWidget {
  final String title;
  final bool isActive;
  final bool isCompact;
  final double horizontalPadding;
  final VoidCallback? onTap;

  const _NavMenuItem({
    required this.title,
    this.isActive = false,
    this.isCompact = false,
    this.horizontalPadding = 14,
    this.onTap,
  });

  @override
  State<_NavMenuItem> createState() => _NavMenuItemState();
}

class _NavMenuItemState extends State<_NavMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = widget.isActive || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.primary.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Text(
                widget.title,
                style: AppTypography.navLink.copyWith(
                  color: isHighlighted
                      ? AppColors.primary
                      : AppColors.textPrimary,
                  fontWeight:
                      isHighlighted ? FontWeight.w600 : FontWeight.w500,
                  fontSize: widget.isCompact ? 14.5 : 15.5,
                ),
              ),
              // Active bottom indicator bar
              Positioned(
                bottom: -2,
                left: 4,
                right: 4,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 2.5,
                  decoration: BoxDecoration(
                    color: widget.isActive ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
