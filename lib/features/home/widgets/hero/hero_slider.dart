import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/section_navigator.dart';
import '../../../symptom_checker/widgets/vision_deck_modal.dart';
import '../booking/booking_modal.dart';

/// Data model for each Hero Slide.
class HeroSlideData {
  final String eyebrow;
  final FaIconData eyebrowIcon;
  final String headline;
  final String? headlineHighlight;
  final Color? headlineHighlightColor;
  final String subtext;
  final String? subtextHighlight;
  final Color? subtextHighlightColor;
  final String photoAsset;
  final List<String>? featureTags;
  final String cta2Text;
  final IconData cta2Icon;
  final Alignment imageAlignment;
  final Alignment mobileImageAlignment;

  const HeroSlideData({
    required this.eyebrow,
    this.eyebrowIcon = FontAwesomeIcons.eye,
    required this.headline,
    this.headlineHighlight,
    this.headlineHighlightColor,
    required this.subtext,
    this.subtextHighlight,
    this.subtextHighlightColor,
    required this.photoAsset,
    this.featureTags,
    this.cta2Text = 'Book Appointment',
    this.cta2Icon = Icons.calendar_month_rounded,
    this.imageAlignment = const Alignment(0.40, -0.45),
    this.mobileImageAlignment = const Alignment(0.20, -0.55),
  });
}

/// Section 3 — Infinite forward-scrolling hero carousel with auto-play,
/// full-width background images, right-aligned people, left-aligned ultra-crisp white text,
/// clean cards without extra tags (except Health Insurance), and 2 CTA buttons.
class HeroSlider extends StatefulWidget {
  const HeroSlider({super.key});

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  static const int _virtualMultiplier = 1000;

  static const _slides = [
    // Slide 1 — Cataract Awareness (Elderly Couple in Hospital Corridor)
    HeroSlideData(
      eyebrow: 'CATARACT CARE & PREVENTION',
      headline: "Your Parents gave you the best, now it's your turn.",
      subtext: "Don't let Cataracts slow them down.",
      subtextHighlight: 'Cataracts',
      subtextHighlightColor: Color(0xFFF87171), // Bright Coral Red
      photoAsset: 'assets/images/hero_slide_1.jpg',
      imageAlignment: Alignment(0.48, -0.60), // Perfectly frames the smiling couple's full heads & corridor
      mobileImageAlignment: Alignment(0.30, -0.65),
      featureTags: null,
    ),
    // Slide 2 — Glaucoma Care & Laser Therapy (The Silent Thief of Sight)
    HeroSlideData(
      eyebrow: 'GLAUCOMA CARE & LASER THERAPY',
      eyebrowIcon: FontAwesomeIcons.shieldHalved,
      headline: "Your vision shouldn't fade in silence, protect tomorrow today.",
      headlineHighlight: 'protect tomorrow today.',
      headlineHighlightColor: Color(0xFF38BDF8), // Vibrant Sky Cyan
      subtext: "Don’t let Silent Glaucoma steal your peripheral sight unnoticed.",
      subtextHighlight: 'Silent Glaucoma',
      subtextHighlightColor: Color(0xFFF87171), // Coral Red Warning
      photoAsset: 'assets/images/hero_slide_2.jpg',
      imageAlignment: Alignment(0.35, -0.50), // High-tech slit-lamp, doctor, patient & retina display
      mobileImageAlignment: Alignment(0.15, -0.55), // Doctor & patient faces, heads, and machine 100% in-frame
      featureTags: null,
    ),
    // Slide 3 — LASIK & Contoura Vision (Specs-Free Lifestyle)
    HeroSlideData(
      eyebrow: 'LASIK & CONTOURA VISION',
      eyebrowIcon: FontAwesomeIcons.wandMagicSparkles,
      headline: 'Your life is meant to be lived unfiltered, free from heavy frames.',
      headlineHighlight: 'free from heavy frames.',
      headlineHighlightColor: Color(0xFF34D399), // Radiant Mint Emerald
      subtext: 'Say goodbye to Spectacle Dependence with custom HD laser precision.',
      subtextHighlight: 'Spectacle Dependence',
      subtextHighlightColor: Color(0xFFFBBF24), // Amber Gold
      photoAsset: 'assets/images/hero_slide_3.jpg',
      imageAlignment: Alignment(0.42, -0.45), // Smiling woman holding glasses & laser suite on right
      mobileImageAlignment: Alignment(0.35, -0.55), // Full portrait view of smiling woman with glasses
      featureTags: null,
    ),
    // Slide 4 — Diabetic Eye Care & Retinal Laser Therapy (Family Protection)
    HeroSlideData(
      eyebrow: 'DIABETIC RETINOPATHY & RETINAL CARE',
      eyebrowIcon: FontAwesomeIcons.stethoscope,
      headline: "Managing diabetes is tough, keeping your sight shouldn't be.",
      headlineHighlight: "keeping your sight shouldn't be.",
      headlineHighlightColor: Color(0xFF38BDF8), // Vibrant Sky Cyan
      subtext: "Don’t let Diabetic Retinopathy weaken your vision without warning.",
      subtextHighlight: 'Diabetic Retinopathy',
      subtextHighlightColor: Color(0xFFF87171), // Coral Red Warning
      photoAsset: 'assets/images/hero_slide_4.jpg',
      imageAlignment: Alignment(0.40, -0.45), // Happy elderly uncle wearing glasses enjoying tea on sunlit veranda
      mobileImageAlignment: Alignment(0.40, -0.55), // Full view of smiling senior wearing glasses with restored sight
      featureTags: null,
    ),
    // Slide 5 — Health Insurance & Cashless Treatment (Insurance Desk)
    HeroSlideData(
      eyebrow: 'HEALTH INSURANCE',
      eyebrowIcon: FontAwesomeIcons.shieldHalved,
      headline: 'Your Vision,\nFully Covered.',
      headlineHighlight: 'Fully Covered.',
      headlineHighlightColor: Color(0xFF38BDF8), // Vibrant Sky Cyan
      subtext:
          'Cashless hospitalization & hassle-free claims with all major insurance providers.',
      photoAsset: 'assets/images/hero_slide_5.jpg',
      imageAlignment: Alignment(0.22, -0.36), // Balanced view on desktop & tablet
      mobileImageAlignment: Alignment(0.20, -0.55), // Centers both patient and coordinator with heads completely in-frame!
      cta2Text: 'Check Insurance Coverage',
      cta2Icon: Icons.verified_user_rounded,
      featureTags: [
        'Star Health',
        'HDFC ERGO',
        'ICICI Lombard',
        'Care Health',
        'Niva Bupa',
        'Bajaj Allianz',
      ],
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

    // Responsive container height - generous vertical proportions avoid letterboxing & head clipping
    double heroHeight;
    if (isMobile) {
      heroHeight = 640;
    } else if (isTablet) {
      heroHeight = 580;
    } else {
      heroHeight = 600;
    }

    final activeSlideIndex = _currentRealPage % _slides.length;

    return Container(
      key: SectionNavigator.heroKey,
      width: screenWidth,
      height: heroHeight,
      color: Colors.black, // Sleek dark baseline
      child: MouseRegion(
        onEnter: (_) => _stopAutoPlay(),
        onExit: (_) => _startAutoPlay(),
        child: GestureDetector(
          onPanDown: (_) => _stopAutoPlay(),
          onPanEnd: (_) => _startAutoPlay(),
          onPanCancel: () => _startAutoPlay(),
          child: Stack(
            children: [
              // ── Main Slide Carousel (5 Slides Dynamic Loop) ──
              PageView.builder(
                controller: _pageController,
                itemCount: null, // Infinite loop
                onPageChanged: (index) {
                  setState(() => _currentRealPage = index);
                },
                itemBuilder: (context, index) {
                  final slideData = _slides[index % _slides.length];
                  return _HeroSeamlessSlide(
                    data: slideData,
                    isActive: (index % _slides.length) == activeSlideIndex,
                  );
                },
              ),

              // ── Left Arrow Control (Desktop only) ──
              if (screenWidth >= 1024)
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

              // ── Right Arrow Control (Desktop only) ──
              if (screenWidth >= 1024)
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

              // ── Synchronized 5-Dot Dynamic Indicators ──
              Positioned(
                bottom: isMobile ? 10 : 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(_slides.length, (dotIndex) {
                        final isActive = dotIndex == activeSlideIndex;
                        return GestureDetector(
                          onTap: () {
                            final currentVirtual =
                                _currentRealPage % _slides.length;
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
                            margin: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            height: 7,
                            width: isActive ? 26 : 7,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.primaryLight
                                  : Colors.white38,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        );
                      }),
                    ),
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

/// A seamless full-background hero slide:
/// Full background image across the entire slide with people on the right,
/// 100% pure photographic contrast, and left-aligned ultra-crisp white text & 2 CTA buttons.
class _HeroSeamlessSlide extends StatefulWidget {
  final HeroSlideData data;
  final bool isActive;

  const _HeroSeamlessSlide({required this.data, required this.isActive});

  @override
  State<_HeroSeamlessSlide> createState() => _HeroSeamlessSlideState();
}

class _HeroSeamlessSlideState extends State<_HeroSeamlessSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    if (widget.isActive) _animController.forward();
  }

  @override
  void didUpdateWidget(covariant _HeroSeamlessSlide oldWidget) {
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

  /// Builds high-contrast highlighted headline text with vibrant colored keywords and deep shadow definition
  Widget _buildHighlightedText({
    required String text,
    String? highlight,
    Color? highlightColor,
    required TextStyle baseStyle,
    TextAlign textAlign = TextAlign.start,
  }) {
    if (highlight == null || !text.contains(highlight)) {
      return Text(text, style: baseStyle, textAlign: textAlign);
    }

    final parts = text.split(highlight);
    final spans = <InlineSpan>[];
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(TextSpan(text: parts[i]));
      }
      if (i < parts.length - 1) {
        spans.add(
          TextSpan(
            text: highlight,
            style: TextStyle(
              color: highlightColor ?? AppColors.primaryLight,
              fontWeight: FontWeight.w900,
              shadows: baseStyle.shadows,
            ),
          ),
        );
      }
    }

    return Text.rich(
      TextSpan(style: baseStyle, children: spans),
      textAlign: textAlign,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    // Responsive Typography Sizes
    final double headlineSize = isMobile ? (screenWidth < 360 ? 20.0 : 23.0) : (isTablet ? 30.0 : 38.0);
    final double subtextSize = isMobile ? 13.5 : (isTablet ? 15.0 : 16.5);

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── 1. Full-Width Background Image with Tailored Focal Alignment ──
        Positioned.fill(
          child: Image.asset(
            widget.data.photoAsset,
            fit: BoxFit.cover,
            alignment: isMobile
                ? widget.data.mobileImageAlignment
                : widget.data.imageAlignment,
            filterQuality: FilterQuality.high,
          ),
        ),

        // ── 2. Light, Crystal-Clear Scrim: Minimal Tint (No Heavy Fog/Blur) ──
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: isMobile
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.40, 0.65, 1.0],
                      colors: [
                        Color(0x22050C16), // Barely-there top tint behind header
                        Colors.transparent, // 100% crystal clear over subject's face & scene
                        Color(0x35050C16), // Soft feather over desk
                        Color(0x85050C16), // Crisp contrast behind buttons
                      ],
                    )
                  : const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.0, 0.22, 0.40, 1.0],
                      colors: [
                        Color(0x5E050C16), // Gentle 37% tint at far left edge for text clarity
                        Color(0x2E050C16), // Soft 18% feather
                        Color(0x08050C16), // Barely 3% transition
                        Colors.transparent, // Completely crisp, vibrant, 100% transparent across the rest!
                      ],
                    ),
            ),
          ),
        ),

        // ── 3. Foreground Content (Ultra-Crisp White Text & 2 CTA Buttons on Left) ──
        Align(
          alignment: isMobile ? Alignment.bottomLeft : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: isMobile ? 20 : (isTablet ? 36 : 56),
              right: isMobile ? 20 : 32,
              top: isMobile ? 70 : (isTablet ? 80 : 92),
              bottom: isMobile ? 24 : 32,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isMobile
                    ? double.infinity
                    : (isTablet ? screenWidth * 0.48 : 520),
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Brand Tag / Eyebrow Badge (Dark frosted pill with teal icon for 100% clarity)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primaryLight.withValues(alpha: 0.50),
                            width: 1.0,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 4,
                              offset: Offset(0, 1.5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              widget.data.eyebrowIcon,
                              size: 12,
                              color: AppColors.primaryLight,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              widget.data.eyebrow,
                              style: TextStyle(
                                fontFamily: 'Orbitron',
                                fontWeight: FontWeight.w900,
                                fontSize: isMobile ? 11.5 : 13,
                                letterSpacing: 1.1,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isMobile ? 12 : 16),

                      // Headline (Brilliant pure white with sharp contrast, zero blurry haze)
                      _buildHighlightedText(
                        text: widget.data.headline,
                        highlight: widget.data.headlineHighlight,
                        highlightColor: widget.data.headlineHighlightColor,
                        baseStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w900,
                          fontSize: headlineSize,
                          height: 1.16,
                          color: Colors.white, // Brilliant pure white
                          letterSpacing: -0.6,
                          shadows: const [
                            Shadow(
                              color: Color(0xD9000000),
                              blurRadius: 4,
                              offset: Offset(0, 1.5),
                            ),
                            Shadow(
                              color: Color(0x80000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isMobile ? 8 : 12),

                      // Subtext (Clean bright off-white with crisp, tight shadow definition)
                      _buildHighlightedText(
                        text: widget.data.subtext,
                        highlight: widget.data.subtextHighlight,
                        highlightColor: widget.data.subtextHighlightColor,
                        baseStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: subtextSize,
                          height: 1.35,
                          color: const Color(0xFFF1F5F9), // Crisp off-white
                          shadows: const [
                            Shadow(
                              color: Color(0xD9000000),
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                            Shadow(
                              color: Color(0x80000000),
                              blurRadius: 6,
                              offset: Offset(0, 1.5),
                            ),
                          ],
                        ),
                      ),

                      // Feature / Insurance Provider Pills (Rendered only on Health Insurance Slide)
                      if (widget.data.featureTags != null) ...[
                        SizedBox(height: isMobile ? 8 : 16),
                        if (isMobile)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: widget.data.featureTags!.map((tag) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 3.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F172A).withValues(alpha: 0.90),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColors.primaryLight.withValues(alpha: 0.50),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryUltraLight,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        else
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: widget.data.featureTags!.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A).withValues(alpha: 0.90),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.primaryLight.withValues(alpha: 0.50),
                                    width: 1.0,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryUltraLight,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],

                      SizedBox(height: isMobile ? 10 : 24),

                      // ── 2 CTA Buttons (Lower of text) ──
                      if (isMobile)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _PulsatingSymptomCheckerButton(
                              isFullWidth: true,
                              onTap: () => showVisionDeckModal(context),
                            ),
                            const SizedBox(height: 8),
                            _BookAppointmentCtaButton(
                              isFullWidth: true,
                              text: widget.data.cta2Text,
                              icon: widget.data.cta2Icon,
                              onTap: () => showBookingDialog(context),
                            ),
                            const SizedBox(height: 24), // Spacing for bottom dots
                          ],
                        )
                      else
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _PulsatingSymptomCheckerButton(
                              isFullWidth: false,
                              onTap: () => showVisionDeckModal(context),
                            ),
                            const SizedBox(width: 12),
                            _BookAppointmentCtaButton(
                              isFullWidth: false,
                              text: widget.data.cta2Text,
                              icon: widget.data.cta2Icon,
                              onTap: () => showBookingDialog(context),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
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
            color: _isHovered ? AppColors.primary : const Color(0xFF0F172A).withValues(alpha: 0.85),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary
                  : Colors.white24,
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
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

/// Instant Symptom Checker CTA Button with pulsating primary brand gradient
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
    _glowAnimation = Tween<double>(begin: 2, end: 10).animate(
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _isHovered ? AppColors.primaryLight : AppColors.primary,
                    _isHovered ? AppColors.primary : AppColors.primaryDark,
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary
                        .withValues(alpha: _isHovered ? 0.55 : 0.35),
                    blurRadius: _glowAnimation.value + (_isHovered ? 4 : 0),
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.stethoscope,
                    size: 13,
                    color: AppColors.textWhite,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Instant Symptom Checker',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: AppColors.textWhite,
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

/// Secondary CTA Button (e.g. Book Appointment or Check Insurance Coverage)
class _BookAppointmentCtaButton extends StatefulWidget {
  final bool isFullWidth;
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _BookAppointmentCtaButton({
    required this.isFullWidth,
    this.text = 'Book Appointment',
    this.icon = Icons.calendar_month_rounded,
    required this.onTap,
  });

  @override
  State<_BookAppointmentCtaButton> createState() =>
      _BookAppointmentCtaButtonState();
}

class _BookAppointmentCtaButtonState extends State<_BookAppointmentCtaButton> {
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
          width: widget.isFullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.primaryDark
                : Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isHovered ? AppColors.primaryLight : Colors.white,
              width: 1.4,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: _isHovered
                    ? AppColors.textWhite
                    : AppColors.primaryDark,
              ),
              const SizedBox(width: 8),
              Text(
                widget.text,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: _isHovered
                      ? AppColors.textWhite
                      : AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
