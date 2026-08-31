import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/section_navigator.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/scroll_reveal.dart';
import '../booking/booking_modal.dart';

/// Data model for an About Us core value pillar with animated stats.
class _PillarData {
  final FaIconData icon;
  final String title;
  final String description;
  final Color accentColor;
  final double statValue;
  final String statSuffix;
  final int statDecimals;

  const _PillarData({
    required this.icon,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.statValue,
    this.statSuffix = '',
    this.statDecimals = 0,
  });
}

/// Section — About Us & Why Choose Rainbow Eye Hospital.
/// 
/// Engineering Highlights:
/// - 60/120 FPS Hardware-accelerated transforms & opacity transitions.
/// - Scroll-triggered staggered entrance animations.
/// - Interactive hover cards with 1.025x scale, border glow & elevation.
/// - Smooth count-up number tickers for hospital metrics.
/// - Subtle animated ambient mesh background accents.
/// - 100% responsive for Mobile, Tablet, and Desktop.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  static const _pillars = [
    _PillarData(
      icon: FontAwesomeIcons.userDoctor,
      title: 'AIIMS & Super Specialists',
      description: 'Fellowship-trained eye surgeons with 25+ years combined clinical excellence.',
      accentColor: AppColors.primary,
      statValue: 50,
      statSuffix: '+',
    ),
    _PillarData(
      icon: FontAwesomeIcons.bolt,
      title: '100% Blade-Free Lasers',
      description: 'German Carl Zeiss & Contoura Vision systems for painless, 10-min recovery.',
      accentColor: AppColors.accent,
      statValue: 10,
      statSuffix: ' Min',
    ),
    _PillarData(
      icon: FontAwesomeIcons.shieldHeart,
      title: 'Personalized Care Plans',
      description: '20-point digital corneal profiling customized to your unique eye anatomy.',
      accentColor: Color(0xFF0D9488),
      statValue: 20,
      statSuffix: '-Pt',
    ),
    _PillarData(
      icon: FontAwesomeIcons.award,
      title: 'Clinical Success Rate',
      description: 'NABH-accredited sterile OT suites with over 1,00,000+ restored visions.',
      accentColor: Color(0xFF8B5CF6),
      statValue: 99.8,
      statSuffix: '%',
      statDecimals: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1080;
    final isMobile = screenWidth < 650;

    return Container(
      key: SectionNavigator.aboutKey,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.divider.withValues(alpha: 0.6)),
        ),
      ),
      child: Stack(
        children: [
          // ── 1. Subtle Animated Ambient Mesh Accents ──
          const Positioned.fill(
            child: _AnimatedAmbientBackdrop(),
          ),

          // ── 2. Main Responsive Content ──
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1320),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? 32 : 56,
                  horizontal: ResponsiveHelper.horizontalPadding(context),
                ),
                child: isDesktop
                    ? const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Left: Interactive Visual Showcase & Floating Stat Badges
                          Expanded(
                            flex: 5,
                            child: _AboutVisualShowcase(),
                          ),
                          SizedBox(width: 48),

                          // Right: Brand Narrative, Staggered Pillars & Actions
                          Expanded(
                            flex: 6,
                            child: _AboutContentBlock(pillars: _pillars),
                          ),
                        ],
                      )
                    : const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Visual Showcase on Top for Mobile/Tablet
                          _AboutVisualShowcase(),
                          SizedBox(height: 28),

                          // Narrative & Value Cards Below
                          _AboutContentBlock(pillars: _pillars),
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

/// Subtle, lightweight animated ambient mesh gradient background.
class _AnimatedAmbientBackdrop extends StatefulWidget {
  const _AnimatedAmbientBackdrop();

  @override
  State<_AnimatedAmbientBackdrop> createState() => _AnimatedAmbientBackdropState();
}

class _AnimatedAmbientBackdropState extends State<_AnimatedAmbientBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
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
        final progress = _controller.value;
        return CustomPaint(
          painter: _AmbientMeshPainter(progress: progress),
          size: Size.infinite,
        );
      },
    );
  }
}

class _AmbientMeshPainter extends CustomPainter {
  final double progress;

  _AmbientMeshPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;

    // Orb 1 — Top Left Teal Glow
    final offset1 = Offset(
      size.width * 0.12 + (math.sin(progress * math.pi) * 25),
      size.height * 0.25 + (math.cos(progress * math.pi) * 20),
    );
    final paint1 = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.primaryLight.withValues(alpha: 0.10 + (progress * 0.04)),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: offset1, radius: 240));

    canvas.drawCircle(offset1, 240, paint1);

    // Orb 2 — Bottom Right Amber/Cyan Tint
    final offset2 = Offset(
      size.width * 0.88 - (math.cos(progress * math.pi) * 30),
      size.height * 0.75 - (math.sin(progress * math.pi) * 25),
    );
    final paint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accentLight.withValues(alpha: 0.08 + ((1 - progress) * 0.03)),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: offset2, radius: 220));

    canvas.drawCircle(offset2, 220, paint2);
  }

  @override
  bool shouldRepaint(covariant _AmbientMeshPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Left Column: Layered visual showcase with high-res hospital suite image
/// and floating micro-animated experience & technology badge cards.
class _AboutVisualShowcase extends StatelessWidget {
  const _AboutVisualShowcase();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 650;
    final imageHeight = isMobile ? 320.0 : 470.0;

    return ScrollReveal(
      slideOffset: 0.08,
      duration: const Duration(milliseconds: 800),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isMobile ? 460 : 540),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── 1. Main High-Res Hospital Clinical Suite Image Card ──
              Container(
                height: imageHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.14),
                      blurRadius: 36,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/hero_slide_3.jpg',
                        fit: BoxFit.cover,
                      ),
                      // Gradient Depth Scrim
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.secondary.withValues(alpha: 0.40),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── 2. Floating Experience Badge Card (Top Right) ──
              Positioned(
                top: isMobile ? 14 : 22,
                right: isMobile ? -8 : -18,
                child: const _FloatingInteractiveBadge(
                  icon: FontAwesomeIcons.solidStar,
                  iconColor: Color(0xFFF59E0B),
                  statValue: 25,
                  statSuffix: '+ Years',
                  subtitle: 'Excellence in Eye Care',
                  oscillationPhase: 0.0,
                ),
              ),

              // ── 3. Floating Technology Badge Card (Bottom Left) ──
              Positioned(
                bottom: isMobile ? 16 : 24,
                left: isMobile ? -8 : -18,
                child: const _FloatingInteractiveBadge(
                  icon: FontAwesomeIcons.bolt,
                  iconColor: AppColors.primary,
                  statValue: 100,
                  statSuffix: '% Blade-Free',
                  subtitle: 'German Zeiss Lasers',
                  oscillationPhase: math.pi,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Floating badge pill with continuous gentle levitation, count-up stat, and hover reaction.
class _FloatingInteractiveBadge extends StatefulWidget {
  final FaIconData icon;
  final Color iconColor;
  final double statValue;
  final String statSuffix;
  final String subtitle;
  final double oscillationPhase;

  const _FloatingInteractiveBadge({
    required this.icon,
    required this.iconColor,
    required this.statValue,
    required this.statSuffix,
    required this.subtitle,
    this.oscillationPhase = 0.0,
  });

  @override
  State<_FloatingInteractiveBadge> createState() => _FloatingInteractiveBadgeState();
}

class _FloatingInteractiveBadgeState extends State<_FloatingInteractiveBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final floatOffset = math.sin((_floatController.value * math.pi * 2) + widget.oscillationPhase) * 4.0;
        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: child,
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? widget.iconColor.withValues(alpha: 0.5)
                  : AppColors.primaryLight.withValues(alpha: 0.25),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.iconColor.withValues(alpha: _isHovered ? 0.22 : 0.10),
                blurRadius: _isHovered ? 24 : 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.iconColor.withValues(alpha: 0.12),
                ),
                child: FaIcon(
                  widget.icon,
                  size: 13,
                  color: widget.iconColor,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _AnimatedCountUpTicker(
                    targetValue: widget.statValue,
                    suffix: widget.statSuffix,
                    textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Right Column: Eyebrow, Headline, Story Narrative, 2x2 Staggered Pillars Grid & Action Buttons.
class _AboutContentBlock extends StatelessWidget {
  final List<_PillarData> pillars;

  const _AboutContentBlock({required this.pillars});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1080;
    final isMobile = screenWidth < 650;

    return Column(
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        // ── 1. Eyebrow Tag (Scroll-triggered) ──
        ScrollReveal(
          slideOffset: 0.08,
          delay: const Duration(milliseconds: 100),
          duration: const Duration(milliseconds: 750),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryLight.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(
                  FontAwesomeIcons.hospital,
                  size: 11,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 7),
                Text(
                  'ABOUT RAINBOW EYE HOSPITAL',
                  style: AppTypography.sectionEyebrow(
                    color: AppColors.primary,
                    fontSize: isMobile ? 11 : 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── 2. Headline (Scroll-triggered) ──
        ScrollReveal(
          slideOffset: 0.08,
          delay: const Duration(milliseconds: 180),
          duration: const Duration(milliseconds: 800),
          child: Text(
            'Pioneering Advanced Vision Care With Compassion & German Precision',
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.25,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── 3. Narrative Story (Scroll-triggered) ──
        ScrollReveal(
          slideOffset: 0.08,
          delay: const Duration(milliseconds: 260),
          duration: const Duration(milliseconds: 800),
          child: Text(
            'Founded with a commitment to deliver super-specialty eye care to Visakhapatnam and coastal Andhra Pradesh, Rainbow Eye Hospital brings together AIIMS-trained ophthalmologists, NABH-accredited surgical theaters, and German Carl Zeiss laser suites.\n\nOver the past 25+ years, we have successfully restored vision for over 1,00,000+ patients across LASIK, micro-incision cataracts, glaucoma, retina, and pediatric ophthalmology with personalized clinical care.',
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 13.5 : 15,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.65,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ── 4. Core Pillars (Staggered 2x2 Interactive Grid) ──
        _PillarsGrid(pillars: pillars),
        const SizedBox(height: 20),

        // ── 5. Action CTA Row (Scroll-triggered) ──
        ScrollReveal(
          slideOffset: 0.08,
          delay: const Duration(milliseconds: 650),
          duration: const Duration(milliseconds: 800),
          child: Wrap(
            spacing: 14,
            runSpacing: 12,
            alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
            children: [
              AppButton(
                label: 'Book Consultation',
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
                onPressed: () => showBookingDialog(context),
              ),
              AppButton(
                label: 'Meet Our Specialists',
                isOutlined: true,
                outlinedColor: AppColors.primary,
                showArrow: false,
                icon: FontAwesomeIcons.userDoctor,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                onPressed: () => SectionNavigator.scrollTo(SectionNavigator.doctorsKey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 2x2 Grid of interactive value pillars with staggered entrance animations.
class _PillarsGrid extends StatelessWidget {
  final List<_PillarData> pillars;

  const _PillarsGrid({required this.pillars});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 700;

    if (isMobile) {
      return Column(
        children: List.generate(
          pillars.length,
          (index) => ScrollReveal(
            slideOffset: 0.08,
            delay: Duration(milliseconds: 320 + (index * 80)),
            duration: const Duration(milliseconds: 700),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _InteractivePillarCard(data: pillars[index]),
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        mainAxisExtent: 124,
      ),
      itemCount: pillars.length,
      itemBuilder: (context, index) {
        return ScrollReveal(
          slideOffset: 0.08,
          delay: Duration(milliseconds: 320 + (index * 90)),
          duration: const Duration(milliseconds: 700),
          child: _InteractivePillarCard(data: pillars[index]),
        );
      },
    );
  }
}

/// A single interactive pillar card with 1.025x scale, border glow, elevation, and count-up stat.
class _InteractivePillarCard extends StatefulWidget {
  final _PillarData data;

  const _InteractivePillarCard({required this.data});

  @override
  State<_InteractivePillarCard> createState() => _InteractivePillarCardState();
}

class _InteractivePillarCardState extends State<_InteractivePillarCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isActive = _isHovered || _isPressed;
    final scaleValue = _isPressed ? 0.975 : (_isHovered ? 1.025 : 1.0);
    final yOffset = _isPressed ? 0.0 : (_isHovered ? -3.0 : 0.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.diagonal3Values(scaleValue, scaleValue, 1.0)
            ..setTranslationRaw(0.0, yOffset, 0.0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive
                ? widget.data.accentColor.withValues(alpha: 0.04)
                : AppColors.background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive
                  ? widget.data.accentColor.withValues(alpha: 0.45)
                  : AppColors.divider,
              width: isActive ? 1.2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? widget.data.accentColor.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.02),
                blurRadius: isActive ? 16 : 6,
                offset: Offset(0, isActive ? 5 : 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon container with micro-pulse background
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: widget.data.accentColor.withValues(alpha: isActive ? 0.18 : 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FaIcon(
                  widget.data.icon,
                  size: 14,
                  color: widget.data.accentColor,
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 2,
                      children: [
                        Text(
                          widget.data.title,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        // Animated Count-Up Metric Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: widget.data.accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: _AnimatedCountUpTicker(
                            targetValue: widget.data.statValue,
                            suffix: widget.data.statSuffix,
                            decimals: widget.data.statDecimals,
                            textStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: widget.data.accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.data.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// High-performance number count-up ticker with smooth easing.
class _AnimatedCountUpTicker extends StatelessWidget {
  final double targetValue;
  final String suffix;
  final int decimals;
  final TextStyle? textStyle;

  const _AnimatedCountUpTicker({
    required this.targetValue,
    this.suffix = '',
    this.decimals = 0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: targetValue),
      duration: const Duration(milliseconds: 1600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final formatted = decimals > 0
            ? value.toStringAsFixed(decimals)
            : value.toInt().toString();
        return Text(
          '$formatted$suffix',
          style: textStyle,
        );
      },
    );
  }
}
