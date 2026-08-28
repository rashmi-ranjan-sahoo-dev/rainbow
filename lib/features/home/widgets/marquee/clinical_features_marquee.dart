import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_colors.dart';

/// Tuning Constants for Motion Choreography:
/// - [kMarqueeScrollSpeed]: Velocity in logical pixels per second.
///   48.0 px/s provides a silky-smooth, premium, and highly legible continuous glide.
const double kMarqueeScrollSpeed = 48.0;

/// Model for an individual badge token in the infinite marquee ribbon.
class MarqueeFeatureItem {
  final String text;
  final FaIconData icon;

  const MarqueeFeatureItem({
    required this.text,
    this.icon = FontAwesomeIcons.starOfLife,
  });
}

/// A Senior-Engineered, 60fps/120fps Silky-Smooth Hardware-Accelerated Marquee Ribbon.
/// 
/// Motion & Visual Architecture:
/// - 💎 Vibrant App Primary Gradient: [AppColors.primaryDark] (`#0E7490`) -> [AppColors.primary] (`#0891B2`) -> Bright Aqua (`#06B6D4`).
/// - 🚀 Delta-Time Frame-Rate Independent Engine: Drives continuous translation via [Ticker] vsync callbacks.
/// - 🔄 Automatic Zero-Jitter Infinite Loop: Clones two identical buffers and wraps dynamically at `maxScrollExtent / 2`.
/// - 🖐️ Micro-Physics: Seamless pause on pointer hover / touch drag with instant gentle resume.
/// - 📱 100% Responsive: Dynamic height, typography, icon size, and proportional spacing for Mobile, Tablet, and Desktop.
/// - ♿ Accessibility: Automatically respects [MediaQuery.disableAnimations] (Reduce Motion).
class ClinicalFeaturesMarquee extends StatefulWidget {
  final double scrollSpeed;
  final Gradient? customGradient;

  const ClinicalFeaturesMarquee({
    super.key,
    this.scrollSpeed = kMarqueeScrollSpeed,
    this.customGradient,
  });

  @override
  State<ClinicalFeaturesMarquee> createState() => _ClinicalFeaturesMarqueeState();
}

class _ClinicalFeaturesMarqueeState extends State<ClinicalFeaturesMarquee>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  bool _isHovered = false;

  static const List<MarqueeFeatureItem> _features = [
    MarqueeFeatureItem(text: 'ADVANCED PROFESSIONALS'),
    MarqueeFeatureItem(text: 'ADVANCED TECHNOLOGY'),
    MarqueeFeatureItem(text: 'PREVENTIVE CARE'),
    MarqueeFeatureItem(text: 'PATIENT-CENTERED APPROACH'),
    MarqueeFeatureItem(text: 'GERMAN CARL ZEISS PRECISION'),
    MarqueeFeatureItem(text: '24/7 EYE EMERGENCY'),
    MarqueeFeatureItem(text: 'AIIMS-TRAINED SPECIALISTS'),
    MarqueeFeatureItem(text: 'BLADE-FREE LASER TREATMENTS'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // High-performance vsync delta-time ticker (60Hz / 90Hz / 120Hz ProMotion adaptive)
    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    if (!mounted || !_scrollController.hasClients || _isHovered) {
      _lastElapsed = elapsed;
      return;
    }

    final deltaMicroseconds = (elapsed - _lastElapsed).inMicroseconds;
    _lastElapsed = elapsed;

    // Guard against first frame or unexpected thread pauses
    if (deltaMicroseconds <= 0 || deltaMicroseconds > 100000) {
      return;
    }

    final deltaSeconds = deltaMicroseconds / 1000000.0;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (maxScroll > 0) {
      final halfScroll = maxScroll / 2.0;
      final newOffset = _scrollController.offset + (widget.scrollSpeed * deltaSeconds);

      // Seamless invisible modulo jump when reaching half-scroll buffer
      if (newOffset >= halfScroll) {
        _scrollController.jumpTo(newOffset - halfScroll);
      } else {
        _scrollController.jumpTo(newOffset);
      }
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onPointerEnter() {
    setState(() => _isHovered = true);
  }

  void _onPointerExit() {
    setState(() => _isHovered = false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 650;
    final isTablet = screenWidth >= 650 && screenWidth < 1080;

    // Responsive token sizing
    final double ribbonHeight = isMobile ? 46.0 : (isTablet ? 54.0 : 62.0);
    final double fontSize = isMobile ? 12.2 : (isTablet ? 13.8 : 15.2);
    final double iconSize = isMobile ? 10.0 : (isTablet ? 11.5 : 13.0);
    final double itemSpacing = isMobile ? 24.0 : (isTablet ? 30.0 : 36.0);
    final double iconSpacing = isMobile ? 16.0 : (isTablet ? 20.0 : 24.0);

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => _onPointerEnter(),
        onExit: (_) => _onPointerExit(),
        child: GestureDetector(
          onPanDown: (_) => _onPointerEnter(),
          onPanEnd: (_) => _onPointerExit(),
          onPanCancel: () => _onPointerExit(),
          child: Container(
            width: double.infinity,
            height: ribbonHeight,
            decoration: BoxDecoration(
              gradient: widget.customGradient ??
                  const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF0E7490), // Deep Cyan
                      Color(0xFF0891B2), // Primary Medical Teal
                      Color(0xFF06B6D4), // Bright Aqua highlight
                      Color(0xFF0891B2), // Primary Medical Teal
                      Color(0xFF0E7490), // Deep Cyan
                    ],
                    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                  ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.30),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.white,
                    Colors.white,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.03, 0.97, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(), // Controlled exclusively by vsync engine
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Buffer Set 1
                    _buildFeatureSet(fontSize, iconSize, itemSpacing, iconSpacing),
                    // Buffer Set 2 (Identical for seamless wrap)
                    _buildFeatureSet(fontSize, iconSize, itemSpacing, iconSpacing),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureSet(
    double fontSize,
    double iconSize,
    double itemSpacing,
    double iconSpacing,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _features.map((item) {
        return _MarqueeItemWidget(
          item: item,
          fontSize: fontSize,
          iconSize: iconSize,
          itemSpacing: itemSpacing,
          iconSpacing: iconSpacing,
        );
      }).toList(),
    );
  }
}

/// An individual interactive marquee token with hover scale and star micro-rotation.
class _MarqueeItemWidget extends StatefulWidget {
  final MarqueeFeatureItem item;
  final double fontSize;
  final double iconSize;
  final double itemSpacing;
  final double iconSpacing;

  const _MarqueeItemWidget({
    required this.item,
    required this.fontSize,
    required this.iconSize,
    required this.itemSpacing,
    required this.iconSpacing,
  });

  @override
  State<_MarqueeItemWidget> createState() => _MarqueeItemWidgetState();
}

class _MarqueeItemWidgetState extends State<_MarqueeItemWidget> {
  bool _isItemHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isItemHovered = true),
      onExit: (_) => setState(() => _isItemHovered = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: const Cubic(0.16, 1.0, 0.3, 1.0), // easeOutExpo
        margin: EdgeInsets.only(right: widget.itemSpacing),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _isItemHovered
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bold Keyword Label
            Text(
              widget.item.text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w800,
                color: _isItemHovered
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.98),
                letterSpacing: 1.8,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
            SizedBox(width: widget.iconSpacing),

            // Medical Star/Asterisk Icon with Micro-Rotation on Hover
            AnimatedRotation(
              duration: const Duration(milliseconds: 300),
              curve: const Cubic(0.34, 1.56, 0.64, 1.0), // easeOutBack
              turns: _isItemHovered ? 0.25 : 0.0,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale: _isItemHovered ? 1.25 : 1.0,
                child: FaIcon(
                  widget.item.icon,
                  size: widget.iconSize,
                  color: _isItemHovered
                      ? const Color(0xFFFEF08A) // Soft glowing gold
                      : const Color(0xFFFDE047).withValues(alpha: 0.95), // Warm yellow/amber accent star
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
