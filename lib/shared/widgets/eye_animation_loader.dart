import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

/// Ultra-smooth, premium animated Eye Loader.
/// Features:
/// 1. Smooth anatomical eyelid blinking
/// 2. Fluid pupil tracking and glance physics
/// 3. Glowing optical scanner HUD ring rotating smoothly
/// 4. Radiating vision wave ripple pulses
/// 5. Shimmering gradient typography
class EyeAnimationLoader extends StatefulWidget {
  final double size;
  final String? loadingText;
  final bool isFullScreen;

  const EyeAnimationLoader({
    super.key,
    this.size = 130,
    this.loadingText = 'Calibrating Precision Vision...',
    this.isFullScreen = false,
  });

  @override
  State<EyeAnimationLoader> createState() => _EyeAnimationLoaderState();
}

class _EyeAnimationLoaderState extends State<EyeAnimationLoader>
    with TickerProviderStateMixin {
  // 1. Eyelid blink
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  // 2. Pupil tracking (X, Y)
  late AnimationController _gazeController;
  late Animation<double> _pupilXAnimation;
  late Animation<double> _pupilYAnimation;

  // 3. Rotating HUD scanner ring
  late AnimationController _hudRotateController;

  // 4. Concentric vision wave ripple
  late AnimationController _waveController;

  // 5. Text pulse shimmer
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    // ── 1. Eyelid Blink ──
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.02).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOutCubic),
    );

    _scheduleBlink();

    // ── 2. Fluid Gaze / Pupil Tracking ──
    _gazeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _pupilXAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -0.42)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.42, end: 0.42)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.42, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 30,
      ),
    ]).animate(_gazeController);

    _pupilYAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -0.15)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.15, end: 0.12)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.12, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
    ]).animate(_gazeController);

    // ── 3. Rotating Optical Scanner HUD Ring ──
    _hudRotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat();

    // ── 4. Concentric Vision Wave Ripple ──
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // ── 5. Text Shimmer ──
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  Timer? _blinkTimer;

  void _scheduleBlink() {
    _blinkTimer?.cancel();
    _blinkTimer = Timer(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      _blinkController.forward().then((_) {
        if (!mounted) return;
        _blinkController.reverse().then((_) {
          if (mounted) _scheduleBlink();
        });
      });
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _blinkController.dispose();
    _gazeController.dispose();
    _hudRotateController.dispose();
    _waveController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eyeW = widget.size;
    final eyeH = widget.size * 0.62;
    final containerSize = widget.size + 90;

    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Optical Scanner Stage ──
          SizedBox(
            width: containerSize,
            height: containerSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. Expanding Vision Wave Pulse (Layer 1)
                AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    final progress = _waveController.value;
                    final scale = 0.85 + (progress * 0.55);
                    final opacity = (1.0 - progress).clamp(0.0, 1.0);

                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: eyeW * 1.15,
                        height: eyeW * 1.15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryLight.withValues(alpha: opacity * 0.35),
                            width: 1.8,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // 2. High-Tech Rotating HUD Scanner Reticle
                AnimatedBuilder(
                  animation: _hudRotateController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _hudRotateController.value * 2 * math.pi,
                      child: CustomPaint(
                        size: Size(eyeW * 1.22, eyeW * 1.22),
                        painter: _HudScannerPainter(
                          color: AppColors.primary.withValues(alpha: 0.45),
                          accentColor: AppColors.primaryLight,
                        ),
                      ),
                    );
                  },
                ),

                // 3. Counter-Rotating Inner Tech Dots
                AnimatedBuilder(
                  animation: _hudRotateController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: -_hudRotateController.value * 2 * math.pi * 0.6,
                      child: CustomPaint(
                        size: Size(eyeW * 0.95, eyeW * 0.95),
                        painter: _InnerReticlePainter(
                          color: AppColors.primary.withValues(alpha: 0.25),
                        ),
                      ),
                    );
                  },
                ),

                // 4. Anatomical Eye with Blink & Gaze
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _blinkAnimation,
                    _pupilXAnimation,
                    _pupilYAnimation,
                  ]),
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 28,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: CustomPaint(
                        size: Size(eyeW, eyeH),
                        painter: _SmoothEyePainter(
                          eyeOpenProgress: _blinkAnimation.value,
                          pupilOffsetX: _pupilXAnimation.value,
                          pupilOffsetY: _pupilYAnimation.value,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Brand Title with Shimmer Glow ──
          AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) {
              final shimmer = _shimmerController.value;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Color.lerp(AppColors.primary, AppColors.primaryLight, shimmer)!,
                        Color.lerp(AppColors.primaryDark, AppColors.primary, shimmer)!,
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'RAINBOW EYE HOSPITAL',
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (widget.loadingText != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.loadingText!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary.withValues(alpha: 0.7 + (shimmer * 0.3)),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );

    if (widget.isFullScreen) {
      return Container(
        color: AppColors.background,
        child: content,
      );
    }

    return content;
  }
}

/// Custom painter for the animated Eye with 3D cornea depth and glossy highlights.
class _SmoothEyePainter extends CustomPainter {
  final double eyeOpenProgress;
  final double pupilOffsetX;
  final double pupilOffsetY;

  _SmoothEyePainter({
    required this.eyeOpenProgress,
    required this.pupilOffsetX,
    required this.pupilOffsetY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final centerX = w / 2;
    final centerY = h / 2;

    // ── 1. Smooth Almond Eye Contour ──
    final eyePath = Path();
    eyePath.moveTo(0, centerY);

    // Upper lid curve
    eyePath.cubicTo(
      w * 0.28,
      centerY - (h * 0.52 * eyeOpenProgress),
      w * 0.72,
      centerY - (h * 0.52 * eyeOpenProgress),
      w,
      centerY,
    );

    // Lower lid curve
    eyePath.cubicTo(
      w * 0.72,
      centerY + (h * 0.52 * eyeOpenProgress),
      w * 0.28,
      centerY + (h * 0.52 * eyeOpenProgress),
      0,
      centerY,
    );
    eyePath.close();

    // Sclera (White eye background with subtle ambient depth)
    final scleraPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Colors.white, Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
        stops: [0.6, 0.88, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(eyePath, scleraPaint);

    // ── 2. Clip Iris & Cornea inside Eyelids ──
    canvas.save();
    canvas.clipPath(eyePath);

    if (eyeOpenProgress > 0.05) {
      final irisRadius = h * 0.39;
      final maxShiftX = w * 0.17;
      final maxShiftY = h * 0.09;

      final currentPupilX = centerX + (pupilOffsetX * maxShiftX);
      final currentPupilY = centerY + (pupilOffsetY * maxShiftY);
      final pupilCenter = Offset(currentPupilX, currentPupilY);

      // Iris Outer Glow Ring
      final irisGlow = Paint()
        ..color = const Color(0xFF06B6D4).withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(pupilCenter, irisRadius + 2, irisGlow);

      // Iris Gradient (Vibrant Spectral Rainbow Ring)
      final irisPaint = Paint()
        ..shader = const SweepGradient(
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
        ).createShader(Rect.fromCircle(center: pupilCenter, radius: irisRadius));
      canvas.drawCircle(pupilCenter, irisRadius, irisPaint);

      // Pupil (Center Core)
      final pupilPaint = Paint()..color = const Color(0xFF020617);
      canvas.drawCircle(pupilCenter, irisRadius * 0.46, pupilPaint);

      // Inner Pupil Cyan Core Ring
      final pupilCoreRing = Paint()
        ..color = const Color(0xFF22D3EE).withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      canvas.drawCircle(pupilCenter, irisRadius * 0.32, pupilCoreRing);

      // Glossy Specular Highlights (Moves subtly with gaze for 3D realism)
      final mainHighlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.95);
      canvas.drawCircle(
        Offset(currentPupilX - irisRadius * 0.28, currentPupilY - irisRadius * 0.28),
        irisRadius * 0.18,
        mainHighlightPaint,
      );

      final secHighlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.75);
      canvas.drawCircle(
        Offset(currentPupilX + irisRadius * 0.25, currentPupilY + irisRadius * 0.22),
        irisRadius * 0.10,
        secHighlightPaint,
      );
    }

    canvas.restore();

    // ── 3. Outer Eyelid Border with Gradient ──
    final borderPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF06B6D4), Color(0xFF0891B2), Color(0xFF0E7490)],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(eyePath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _SmoothEyePainter oldDelegate) =>
      oldDelegate.eyeOpenProgress != eyeOpenProgress ||
      oldDelegate.pupilOffsetX != pupilOffsetX ||
      oldDelegate.pupilOffsetY != pupilOffsetY;
}

/// Custom painter for the futuristic rotating optical HUD scanner.
class _HudScannerPainter extends CustomPainter {
  final Color color;
  final Color accentColor;

  _HudScannerPainter({required this.color, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Segmented scanner arcs
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      math.pi * 0.45,
      false,
      arcPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.65,
      math.pi * 0.55,
      false,
      arcPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 1.35,
      math.pi * 0.48,
      false,
      arcPaint,
    );

    // Glowing accent dots at arc tips
    final dotPaint = Paint()..color = accentColor;
    final dotRadius = 3.0;

    final dot1 = Offset(
      center.dx + radius * math.cos(0),
      center.dy + radius * math.sin(0),
    );
    final dot2 = Offset(
      center.dx + radius * math.cos(math.pi * 0.65),
      center.dy + radius * math.sin(math.pi * 0.65),
    );
    final dot3 = Offset(
      center.dx + radius * math.cos(math.pi * 1.35),
      center.dy + radius * math.sin(math.pi * 1.35),
    );

    canvas.drawCircle(dot1, dotRadius, dotPaint);
    canvas.drawCircle(dot2, dotRadius, dotPaint);
    canvas.drawCircle(dot3, dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _HudScannerPainter oldDelegate) => false;
}

/// Custom painter for inner technical reticle dots.
class _InnerReticlePainter extends CustomPainter {
  final Color color;

  _InnerReticlePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final tickPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const totalTicks = 12;
    for (int i = 0; i < totalTicks; i++) {
      final angle = (i * 2 * math.pi) / totalTicks;
      final inner = Offset(
        center.dx + (radius - 5) * math.cos(angle),
        center.dy + (radius - 5) * math.sin(angle),
      );
      final outer = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(inner, outer, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _InnerReticlePainter oldDelegate) => false;
}
