import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

/// Official Rainbow Eye Hospital Logo Icon (The signature "R" with rainbow eye iris inside).
class RainbowLogoIcon extends StatelessWidget {
  final double size;
  final Gradient? gradient;

  const RainbowLogoIcon({
    super.key,
    this.size = 32,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.08,
      height: size,
      child: CustomPaint(
        painter: _RainbowLogoPainter(
          gradient: gradient ?? AppColors.primaryGradient,
        ),
      ),
    );
  }
}

/// Custom painter that renders the exact official "R with Eye" hospital emblem
/// using PathFillType.evenOdd for 100% crisp vector rendering, featuring the
/// cyan-teal outer body and vibrant spectral rainbow iris ring.
class _RainbowLogoPainter extends CustomPainter {
  final Gradient? gradient;

  _RainbowLogoPainter({this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final rPaint = Paint()..style = PaintingStyle.fill;
    final rGradient = gradient ?? AppColors.primaryGradient;
    rPaint.shader = rGradient.createShader(Rect.fromLTWH(0, 0, w, h));

    // ── 1. Outer "R" Outline with Eye Cutout (EvenOdd Fill) ──
    final rPath = Path()..fillType = PathFillType.evenOdd;
    final stemW = w * 0.24;

    // Outer R boundary
    rPath.moveTo(0, 0);
    rPath.lineTo(w * 0.62, 0);
    rPath.cubicTo(w * 0.96, 0, w * 1.00, h * 0.16, w * 1.00, h * 0.36);
    rPath.cubicTo(w * 1.00, h * 0.54, w * 0.88, h * 0.63, w * 0.64, h * 0.64);
    // Diagonal leg
    rPath.lineTo(w * 0.98, h);
    rPath.lineTo(w * 0.68, h);
    rPath.lineTo(w * 0.44, h * 0.64);
    rPath.lineTo(stemW, h * 0.64);
    rPath.lineTo(stemW, h);
    rPath.lineTo(0, h);
    rPath.close();

    // ── 2. Eye Cutout aperture inside upper loop of R ──
    final eyeCenterX = w * 0.53;
    final eyeCenterY = h * 0.32;
    final eyeRadiusX = w * 0.29;
    final eyeRadiusY = h * 0.175;

    final eyeHolePath = Path();
    eyeHolePath.moveTo(eyeCenterX - eyeRadiusX, eyeCenterY);
    // Upper eyelid curve
    eyeHolePath.cubicTo(
      eyeCenterX - eyeRadiusX * 0.46,
      eyeCenterY - eyeRadiusY * 1.34,
      eyeCenterX + eyeRadiusX * 0.46,
      eyeCenterY - eyeRadiusY * 1.34,
      eyeCenterX + eyeRadiusX,
      eyeCenterY,
    );
    // Lower eyelid curve
    eyeHolePath.cubicTo(
      eyeCenterX + eyeRadiusX * 0.46,
      eyeCenterY + eyeRadiusY * 1.34,
      eyeCenterX - eyeRadiusX * 0.46,
      eyeCenterY + eyeRadiusY * 1.34,
      eyeCenterX - eyeRadiusX,
      eyeCenterY,
    );
    eyeHolePath.close();

    // Add eye hole to rPath (EvenOdd makes this aperture transparent)
    rPath.addPath(eyeHolePath, Offset.zero);

    // Draw the outer teal "R" with the clear eye aperture
    canvas.drawPath(rPath, rPaint);

    // ── 3. Spectral Rainbow Iris Donut Ring inside Eye Hole ──
    final pupilRadius = eyeRadiusY * 0.82;
    final pupilCenter = Offset(eyeCenterX, eyeCenterY);
    final irisRect = Rect.fromCircle(center: pupilCenter, radius: pupilRadius);

    const rainbowSweep = SweepGradient(
      colors: [
        Color(0xFFE11D48), // Rose Red
        Color(0xFFF97316), // Vibrant Orange
        Color(0xFFFBBF24), // Amber / Yellow
        Color(0xFF10B981), // Emerald Green
        Color(0xFF06B6D4), // Cyan
        Color(0xFF3B82F6), // Blue
        Color(0xFF8B5CF6), // Violet / Purple
        Color(0xFFE11D48), // Loop back to Red
      ],
    );

    final irisPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = rainbowSweep.createShader(irisRect);

    final irisPath = Path()..fillType = PathFillType.evenOdd;
    irisPath.addOval(Rect.fromCircle(center: pupilCenter, radius: pupilRadius));
    irisPath.addOval(Rect.fromCircle(center: pupilCenter, radius: pupilRadius * 0.40));

    // Draw the rainbow iris ring
    canvas.drawPath(irisPath, irisPaint);

    // ── 4. Specular Highlight Bubble at ~1:30 position ──
    final bubbleOffset = Offset(
      eyeCenterX + pupilRadius * 0.72,
      eyeCenterY - pupilRadius * 0.44,
    );
    final bubbleRadius = pupilRadius * 0.34;
    final bubblePath = Path()
      ..addOval(Rect.fromCircle(center: bubbleOffset, radius: bubbleRadius));

    final bubblePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = rGradient.createShader(Rect.fromCircle(center: bubbleOffset, radius: bubbleRadius));

    // Draw highlight bubble
    canvas.drawPath(bubblePath, bubblePaint);
  }

  @override
  bool shouldRepaint(covariant _RainbowLogoPainter oldDelegate) =>
      oldDelegate.gradient != gradient;
}

/// Custom circular rainbow spectral ring for the letter 'O' in RAINBOW and HOSPITAL.
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
      child: CustomPaint(
        painter: _RainbowOPainter(strokeWidthRatio: strokeWidthRatio),
      ),
    );
  }
}

class _RainbowOPainter extends CustomPainter {
  final double strokeWidthRatio;

  const _RainbowOPainter({required this.strokeWidthRatio});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = radius * strokeWidthRatio * 2;

    final rect = Rect.fromCircle(center: center, radius: radius);

    const sweepGradient = SweepGradient(
      colors: [
        Color(0xFFE11D48), // Rose Red
        Color(0xFFF97316), // Vibrant Orange
        Color(0xFFFBBF24), // Amber / Yellow
        Color(0xFF10B981), // Emerald Green
        Color(0xFF06B6D4), // Cyan
        Color(0xFF3B82F6), // Blue
        Color(0xFF8B5CF6), // Violet / Purple
        Color(0xFFE11D48), // Loop back to Red
      ],
    );

    final paint = Paint()
      ..shader = sweepGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    canvas.drawCircle(center, radius - strokeWidth / 2, paint);
  }

  @override
  bool shouldRepaint(covariant _RainbowOPainter oldDelegate) =>
      oldDelegate.strokeWidthRatio != strokeWidthRatio;
}

/// Official Rainbow Eye Hospital Logo with:
/// - Top: Signature "R with Rainbow Eye" emblem icon
/// - Bottom: Centered Hospital Name ("RAINBOW" and "EYE HOSPITAL") with Orbitron font & Rainbow 'O's
/// - Original colors preserved (Spectral Rainbow Iris & Rainbow 'O's)
/// - Smooth interactive hover animations & responsive scaling
class RainbowLogo extends StatefulWidget {
  final double iconSize;
  final bool isDark;
  final bool isVertical;
  final VoidCallback? onTap;

  const RainbowLogo({
    super.key,
    this.iconSize = 28,
    this.isDark = false,
    this.isVertical = true,
    this.onTap,
  });

  @override
  State<RainbowLogo> createState() => _RainbowLogoState();
}

class _RainbowLogoState extends State<RainbowLogo> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final titleSize = widget.iconSize * 0.42;
    final subtitleSize = widget.iconSize * 0.25;

    final logoGradient = widget.isDark
        ? const LinearGradient(
            colors: [Color(0xFF38BDF8), Colors.white],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF06B6D4), // Light Cyan
              Color(0xFF0891B2), // Vibrant Brand Teal
              Color(0xFF0E7490), // Deep Medical Teal
            ],
          );

    final titleStyle = GoogleFonts.orbitron(
      fontSize: titleSize,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.6,
      color: Colors.white,
      height: 1.02,
    );

    final subtitleStyle = GoogleFonts.orbitron(
      fontSize: subtitleSize,
      fontWeight: FontWeight.w800,
      letterSpacing: 2.2,
      color: Colors.white,
      height: 1.05,
    );

    Widget textColumn({required bool isCentered}) {
      return Column(
        crossAxisAlignment:
            isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Line 1: RAINB + [Rainbow O] + W
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:
                isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => logoGradient.createShader(bounds),
                child: Text('RAINB', style: titleStyle),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.8),
                child: RainbowLetterO(
                  size: titleSize * 0.82,
                  strokeWidthRatio: 0.32,
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => logoGradient.createShader(bounds),
                child: Text('W', style: titleStyle),
              ),
            ],
          ),
          const SizedBox(height: 1.2),

          // Line 2: EYE H + [Rainbow O] + SPITAL
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:
                isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => logoGradient.createShader(bounds),
                child: Text('EYE H', style: subtitleStyle),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.6),
                child: RainbowLetterO(
                  size: subtitleSize * 0.82,
                  strokeWidthRatio: 0.34,
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => logoGradient.createShader(bounds),
                child: Text('SPITAL', style: subtitleStyle),
              ),
            ],
          ),
        ],
      );
    }

    final Widget content = widget.isVertical
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RainbowLogoIcon(
                size: widget.iconSize,
                gradient: logoGradient,
              ),
              const SizedBox(height: 2.5),
              textColumn(isCentered: true),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RainbowLogoIcon(
                size: widget.iconSize,
                gradient: logoGradient,
              ),
              const SizedBox(width: 8),
              textColumn(isCentered: false),
            ],
          );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.035 : 1.0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                if (_isHovered)
                  BoxShadow(
                    color: const Color(0xFF06B6D4).withValues(alpha: 0.18),
                    blurRadius: 14,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
