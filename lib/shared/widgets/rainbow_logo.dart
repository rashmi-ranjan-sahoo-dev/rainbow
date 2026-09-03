import 'package:flutter/material.dart';
import 'rainbow_logo_bytes.dart';

/// Official Rainbow Eye Hospital Logo Icon (The signature "R" with eye emblem).
class RainbowLogoIcon extends StatelessWidget {
  final double size;
  final Gradient? gradient;
  final bool isDark;

  const RainbowLogoIcon({
    super.key,
    this.size = 32,
    this.gradient,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.31,
      height: size,
      child: Image.memory(
        isDark ? kRainbowLogoIconWhiteBytes : kRainbowLogoIconBytes,
        width: size * 1.31,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

/// Official Rainbow Eye Hospital Logo:
/// - Horizontal layout directly matching the user's reference screenshot
/// - Signature "R" with Eye emblem on the left
/// - Hospital name "RAINBOW" on top line and "EYE HOSPITAL" on bottom line
/// - Exact corporate cyan/teal color (#3CC3C3) and original typography
/// - Embedded directly in memory for instant, zero-delay, zero-404 rendering
/// - Responsive scaling across Mobile, Tablet, and Desktop
class RainbowLogo extends StatefulWidget {
  final double? height;
  final double iconSize;
  final bool isDark;
  final bool isVertical;
  final VoidCallback? onTap;

  const RainbowLogo({
    super.key,
    this.height,
    this.iconSize = 28,
    this.isDark = false,
    this.isVertical = false,
    this.onTap,
  });

  @override
  State<RainbowLogo> createState() => _RainbowLogoState();
}

class _RainbowLogoState extends State<RainbowLogo> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Responsive effective height: use explicitly passed height, otherwise calculate from iconSize
    final effectiveHeight = widget.height ?? (widget.iconSize * 1.15).clamp(22.0, 56.0);

    final Widget logoImage = Image.memory(
      widget.isDark ? kRainbowLogoWhiteBytes : kRainbowLogoBytes,
      height: effectiveHeight,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                if (_isHovered)
                  BoxShadow(
                    color: const Color(0xFF3CC3C3).withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: logoImage,
          ),
        ),
      ),
    );
  }
}

/// Retained for backwards-compatibility
class RainbowLetterO extends StatelessWidget {
  final double size;
  final double strokeWidthRatio;

  const RainbowLetterO({
    super.key,
    required this.size,
    this.strokeWidthRatio = 0.30,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 0.94,
      height: size * 0.94,
      child: Center(
        child: Container(
          width: size * 0.90,
          height: size * 0.90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF3CC3C3),
              width: size * 0.22,
            ),
          ),
        ),
      ),
    );
  }
}
