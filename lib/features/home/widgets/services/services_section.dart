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

/// Direction for stepped infinite auto-scroll tracks.
enum MarqueeDirection { leftToRight, rightToLeft }

/// Section 5 — Specialized Departments & Clinical Specialities.
class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection> {
  String _selectedCategory = 'All';

  static const _categories = [
    'All',
    'Laser & LASIK',
    'Cataract',
    'Retina & Glaucoma',
    'Pediatric & Cornea',
  ];

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

  List<ServiceItem> get _filteredServices {
    if (_selectedCategory == 'All') return _allServices;
    return _allServices.where((s) => s.category == _selectedCategory).toList();
  }

  /// Upper row services (Laser, Cataract, Retina, Glaucoma)
  List<ServiceItem> get _upperServices => _allServices.sublist(0, 4);

  /// Lower row services (Pediatric, Cornea, Dry Eye, Oculoplasty)
  List<ServiceItem> get _lowerServices => _allServices.sublist(4, 8);

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
    final isTablet = screenWidth >= 650 && screenWidth < 1100;

    // Card width calculation matching Blogs section:
    // - Mobile: 1 card visible (84% width, clamped 275-330)
    // - Tablet: 2 cards visible ((width - 48) / 2, clamped 275-350)
    // - PC/Laptop: 3 cards visible ((containerWidth - 32) / 3, clamped 280-370)
    final double cardWidth;
    if (isMobile) {
      cardWidth = (screenWidth * 0.84).clamp(275.0, 330.0);
    } else if (isTablet) {
      cardWidth = ((screenWidth - 48) / 2).clamp(275.0, 350.0);
    } else {
      const containerWidth = 1320.0;
      final effectiveWidth = screenWidth.clamp(1100.0, containerWidth);
      cardWidth = ((effectiveWidth - 2 * ResponsiveHelper.horizontalPadding(context) - 32) / 3).clamp(280.0, 370.0);
    }

    final double rowHeight = isMobile ? 340.0 : 330.0;
    const double cardSpacing = 16.0;

    return Container(
      key: SectionNavigator.servicesKey,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F5FC), // Soft purple-tinted backdrop
      ),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 64,
        horizontal: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── 1. Section Header (Clean & Centered) ──
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
                    const SizedBox(height: 10),

                    // ── Category Filter Bar ──
                    _CategoryFilterBar(
                      categories: _categories,
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (cat) {
                        setState(() => _selectedCategory = cat);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: isMobile ? 20 : 28),

          // ── 2. Dual Stepped Infinite Scroll Rows (2s Auto-Step) ──
          if (_selectedCategory == 'All') ...[
            // Line 1: Upper Row (Steps smoothly Left-to-Right every 2s)
            _SteppedInfiniteServiceRow(
              key: const ValueKey('upper_stream_all'),
              items: _upperServices,
              direction: MarqueeDirection.leftToRight,
              cardWidth: cardWidth,
              cardSpacing: cardSpacing,
              height: rowHeight,
              onCardTap: _showServiceDetails,
            ),

            SizedBox(height: isMobile ? 12 : 16),

            // Line 2: Lower Row (Steps smoothly Right-to-Left every 2s)
            _SteppedInfiniteServiceRow(
              key: const ValueKey('lower_stream_all'),
              items: _lowerServices,
              direction: MarqueeDirection.rightToLeft,
              cardWidth: cardWidth,
              cardSpacing: cardSpacing,
              height: rowHeight,
              onCardTap: _showServiceDetails,
            ),
          ] else ...[
            // Filtered Category Stream
            _SteppedInfiniteServiceRow(
              key: ValueKey('filtered_stream_$_selectedCategory'),
              items: _filteredServices,
              direction: MarqueeDirection.leftToRight,
              cardWidth: cardWidth,
              cardSpacing: cardSpacing,
              height: rowHeight,
              onCardTap: _showServiceDetails,
            ),
          ],
        ],
      ),
    );
  }
}

/// Horizontal category filter pills bar with mobile touch responsiveness.
class _CategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const _CategoryFilterBar({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: categories.map((cat) {
            final isSelected = cat == selectedCategory;
            return _FilterPillButton(
              title: cat,
              isSelected: isSelected,
              onTap: () => onCategorySelected(cat),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// A single filter pill button
class _FilterPillButton extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPillButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_FilterPillButton> createState() => _FilterPillButtonState();
}

class _FilterPillButtonState extends State<_FilterPillButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(_isPressed ? 0.95 : 1.0, _isPressed ? 0.95 : 1.0, 1.0),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        decoration: BoxDecoration(
          color: widget.isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: widget.isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
            color: widget.isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}

/// A stepped infinite auto-scrolling row that smoothly advances by 1 card every 2 seconds.
class _SteppedInfiniteServiceRow extends StatefulWidget {
  final List<ServiceItem> items;
  final MarqueeDirection direction;
  final double cardWidth;
  final double cardSpacing;
  final double height;
  final ValueChanged<ServiceItem> onCardTap;

  static const Duration _stepInterval = Duration(seconds: 2);
  static const Duration _stepDuration = Duration(milliseconds: 850);

  const _SteppedInfiniteServiceRow({
    super.key,
    required this.items,
    required this.direction,
    required this.cardWidth,
    required this.cardSpacing,
    required this.height,
    required this.onCardTap,
  });

  @override
  State<_SteppedInfiniteServiceRow> createState() => _SteppedInfiniteServiceRowState();
}

class _SteppedInfiniteServiceRowState extends State<_SteppedInfiniteServiceRow> {
  late final ScrollController _scrollController;
  Timer? _timer;
  bool _isHovered = false;
  bool _isAnimating = false;

  static const int _bufferMultiplier = 16;

  double get _stride => widget.cardWidth + widget.cardSpacing;
  double get _singleSetWidth => widget.items.length * _stride;

  List<ServiceItem> get _bufferedItems {
    if (widget.items.isEmpty) return [];
    final list = <ServiceItem>[];
    for (int i = 0; i < _bufferMultiplier; i++) {
      list.addAll(widget.items);
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    final initialOffset = _singleSetWidth * 6;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_SteppedInfiniteServiceRow._stepInterval, (timer) {
      if (!_isHovered && mounted && _scrollController.hasClients && !_isAnimating) {
        _stepNext();
      }
    });
  }

  void _pauseTimer() => _isHovered = true;
  void _resumeTimer() => _isHovered = false;

  Future<void> _stepNext() async {
    if (!_scrollController.hasClients || !mounted) return;

    _isAnimating = true;
    final currentOffset = _scrollController.offset;
    final double targetOffset;

    if (widget.direction == MarqueeDirection.rightToLeft) {
      targetOffset = currentOffset + _stride;
    } else {
      targetOffset = currentOffset - _stride;
    }

    try {
      await _scrollController.animateTo(
        targetOffset,
        duration: _SteppedInfiniteServiceRow._stepDuration,
        curve: Curves.easeInOutCubic,
      );

      if (mounted && _scrollController.hasClients) {
        final newOffset = _scrollController.offset;
        if (newOffset >= _singleSetWidth * 10) {
          _scrollController.jumpTo(newOffset - (_singleSetWidth * 4));
        } else if (newOffset <= _singleSetWidth * 2) {
          _scrollController.jumpTo(newOffset + (_singleSetWidth * 4));
        }
      }
    } catch (_) {
    } finally {
      if (mounted) {
        _isAnimating = false;
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final items = _bufferedItems;

    return MouseRegion(
      onEnter: (_) => _pauseTimer(),
      onExit: (_) => _resumeTimer(),
      child: SizedBox(
        height: widget.height,
        child: ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: widget.cardSpacing,
            vertical: 4,
          ),
          itemCount: items.length,
          separatorBuilder: (_, _) => SizedBox(width: widget.cardSpacing),
          itemBuilder: (context, index) {
            final item = items[index];
            return SizedBox(
              width: widget.cardWidth,
              height: widget.height - 8,
              child: _CompactServiceCard(
                item: item,
                onTap: () => widget.onCardTap(item),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Compact sleek Service Card modeled after the Blog Card design system.
class _CompactServiceCard extends StatefulWidget {
  final ServiceItem item;
  final VoidCallback onTap;

  const _CompactServiceCard({
    required this.item,
    required this.onTap,
  });

  @override
  State<_CompactServiceCard> createState() => _CompactServiceCardState();
}

class _CompactServiceCardState extends State<_CompactServiceCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.item;
    final isActive = _isHovered || _isPressed;
    final yOffset = _isPressed ? 0.0 : (_isHovered ? -4.0 : 0.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: const Cubic(0.16, 1.0, 0.3, 1.0),
          transform: Matrix4.translationValues(0.0, yOffset, 0.0),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? s.accentColor.withValues(alpha: 0.65)
                  : const Color(0xFFE2E8F0),
              width: isActive ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? s.accentColor.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: isActive ? 14 : 6,
                offset: Offset(0, isActive ? 5 : 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Top Section: Category Pill + Specialty Badge + Title + Excerpt ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Category Tag Pill
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: s.accentColor.withValues(alpha: 0.09),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: s.accentColor.withValues(alpha: 0.22),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                s.icon,
                                size: 10,
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
                                    fontSize: 9.5,
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
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: s.accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            s.badge!,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: s.accentColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Service Title (2 lines max)
                  Text(
                    s.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                      height: 1.28,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Service Summary Excerpt (2 lines max)
                  Text(
                    s.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                      height: 1.36,
                    ),
                  ),
                ],
              ),

              // ── 2. Middle Section: Featured Clinical Image (Expanded & Responsive) ──
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: s.accentColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AnimatedScale(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            scale: _isHovered ? 1.06 : 1.0,
                            child: Image.asset(
                              s.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, error, stackTrace) => Container(
                                color: s.accentColor.withValues(alpha: 0.12),
                                child: Center(
                                  child: FaIcon(
                                    s.icon,
                                    size: 32,
                                    color: s.accentColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Gradient Overlay
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.38),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Bottom-right Clinical Badge
                          Positioned(
                            right: 8,
                            bottom: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.58),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.28),
                                  width: 0.6,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.verified_rounded,
                                    size: 9,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    s.hospitalBadge,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 8,
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
              ),

              // ── 3. Bottom Section: Highlight Feature + Book CTA ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 1, color: const Color(0xFFF1F5F9)),
                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // First Highlight feature chip
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 13,
                              color: s.accentColor,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                s.highlights.isNotEmpty ? s.highlights.first : 'Specialist Eye Care',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Book Appointment CTA Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: s.accentColor.withValues(alpha: isActive ? 0.18 : 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Book',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: s.accentColor,
                              ),
                            ),
                            const SizedBox(width: 2.5),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 8,
                              color: s.accentColor,
                            ),
                          ],
                        ),
                      ),
                    ],
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

