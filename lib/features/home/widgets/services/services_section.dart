import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/section_navigator.dart';
import '../../../../shared/widgets/scroll_reveal.dart';
import '../booking/booking_modal.dart';

/// Data model for an Eye Care Service / Clinical Speciality.
class ServiceItem {
  final String id;
  final String title;
  final String category;
  final String description;
  final String fullDetails;
  final String imagePath;
  final FaIconData icon;
  final Color accentColor;
  final String? badge;
  final String hospitalBadge;
  final List<String> highlights;

  const ServiceItem({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.fullDetails,
    required this.imagePath,
    required this.icon,
    required this.accentColor,
    this.badge,
    this.hospitalBadge = 'Rainbow Super-Speciality',
    required this.highlights,
  });
}

/// Section 5 — Specialized Departments & Clinical Specialities (Interactive 3D Carousel Swiper).
class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection> {
  static const _allServices = [
    ServiceItem(
      id: 'lasik',
      title: 'LASIK & Contoura Vision',
      category: 'Laser & LASIK',
      description:
          '100% Blade-Free German Carl Zeiss SMILE & Contoura lasers for permanent spectacle removal.',
      fullDetails:
          'Experience the gold standard in laser vision correction with German Carl Zeiss SMILE Pro and Topography-Guided Contoura Vision. Our blade-free femtosecond technology gently reshapes the cornea in under 10 seconds per eye, offering quick next-day visual recovery with maximum corneal biomechanical stability.',
      imagePath: 'assets/images/service_lasik.jpg',
      icon: FontAwesomeIcons.bolt,
      accentColor: AppColors.accent,
      badge: 'Popular',
      hospitalBadge: 'Rainbow LASIK Suite',
      highlights: ['10-Min Day Care Procedure', '100% Blade-Free Zeiss Laser', 'Next-Day Visual Recovery', 'Zero Flap Complications'],
    ),
    ServiceItem(
      id: 'cataract',
      title: 'Micro-Incision Cataract (MICS)',
      category: 'Cataract',
      description:
          'Robotic stitchless phacoemulsification with premium Trifocal, Multifocal & Toric IOL implants.',
      fullDetails:
          'Restore high-definition sight with robotic stitchless phacoemulsification through a 1.8mm micro-incision. Customized with premium German and US FDA-approved Trifocal, Multifocal, and Toric intraocular lens (IOL) implants for spectacle-free distance, computer, and near reading vision.',
      imagePath: 'assets/images/service_cataract.jpg',
      icon: FontAwesomeIcons.eye,
      accentColor: AppColors.primary,
      badge: 'Advanced',
      hospitalBadge: 'Rainbow Cataract Centre',
      highlights: ['Stitchless 1.8mm MICS', 'Premium Trifocal & Toric IOLs', '99.8% Surgical Success Rate', '15-Min Topical Anesthesia'],
    ),
    ServiceItem(
      id: 'retina',
      title: 'Retina & Diabetic Eye Care',
      category: 'Retina & Glaucoma',
      description:
          'Advanced 3D Spectral OCT scans, anti-VEGF injections, sutureless vitrectomy & retina care.',
      fullDetails:
          'Comprehensive vitreo-retinal diagnostics and treatment for diabetic retinopathy, retinal detachment, and macular degeneration. Equipped with 3D Spectral High-Resolution OCT imaging, green laser barrage photocoagulation, and 27-gauge sutureless micro-vitrectomy.',
      imagePath: 'assets/images/service_retina.jpg',
      icon: FontAwesomeIcons.dna,
      accentColor: Color(0xFFE11D48),
      badge: 'Super-Specialty',
      hospitalBadge: 'Rainbow 24x7 Retina Unit',
      highlights: ['3D Spectral OCT Scan', 'Anti-VEGF Injections', 'Green Laser Photocoagulation', 'Sutureless Vitrectomy'],
    ),
    ServiceItem(
      id: 'glaucoma',
      title: 'Glaucoma Care & Laser Therapy',
      category: 'Retina & Glaucoma',
      description:
          'Early optical nerve diagnostic mapping, IOP laser trabeculoplasty & micro-shunts.',
      fullDetails:
          'Silent vision thief detection and management. We perform automated visual field testing, optical coherence tomography of the nerve fiber layer, selective laser trabeculoplasty (SLT), and advanced micro-invasive glaucoma surgery (MIGS) to maintain safe intraocular pressure.',
      imagePath: 'assets/images/service_glaucoma.jpg',
      icon: FontAwesomeIcons.circleDot,
      accentColor: Color(0xFF0D9488),
      hospitalBadge: 'Rainbow Glaucoma Clinic',
      highlights: ['Automated Field Analysis', 'Selective Laser SLT', 'IOP Pressure Stabilization', 'Micro-Shunt Surgery'],
    ),
    ServiceItem(
      id: 'pediatric',
      title: 'Pediatric & Squint Clinic',
      category: 'Pediatric & Cornea',
      description:
          'Child-friendly vision evaluations, amblyopia lazy-eye therapy & squint correction.',
      fullDetails:
          'Specialized pediatric ophthalmology unit designed for children of all ages. From early infant vision screenings and amblyopia (lazy eye) patching therapy to precision microscopic squint (strabismus) alignment surgery preserving binocular 3D depth perception.',
      imagePath: 'assets/images/service_pediatric.jpg',
      icon: FontAwesomeIcons.child,
      accentColor: Color(0xFF8B5CF6),
      badge: 'Child Care',
      hospitalBadge: 'Rainbow Pediatric Wing',
      highlights: ['Amblyopia Patching Protocols', 'Microscopic Squint Surgery', 'Child-Friendly Environment', 'Binocular 3D Preservation'],
    ),
    ServiceItem(
      id: 'cornea',
      title: 'Cornea & Keratoconus Care',
      category: 'Pediatric & Cornea',
      description:
          'Corneal Cross-Linking (C3R), Rose-K specialty contact lenses & lamellar transplants.',
      fullDetails:
          'Dedicated anterior segment clinic providing corneal topography, collagen cross-linking with riboflavin (C3R) for keratoconus stabilization, specialty Rose-K and scleral lens fittings, and advanced lamellar keratoplasty (DALK/DSEK) transplants.',
      imagePath: 'assets/images/service_cornea.jpg',
      icon: FontAwesomeIcons.shieldHalved,
      accentColor: Color(0xFFD97706),
      hospitalBadge: 'Rainbow Cornea Centre',
      highlights: ['C3R Collagen Cross-Linking', 'Rose-K Scleral Lenses', 'Corneal Topography Mapping', 'Lamellar Transplants'],
    ),
    ServiceItem(
      id: 'dryeye',
      title: 'Dry Eye & Ocular Surface',
      category: 'Laser & LASIK',
      description:
          'LipiFlow thermal pulsation, Meibomian gland imaging & customized tear film therapy.',
      fullDetails:
          'State-of-the-art dry eye spa and ocular surface wellness clinic. Utilizing Meibomian gland infrared imaging, tear osmolarity testing, and LipiFlow thermal pulsation to unblock eyelid oil glands and relieve computer screen eye strain permanently.',
      imagePath: 'assets/images/service_dryeye.jpg',
      icon: FontAwesomeIcons.droplet,
      accentColor: Color(0xFF0284C7),
      hospitalBadge: 'Rainbow Ocular Wellness',
      highlights: ['LipiFlow Thermal Pulsation', 'Meibomian Gland Infrared Scan', 'Tear Osmolarity Testing', 'Instant Asthenopia Relief'],
    ),
    ServiceItem(
      id: 'oculoplasty',
      title: 'Oculoplasty & Aesthetics',
      category: 'Cataract',
      description:
          'Cosmetic blepharoplasty, ptosis eyelid lifting, tear duct reconstructive & facial care.',
      fullDetails:
          'Cosmetic and reconstructive ophthalmic plastic surgery. Expert solutions for drooping eyelids (ptosis), cosmetic blepharoplasty, blocked tear duct dacryocystorhinostomy (DCR), and ocular prosthesis fabrication.',
      imagePath: 'assets/images/service_oculoplasty.jpg',
      icon: FontAwesomeIcons.faceSmile,
      accentColor: Color(0xFFEC4899),
      hospitalBadge: 'Rainbow Aesthetics',
      highlights: ['Ptosis Eyelid Lifting', 'Cosmetic Blepharoplasty', 'Tear Duct Reconstruction', 'Custom Ocular Prosthesis'],
    ),
  ];

  void _showServiceDetails(ServiceItem service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ServiceDetailsModal(service: service),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 650;

    return Container(
      key: SectionNavigator.servicesKey,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F5FC), // Soft lavender-gray background
      ),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 64,
        horizontal: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── 1. Section Header ──
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.horizontalPadding(context),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1320),
              child: ScrollReveal(
                slideOffset: 0.08,
                duration: const Duration(milliseconds: 700),
                child: Column(
                  children: [
                    // Eyebrow
                    Container(
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
                            FontAwesomeIcons.stethoscope,
                            size: 11,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            'SPECIALIZED DEPARTMENTS',
                            style: AppTypography.sectionEyebrow(
                              color: AppColors.primary,
                              fontSize: isMobile ? 11 : 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Headline
                    Text(
                      'Our specialized departments\nwork together seamlessly',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: isMobile ? 22 : 34,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: isMobile ? 24 : 36),

          // ── 2. Interactive 3D Carousel Swiper with Parallax Depth ──
          _InteractiveServiceCarousel(
            services: _allServices,
            onCardTap: _showServiceDetails,
          ),
        ],
      ),
    );
  }
}

/// Interactive 3D Carousel Swiper showing 3 cards side-by-side with depth parallax,
/// sleek circular arrows, 8 interactive dot indicators, and automatic rotation.
class _InteractiveServiceCarousel extends StatefulWidget {
  final List<ServiceItem> services;
  final ValueChanged<ServiceItem> onCardTap;

  const _InteractiveServiceCarousel({
    required this.services,
    required this.onCardTap,
  });

  @override
  State<_InteractiveServiceCarousel> createState() => _InteractiveServiceCarouselState();
}

class _InteractiveServiceCarouselState extends State<_InteractiveServiceCarousel> {
  int _currentServiceIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final String screenCategory = screenWidth < 650
        ? 'mobile'
        : (screenWidth < 1100 ? 'tablet' : 'desktop');
    
    // Fraction tuning:
    // - Mobile (< 650px): 0.70 gives prominent center card + left peek + right peek simultaneously (exactly like screenshot)
    // - Tablet (650px - 1100px): 0.50 gives 2+ cards preview
    // - Desktop (1100px+): 0.35 gives 3 cards preview
    final double fraction = screenWidth < 650
        ? 0.70
        : (screenWidth < 1100 ? 0.50 : 0.35);

    return _CarouselViewportTrack(
      key: ValueKey('carousel_$screenCategory'),
      services: widget.services,
      viewportFraction: fraction,
      initialServiceIndex: _currentServiceIndex,
      onCardTap: widget.onCardTap,
      onIndexChanged: (idx) {
        _currentServiceIndex = idx;
      },
    );
  }
}

class _CarouselViewportTrack extends StatefulWidget {
  final List<ServiceItem> services;
  final double viewportFraction;
  final int initialServiceIndex;
  final ValueChanged<ServiceItem> onCardTap;
  final ValueChanged<int> onIndexChanged;

  const _CarouselViewportTrack({
    super.key,
    required this.services,
    required this.viewportFraction,
    required this.initialServiceIndex,
    required this.onCardTap,
    required this.onIndexChanged,
  });

  @override
  State<_CarouselViewportTrack> createState() => _CarouselViewportTrackState();
}

class _CarouselViewportTrackState extends State<_CarouselViewportTrack> {
  late final PageController _pageController;
  late int _currentPage;
  bool _isHovered = false;
  Timer? _autoScrollTimer;

  static const int _loopMultiplier = 100;
  late final int _baseIndex;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialServiceIndex;
    final middleCycle = _loopMultiplier ~/ 2;
    _baseIndex = (middleCycle * widget.services.length) + _currentPage;

    _pageController = PageController(
      initialPage: _baseIndex,
      viewportFraction: widget.viewportFraction,
    );

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_isHovered && mounted && _pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _pauseAutoScroll() => _isHovered = true;
  void _resumeAutoScroll() => _isHovered = false;

  void _goToIndex(int targetServiceIndex) {
    if (!_pageController.hasClients) return;
    final currentRealIndex = _pageController.page?.round() ?? _baseIndex;
    final currentServiceIndex = currentRealIndex % widget.services.length;
    final difference = targetServiceIndex - currentServiceIndex;
    final targetPage = currentRealIndex + difference;

    _pageController.animateToPage(
      targetPage,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
    _startAutoScroll();
  }

  void _prevPage() {
    if (!_pageController.hasClients) return;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
    _startAutoScroll();
  }

  void _nextPage() {
    if (!_pageController.hasClients) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 650;
    final double carouselHeight = isMobile ? 395.0 : 430.0;
    final totalItems = widget.services.length * _loopMultiplier;

    return MouseRegion(
      onEnter: (_) => _pauseAutoScroll(),
      onExit: (_) => _resumeAutoScroll(),
      child: Column(
        children: [
          // ── 1. The 3D Parallax Swiper Track with Side Arrows ──
          SizedBox(
            height: carouselHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Swiper PageView
                PageView.builder(
                  controller: _pageController,
                  itemCount: totalItems,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (page) {
                    final normalized = page % widget.services.length;
                    setState(() {
                      _currentPage = normalized;
                    });
                    widget.onIndexChanged(normalized);
                  },
                  itemBuilder: (context, index) {
                    final serviceIndex = index % widget.services.length;
                    final service = widget.services[serviceIndex];

                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double pageOffset = index.toDouble();
                        if (_pageController.position.haveDimensions) {
                          pageOffset = (_pageController.page ?? index.toDouble()) - index;
                        } else {
                          pageOffset = (_baseIndex - index).toDouble();
                        }

                        // Parallax calculation
                        final distance = pageOffset.abs().clamp(0.0, 2.0);
                        final isCenter = distance < 0.5;

                        final scale = (1.0 - (distance * 0.10)).clamp(0.85, 1.05);
                        final translateY = (distance * 12.0);
                        final opacity = (1.0 - (distance * 0.25)).clamp(0.60, 1.0);
                        final rotateY = (-pageOffset * 0.10).clamp(-0.22, 0.22);

                        return Center(
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001) // 3D Perspective
                              ..translateByDouble(0.0, translateY, 0.0, 1.0)
                              ..scaleByDouble(scale, scale, 1.0, 1.0)
                              ..rotateY(rotateY),
                            child: Opacity(
                              opacity: opacity,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 6 : 10,
                                  vertical: 8,
                                ),
                                child: _CarouselServiceCard(
                                  service: service,
                                  isCenter: isCenter,
                                  isMobile: isMobile,
                                  onTap: () {
                                    if (!isCenter) {
                                      _pageController.animateToPage(
                                        index,
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeInOutCubic,
                                      );
                                    } else {
                                      widget.onCardTap(service);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

                // Sleek Circular Left Navigation Arrow (Desktop & Tablet)
                if (!isMobile)
                  Positioned(
                    left: (screenWidth > 1320 ? (screenWidth - 1320) / 2 + 10 : 20),
                    child: _CarouselArrowButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: _prevPage,
                      tooltip: 'Previous Service',
                    ),
                  ),

                // Sleek Circular Right Navigation Arrow (Desktop & Tablet)
                if (!isMobile)
                  Positioned(
                    right: (screenWidth > 1320 ? (screenWidth - 1320) / 2 + 10 : 20),
                    child: _CarouselArrowButton(
                      icon: Icons.chevron_right_rounded,
                      onTap: _nextPage,
                      tooltip: 'Next Service',
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: isMobile ? 16 : 24),

          // ── 2. 8 Interactive Dot Indicators ──
          _CarouselDotIndicators(
            itemCount: widget.services.length,
            currentIndex: _currentPage,
            onDotTap: _goToIndex,
          ),
        ],
      ),
    );
  }
}

/// A premium, responsive Service Card designed for the Carousel Swiper.
class _CarouselServiceCard extends StatefulWidget {
  final ServiceItem service;
  final bool isCenter;
  final bool isMobile;
  final VoidCallback onTap;

  const _CarouselServiceCard({
    required this.service,
    required this.isCenter,
    this.isMobile = false,
    required this.onTap,
  });

  @override
  State<_CarouselServiceCard> createState() => _CarouselServiceCardState();
}

class _CarouselServiceCardState extends State<_CarouselServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    final isCenter = widget.isCenter;
    final isMobile = widget.isMobile;
    final isHighlighted = isCenter || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
            border: Border.all(
              color: isHighlighted
                  ? s.accentColor.withValues(alpha: isCenter ? 0.60 : 0.35)
                  : const Color(0xFFE2E8F0),
              width: isCenter ? 1.6 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isHighlighted
                    ? s.accentColor.withValues(alpha: isCenter ? 0.16 : 0.08)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: isCenter ? 24 : 10,
                offset: Offset(0, isCenter ? 8 : 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(isMobile ? 12 : 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Bar: Category Tag Pill + Specialty Badge ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category Tag Pill
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 7 : 8,
                        vertical: isMobile ? 3 : 4,
                      ),
                      decoration: BoxDecoration(
                        color: s.accentColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: s.accentColor.withValues(alpha: 0.25),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            s.icon,
                            size: isMobile ? 9 : 10,
                            color: s.accentColor,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              s.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: isMobile ? 9 : 10,
                                fontWeight: FontWeight.w700,
                                color: s.accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Optional Specialty Badge
                  if (s.badge != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 6 : 7,
                        vertical: isMobile ? 2.5 : 3,
                      ),
                      decoration: BoxDecoration(
                        color: s.accentColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        s.badge!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: isMobile ? 8.5 : 9.5,
                          fontWeight: FontWeight.w700,
                          color: s.accentColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: isMobile ? 8 : 10),

              // ── Service Title ──
              Text(
                s.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: isMobile ? 13 : 14.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 3),

              // ── Short Description Excerpt ──
              Text(
                s.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isMobile ? 10 : 11,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                  height: 1.35,
                ),
              ),
              SizedBox(height: isMobile ? 8 : 10),

              // ── Clinical Photo with Overlay + Hospital Verified Tag ──
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: s.accentColor.withValues(alpha: 0.08),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          scale: _isHovered ? 1.06 : 1.0,
                          child: Image.asset(
                            s.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, error, stackTrace) => Center(
                              child: FaIcon(
                                s.icon,
                                size: isMobile ? 30 : 36,
                                color: s.accentColor,
                              ),
                            ),
                          ),
                        ),

                        // Gradient Shade
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.40),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Verified Hospital Unit Badge
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.30),
                                width: 0.6,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified_rounded,
                                  size: 10,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  s.hospitalBadge,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: isMobile ? 8 : 8.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 8 : 10),

              // ── Bottom Feature Highlight & Book Action Button ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Feature highlight chip
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: isMobile ? 12 : 14,
                          color: s.accentColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            s.highlights.isNotEmpty ? s.highlights.first : 'Precision Care',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isMobile ? 9.5 : 10.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF334155),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 6),

                  // Sleek "Book" Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 8 : 10,
                      vertical: isMobile ? 4.5 : 5.5,
                    ),
                    decoration: BoxDecoration(
                      gradient: isCenter
                          ? LinearGradient(
                              colors: [s.accentColor, s.accentColor.withValues(alpha: 0.85)],
                            )
                          : null,
                      color: isCenter ? null : s.accentColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isCenter
                          ? [
                              BoxShadow(
                                color: s.accentColor.withValues(alpha: 0.30),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Book',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: isMobile ? 10 : 11,
                            fontWeight: FontWeight.w700,
                            color: isCenter ? Colors.white : s.accentColor,
                          ),
                        ),
                        const SizedBox(width: 2.5),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: isMobile ? 10 : 11,
                          color: isCenter ? Colors.white : s.accentColor,
                        ),
                      ],
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

/// Sleek circular arrow navigation button with hover shadow.
class _CarouselArrowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  static const double size = 46;

  const _CarouselArrowButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  State<_CarouselArrowButton> createState() => _CarouselArrowButtonState();
}

class _CarouselArrowButtonState extends State<_CarouselArrowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: widget.tooltip ?? '',
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: _CarouselArrowButton.size,
            height: _CarouselArrowButton.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isHovered ? AppColors.primary : Colors.white,
              border: Border.all(
                color: _isHovered
                    ? AppColors.primary
                    : const Color(0xFFCBD5E1).withValues(alpha: 0.8),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                    ? AppColors.primary.withValues(alpha: 0.35)
                    : Colors.black.withValues(alpha: 0.08),
                  blurRadius: _isHovered ? 14 : 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                widget.icon,
                size: _CarouselArrowButton.size * 0.58,
                color: _isHovered ? Colors.white : const Color(0xFF334155),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 8 Interactive Dot Indicators with animated active pill expander.
class _CarouselDotIndicators extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final ValueChanged<int> onDotTap;

  const _CarouselDotIndicators({
    required this.itemCount,
    required this.currentIndex,
    required this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = index == currentIndex;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => onDotTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 4.5),
              width: isActive ? 26 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(4),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Service Details & Instant Appointment Modal (Matching Blog Reader experience).
class _ServiceDetailsModal extends StatelessWidget {
  final ServiceItem service;
  const _ServiceDetailsModal({required this.service});

  @override
  Widget build(BuildContext context) {
    final s = service;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 42,
              height: 4.5,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Modal Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Banner Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: s.accentColor.withValues(alpha: 0.10),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            s.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, error, stackTrace) => Center(
                              child: FaIcon(s.icon, size: 48, color: s.accentColor),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: s.accentColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                s.category,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          if (s.badge != null)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Text(
                                  s.badge!,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Hospital Badge Byline
                  Row(
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 14,
                        color: s.accentColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${s.hospitalBadge} • Rainbow Eye Hospital',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: s.accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    s.title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Full Description
                  Text(
                    s.fullDetails,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF334155),
                      height: 1.65,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Highlights Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: s.accentColor.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: s.accentColor.withValues(alpha: 0.20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            FaIcon(FontAwesomeIcons.certificate, size: 14, color: s.accentColor),
                            const SizedBox(width: 8),
                            Text(
                              'Clinical Highlights & Advantages',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: s.accentColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...s.highlights.map(
                          (highlight) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 14,
                                  color: Color(0xFF10B981),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: Text(
                                    highlight,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1E293B),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Book Appointment CTA
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showBookingDialog(context, initialTreatment: s.title);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(FontAwesomeIcons.calendarCheck, size: 14, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Book Appointment for ${s.title}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

