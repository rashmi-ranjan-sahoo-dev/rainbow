import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

/// Premium CTA button with smooth hover scale, glow, and animated icon.
class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final double? width;
  final EdgeInsets? padding;
  final FaIconData? icon;
  final bool showArrow;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isOutlined = false,
    this.width,
    this.padding,
    this.icon,
    this.showArrow = true,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _arrowOffsetAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _arrowOffsetAnimation = Tween<double>(begin: 0.0, end: 4.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: _isHovered && !widget.isOutlined
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: widget.isOutlined
              ? OutlinedButton(
                  onPressed: widget.onPressed ?? () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textWhite,
                    backgroundColor: _isHovered
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.transparent,
                    side: const BorderSide(color: AppColors.textWhite, width: 1.5),
                    padding: widget.padding ??
                        const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        FaIcon(widget.icon, size: 14, color: AppColors.textWhite),
                        const SizedBox(width: 8),
                      ],
                      Text(widget.label, style: AppTypography.buttonOutlined),
                    ],
                  ),
                )
              : ElevatedButton(
                  onPressed: widget.onPressed ?? () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                    elevation: 0,
                    padding: widget.padding ??
                        const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        FaIcon(widget.icon, size: 14, color: AppColors.textWhite),
                        const SizedBox(width: 8),
                      ],
                      Text(widget.label, style: AppTypography.buttonPrimary),
                      if (widget.showArrow) ...[
                        const SizedBox(width: 8),
                        AnimatedBuilder(
                          animation: _arrowOffsetAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_arrowOffsetAnimation.value, 0),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    ),
    );
  }
}

/// Header-specific CTA button with smooth glow and micro-interaction.
class HeaderButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;

  const HeaderButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  State<HeaderButton> createState() => _HeaderButtonState();
}

class _HeaderButtonState extends State<HeaderButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            gradient: _isHovered
                ? const LinearGradient(
                    colors: [AppColors.primaryLight, AppColors.primary],
                  )
                : AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(8),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: ElevatedButton(
            onPressed: widget.onPressed ?? () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.textWhite,
              shadowColor: Colors.transparent,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(FontAwesomeIcons.calendarCheck, size: 13, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: AppTypography.buttonPrimary.copyWith(fontSize: 13.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
