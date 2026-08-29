import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/section_navigator.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../symptom_checker/widgets/vision_deck_modal.dart';
import '../booking/booking_modal.dart';

/// Data model for a single hero slide.
class HeroSlideData {
  final String eyebrow;
  final String headline;
  final String subtext;
  final String cta1;
  final String cta2;
  final String highlightBadge;
  final FaIconData highlightIcon;
  final String imageAsset;
  final Color gradientStart;
  final Color gradientEnd;

  const HeroSlideData({
    required this.eyebrow,
    required this.headline,
    required this.subtext,
    required this.cta1,
    required this.cta2,
    required this.highlightBadge,
    required this.highlightIcon,
    required this.imageAsset,
    this.gradientStart = const Color(0xFF0E7490),
    this.gradientEnd = const Color(0xFF1A1F36),
  });
}

/// Section 3 — Infinite forward-scrolling hero carousel with auto-play,
/// interactive dots, ambient orbs, and staggered entrance animations.
class HeroSlider extends StatefulWidget {
  const HeroSlider({super.key});

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  static const int _virtualMultiplier = 1000;
  static const _slides = [
    HeroSlideData(
      eyebrow: 'ADVANCED VISION CARE',
      headline: 'Your Vision Is\nOur Highest Mission',
      subtext:
          'Experience world-class eye care with state-of-the-art German technology\nand compassionate AIIMS-trained ophthalmologists.',
      cta1: 'Instant Symptom Checker',
      cta2: 'Book Appointment',
      highlightBadge: '100% Blade-Free Contoura LASIK',
      highlightIcon: FontAwesomeIcons.bolt,
      imageAsset: 'assets/images/hero_slide_1.jpg',
      gradientStart: Color(0xFF083344),
      gradientEnd: Color(0xFF0F172A),
    ),
    HeroSlideData(
      eyebrow: 'FELLOWSHIP SPECIALISTS',
      headline: 'Trusted By Thousands\nFor Clearer Vision',
      subtext:
          'Our multidisciplinary team of 50+ eye surgeons delivers tailored\nprecision care for every patient, every single day.',
      cta1: 'Instant Symptom Checker',
      cta2: 'Meet Our Doctors',
      highlightBadge: '99.8% Surgical Success Rate',
      highlightIcon: FontAwesomeIcons.award,
      imageAsset: 'assets/images/hero_slide_2.jpg',
      gradientStart: Color(0xFF1E293B),
      gradientEnd: Color(0xFF0E7490),
    ),
    HeroSlideData(
      eyebrow: 'PRECISION EYE SURGERY',
      headline: 'State-of-the-Art\nMicro-Cataract & Lasers',
      subtext:
          'Painless, stitch-less 10-minute laser procedures for rapid recovery\nand crystal clear vision restoration.',
      cta1: 'Instant Symptom Checker',
      cta2: 'Book Consultation',
      highlightBadge: 'Same-Day Walk-in Surgery',
      highlightIcon: FontAwesomeIcons.eye,
      imageAsset: 'assets/images/hero_slide_3.jpg',
      gradientStart: Color(0xFF134E4A),
      gradientEnd: Color(0xFF0B192C),
    ),
  ];

  late final int _initialPage;
  late final PageController _pageController;
  late int _currentRealPage;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _initialPage = _slides.length * _virtualMultiplier;
    _currentRealPage = _initialPage;
    _pageController = PageController(initialPage: _initialPage);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!mounted) return;
      _currentRealPage++;
      _pageController.animateToPage(
        _currentRealPage,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    double heroHeight;
    if (isMobile) {
      heroHeight = 610;
    } else if (isTablet) {
      heroHeight = 580;
    } else {
      heroHeight = 630;
    }

    final activeSlideIndex = _currentRealPage % _slides.length;

    return SizedBox(
      key: SectionNavigator.heroKey,
      width: screenWidth,
      height: heroHeight,
      child: MouseRegion(
        onEnter: (_) => _stopAutoPlay(),
        onExit: (_) => _startAutoPlay(),
        child: GestureDetector(
          onPanDown: (_) => _stopAutoPlay(),
          onPanEnd: (_) => _startAutoPlay(),
          onPanCancel: () => _startAutoPlay(),
          child: Stack(
            children: [
              // ── Infinite Slides ──
              PageView.builder(
                controller: _pageController,
                itemCount: null, // Infinite loop
                onPageChanged: (index) {
                  setState(() => _currentRealPage = index);
                },
                itemBuilder: (context, index) {
                  final slideData = _slides[index % _slides.length];
                  return _HeroSlide(
                    data: slideData,
                    isActive: (index % _slides.length) == activeSlideIndex,
                  );
                },
              ),

              // ── Left / Right Arrow Controls (Desktop only) ──
              if (screenWidth >= 1024) ...[
                Positioned(
                  left: 20,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _SliderArrowButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: () {
                        _currentRealPage--;
                        _pageController.animateToPage(
                          _currentRealPage,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutCubic,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _SliderArrowButton(
                      icon: Icons.chevron_right_rounded,
                      onTap: () {
                        _currentRealPage++;
                        _pageController.animateToPage(
                          _currentRealPage,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutCubic,
                        );
                      },
                    ),
                  ),
                ),
              ],

              // ── Infinite Synced Dot Indicators ──
              Positioned(
                bottom: isMobile ? 20 : 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_slides.length, (dotIndex) {
                      final isActive = dotIndex == activeSlideIndex;
                      return GestureDetector(
                        onTap: () {
                          final currentVirtual = _currentRealPage % _slides.length;
                          final diff = dotIndex - currentVirtual;
                          _currentRealPage += diff;
                          _pageController.animateToPage(
                            _currentRealPage,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubic,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: isActive ? 28 : 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primaryLight
                                : Colors.white.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: AppColors.primaryLight.withValues(alpha: 0.5),
                                      blurRadius: 6,
                                    ),
                                  ]
                                : [],
                          ),
                        ),
                      );
                    }),
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

/// A single hero slide with gradient background, floating animations, text, and CTA buttons.
class _HeroSlide extends StatefulWidget {
  final HeroSlideData data;
  final bool isActive;

  const _HeroSlide({required this.data, required this.isActive});

  @override
  State<_HeroSlide> createState() => _HeroSlideState();
}

class _HeroSlideState extends State<_HeroSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _badgeScaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _badgeScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    if (widget.isActive) _animController.forward();
  }

  @override
  void didUpdateWidget(covariant _HeroSlide oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _animController.reset();
      _animController.forward();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);

    // Responsive headline sizes
    double headlineSize;
    double subtextSize;
    if (isMobile) {
      headlineSize = 26;
      subtextSize = 13.5;
    } else if (isTablet) {
      headlineSize = 34;
      subtextSize = 15.5;
    } else {
      headlineSize = 44;
      subtextSize = 16.5;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [widget.data.gradientStart, widget.data.gradientEnd],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background Hospital Environment Image with 0.80 Opacity ──
          Positioned.fill(
            child: Opacity(
              opacity: 0.80,
              child: Image.asset(
                widget.data.imageAsset,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),

          // ── Floating Decorative Ambient Orbs ──
          const _AnimatedAmbientOrbs(),

          // ── Content ──
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1320),
              child: Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.horizontalPadding(context) + (isDesktop ? 20 : 0),
                  right: ResponsiveHelper.horizontalPadding(context) + (isDesktop ? 20 : 0),
                  top: isMobile ? 85 : (isTablet ? 85 : 90),
                  bottom: isMobile ? 25 : 30,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: isDesktop
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        // Eyebrow & Badge row
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          alignment: isDesktop
                              ? WrapAlignment.start
                              : WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // Eyebrow Tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primaryLight.withValues(alpha: 0.65),
                                  width: 1.2,
                                ),
                              ),
                              child: Text(
                                widget.data.eyebrow,
                                style: AppTypography.heroEyebrow.copyWith(
                                  fontSize: isMobile ? 11 : 12.5,
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            // Floating Highlight Badge
                            ScaleTransition(
                              scale: _badgeScaleAnimation,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(
                                      widget.data.highlightIcon,
                                      size: 11,
                                      color: AppColors.accentLight,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      widget.data.highlightBadge,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: isMobile ? 11 : 12,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withValues(alpha: 0.60),
                                            offset: const Offset(0, 1),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isMobile ? 14 : 20),

                        // Headline
                        SizedBox(
                          width: isDesktop
                              ? MediaQuery.sizeOf(context).width * 0.52
                              : null,
                          child: Text(
                            widget.data.headline,
                            textAlign:
                                isDesktop ? TextAlign.left : TextAlign.center,
                            style: AppTypography.heroHeadline(headlineSize),
                          ),
                        ),
                        SizedBox(height: isMobile ? 12 : 18),

                        // Subtext
                        SizedBox(
                          width: isDesktop
                              ? MediaQuery.sizeOf(context).width * 0.46
                              : null,
                          child: Text(
                            widget.data.subtext,
                            textAlign:
                                isDesktop ? TextAlign.left : TextAlign.center,
                            style: AppTypography.heroSubtext(subtextSize),
                          ),
                        ),
                        SizedBox(height: isMobile ? 20 : 28),

                        // CTA Buttons: Exactly 2 buttons (Instant Symptom Checker + Secondary Action)
                        if (isMobile)
                          Column(
                            children: [
                              _PulsatingSymptomCheckerButton(
                                isFullWidth: true,
                                onTap: () => showVisionDeckModal(context),
                              ),
                              const SizedBox(height: 10),
                              AppButton(
                                label: widget.data.cta2,
                                isOutlined: true,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 13,
                                ),
                                onPressed: () => _handleSecondaryCta(context, widget.data.cta2),
                              ),
                            ],
                          )
                        else
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: isDesktop
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.center,
                            children: [
                              _PulsatingSymptomCheckerButton(
                                isFullWidth: false,
                                onTap: () => showVisionDeckModal(context),
                              ),
                              const SizedBox(width: 14),
                              AppButton(
                                label: widget.data.cta2,
                                isOutlined: true,
                                onPressed: () => _handleSecondaryCta(context, widget.data.cta2),
                              ),
                            ],
                          ),

                        // Bottom spacer for indicators
                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSecondaryCta(BuildContext context, String label) {
    if (label.contains('Book') || label.contains('Consultation')) {
      showBookingDialog(context);
    } else if (label.contains('Doctor')) {
      SectionNavigator.scrollTo(SectionNavigator.doctorsKey);
    } else if (label.contains('Treatment') || label.contains('Services')) {
      SectionNavigator.scrollTo(SectionNavigator.servicesKey);
    } else {
      SectionNavigator.scrollTo(SectionNavigator.aboutKey);
    }
  }
}

/// Slider previous / next arrow button.
class _SliderArrowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SliderArrowButton({required this.icon, required this.onTap});

  @override
  State<_SliderArrowButton> createState() => _SliderArrowButtonState();
}

class _SliderArrowButtonState extends State<_SliderArrowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered
                ? AppColors.primary.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                    ),
                  ]
                : [],
          ),
          child: Icon(
            widget.icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}

/// Subtle animated ambient glowing orbs in the hero background.
class _AnimatedAmbientOrbs extends StatefulWidget {
  const _AnimatedAmbientOrbs();

  @override
  State<_AnimatedAmbientOrbs> createState() => _AnimatedAmbientOrbsState();
}

class _AnimatedAmbientOrbsState extends State<_AnimatedAmbientOrbs>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final val = _controller.value;
        return Stack(
          children: [
            // Top Right Orb
            Positioned(
              right: -60 + (val * 20),
              top: -60 + (val * 15),
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryLight.withValues(alpha: 0.08 + (val * 0.04)),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Left Orb
            Positioned(
              left: -50 - (val * 15),
              bottom: -60 + (val * 20),
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.07 + (val * 0.03)),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Middle Center Orb
            Positioned(
              right: 200 - (val * 30),
              bottom: 80 + (val * 20),
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accent.withValues(alpha: 0.04 + (val * 0.02)),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


/// Pulsating Symptom Checker Action Button
class _PulsatingSymptomCheckerButton extends StatefulWidget {
  final bool isFullWidth;
  final VoidCallback onTap;

  const _PulsatingSymptomCheckerButton({
    required this.isFullWidth,
    required this.onTap,
  });

  @override
  State<_PulsatingSymptomCheckerButton> createState() =>
      _PulsatingSymptomCheckerButtonState();
}

class _PulsatingSymptomCheckerButtonState
    extends State<_PulsatingSymptomCheckerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 4, end: 14).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.isFullWidth ? double.infinity : null,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(_isHovered ? 0xFF0891B2 : 0xFF0E7490),
                    Color(_isHovered ? 0xFF06B6D4 : 0xFF0891B2),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isHovered ? const Color(0xFFA5F3FC) : const Color(0xFF67E8F9),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0891B2).withValues(alpha: _isHovered ? 0.7 : 0.5),
                    blurRadius: _glowAnimation.value + (_isHovered ? 4 : 0),
                    spreadRadius: _isHovered ? 2 : 1,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.stethoscope,
                    size: 14,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Instant Symptom Checker',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
