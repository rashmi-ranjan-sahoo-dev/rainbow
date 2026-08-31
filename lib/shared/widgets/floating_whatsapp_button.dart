import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/section_navigator.dart';

/// Sticky Floating Action Buttons Overlay (WhatsApp CTA + Beautiful Animated Scroll-To-Top Button)
/// positioned at the bottom-right corner of the viewport across all devices.
class FloatingWhatsAppButton extends StatefulWidget {
  const FloatingWhatsAppButton({super.key});

  @override
  State<FloatingWhatsAppButton> createState() => _FloatingWhatsAppButtonState();
}

class _FloatingWhatsAppButtonState extends State<FloatingWhatsAppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  bool _isWhatsAppHovered = false;

  static const String _directWhatsAppUrl =
      'https://wa.me/918341104525?text=Hi%20Sir%2C%20Is%20appointment%20available%20for%20eye%20checkup%3F';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: false);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOutQuad),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleWhatsAppTap() async {
    final uri = Uri.parse(_directWhatsAppUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 700;

    return Positioned(
      bottom: isMobile ? 16 : 22,
      right: isMobile ? 16 : 22,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── 1. Beautiful Animated Scroll-To-Top Button (Upper / Above WhatsApp CTA) ──
          _BeautifulScrollToTopButton(isMobile: isMobile),

          SizedBox(height: isMobile ? 12 : 14),

          // ── 2. Floating WhatsApp CTA Button (Below Up Button) ──
          MouseRegion(
            onEnter: (_) => setState(() => _isWhatsAppHovered = true),
            onExit: (_) => setState(() => _isWhatsAppHovered = false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _handleWhatsAppTap,
              child: AnimatedScale(
                scale: _isWhatsAppHovered ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // "Chat with us" pill on desktop / tablet
                    if (!isMobile) ...[
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF25D366).withValues(alpha: 0.35),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.10),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Chat with us',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: Color(0xFF25D366),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],

                    // Circular WhatsApp Pulse & Icon Button
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer Pulse Glow
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            final opacity = (1.0 - _pulseController.value).clamp(0.0, 1.0);
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                width: isMobile ? 52 : 58,
                                height: isMobile ? 52 : 58,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF25D366).withValues(alpha: opacity * 0.45),
                                ),
                              ),
                            );
                          },
                        ),

                        // Main WhatsApp Button
                        Container(
                          width: isMobile ? 52 : 58,
                          height: isMobile ? 52 : 58,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF25D366),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF25D366).withValues(alpha: 0.45),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.whatsapp,
                              size: isMobile ? 26 : 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A Beautiful, Highly-Animated Floating Scroll-To-Top Button (↑)
/// Features:
/// - Cyan/Teal Brand Gradient with Glass Highlight
/// - Upward Arrow Float / Bob Animation
/// - Concentric Aura Pulse Glow
/// - Hover Scale Rebound & Elevation Shift
/// - Haptic Spring Tap Animation
class _BeautifulScrollToTopButton extends StatefulWidget {
  final bool isMobile;

  const _BeautifulScrollToTopButton({required this.isMobile});

  @override
  State<_BeautifulScrollToTopButton> createState() => _BeautifulScrollToTopButtonState();
}

class _BeautifulScrollToTopButtonState extends State<_BeautifulScrollToTopButton>
    with TickerProviderStateMixin {
  late final AnimationController _bobController;
  late final Animation<double> _arrowBobAnimation;

  late final AnimationController _auraController;
  late final Animation<double> _auraScaleAnimation;
  late final Animation<double> _auraOpacityAnimation;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    // 1. Continuous Upward Arrow Bobbing Animation (Floating Motion)
    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _arrowBobAnimation = Tween<double>(begin: 0.0, end: -3.8).animate(
      CurvedAnimation(parent: _bobController, curve: Curves.easeInOutSine),
    );

    // 2. Concentric Aura Pulse Animation
    _auraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: false);

    _auraScaleAnimation = Tween<double>(begin: 1.0, end: 1.42).animate(
      CurvedAnimation(parent: _auraController, curve: Curves.easeOutCubic),
    );

    _auraOpacityAnimation = Tween<double>(begin: 0.40, end: 0.0).animate(
      CurvedAnimation(parent: _auraController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _bobController.dispose();
    _auraController.dispose();
    super.dispose();
  }

  void _handleScrollToTop() {
    if (SectionNavigator.heroKey.currentContext != null) {
      SectionNavigator.scrollTo(SectionNavigator.heroKey);
    } else {
      try {
        final scrollable = Scrollable.maybeOf(context);
        if (scrollable != null) {
          scrollable.position.animateTo(
            0,
            duration: const Duration(milliseconds: 750),
            curve: Curves.easeInOutCubic,
          );
        }
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final double buttonSize = widget.isMobile ? 46.0 : 50.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: 'Scroll to Top',
        preferBelow: false,
        verticalOffset: 28,
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: _handleScrollToTop,
          child: AnimatedScale(
            scale: _isPressed ? 0.90 : (_isHovered ? 1.12 : 1.0),
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutBack,
            child: Container(
              margin: EdgeInsets.only(
                right: widget.isMobile ? 3 : 4, // Aligns with the center of the WhatsApp circle
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // ── A. Glowing Concentric Aura Ring ──
                  AnimatedBuilder(
                    animation: _auraController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _auraScaleAnimation.value,
                        child: Container(
                          width: buttonSize,
                          height: buttonSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(
                              alpha: (_isHovered ? 0.55 : 0.35) * _auraOpacityAnimation.value,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // ── B. Core Animated Circular Gradient Button ──
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _isHovered
                            ? const [
                                Color(0xFF00E5FF), // Electric Cyan glow
                                Color(0xFF0891B2), // Primary Cyan
                                Color(0xFF0E7490), // Deep Teal
                              ]
                            : const [
                                Color(0xFF06B6D4), // Cyan 500
                                Color(0xFF0891B2), // Primary
                                Color(0xFF0F766E), // Teal 700
                              ],
                      ),
                      border: Border.all(
                        color: _isHovered
                            ? Colors.white
                            : const Color(0xFF22D3EE).withValues(alpha: 0.6),
                        width: _isHovered ? 1.8 : 1.2,
                      ),
                      boxShadow: [
                        // Soft primary cyan ambient glow
                        BoxShadow(
                          color: (_isHovered ? const Color(0xFF00E5FF) : AppColors.primary)
                              .withValues(alpha: _isHovered ? 0.55 : 0.35),
                          blurRadius: _isHovered ? 20 : 12,
                          offset: Offset(0, _isHovered ? 6 : 3),
                        ),
                        // Dark elevation depth
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glass specular highlight on top rim
                        Positioned(
                          top: 2,
                          left: buttonSize * 0.20,
                          right: buttonSize * 0.20,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        // Animated Up Arrow with continuous vertical bobbing motion
                        AnimatedBuilder(
                          animation: _arrowBobAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                0,
                                _isHovered
                                    ? _arrowBobAnimation.value - 2.0
                                    : _arrowBobAnimation.value,
                              ),
                              child: child,
                            );
                          },
                          child: Icon(
                            Icons.keyboard_arrow_up_rounded,
                            size: widget.isMobile ? 28 : 32,
                            color: Colors.white,
                            shadows: const [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 1.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
