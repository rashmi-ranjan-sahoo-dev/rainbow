// ─────────────────────────────────────────────────────────────────────────────
// REFERENCE PATTERN & RATIONALE (Docs Analysis Reference):
//   • Pattern Followed: "Verified Patient Stories Carousel with Google Reviews Trust
//     Banner, Category Filter Pills, and Interactive Outcome Metrics."
//   • Responsive Breakdown:
//     - PC / Laptop (>= 1100px): Exactly 4 cards displayed side-by-side.
//     - Tablet (650px - 1099px): Exactly 2 cards displayed side-by-side.
//     - Mobile (< 650px): 1 focused swipeable card (86% width peek).
//   • Why: Eliminates wasted empty space on desktop screens while keeping
//     a touch-driven, spring-physics carousel on tablets and mobile phones.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/section_navigator.dart';
import '../booking/booking_modal.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 1. DATA MODEL FOR PATIENT TESTIMONIALS
// ─────────────────────────────────────────────────────────────────────────────

class Testimonial {
  final String id;
  final String patientName;
  final String ageAndLocation;
  final String treatment;
  final String doctorTreated;
  final String outcomeMetric;
  final double rating;
  final String highlightSnippet;
  final String fullQuote;
  final String dateAgo;
  final String avatarInitials;
  final String imageAsset;
  final Color categoryColor;
  final String procedureTag;
  final bool isVerifiedGoogle;

  const Testimonial({
    required this.id,
    required this.patientName,
    required this.ageAndLocation,
    required this.treatment,
    required this.doctorTreated,
    required this.outcomeMetric,
    required this.rating,
    required this.highlightSnippet,
    required this.fullQuote,
    required this.dateAgo,
    required this.avatarInitials,
    required this.imageAsset,
    required this.categoryColor,
    required this.procedureTag,
    this.isVerifiedGoogle = true,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. MAIN TESTIMONIALS SECTION WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  String _selectedCategory = 'All';
  int _visibilityEpoch = 0;
  bool _isInView = true;

  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  Timer? _autoPlayTimer;
  bool _isUserInteracting = false;

  static const List<String> _categories = [
    'All',
    'LASIK & SMILE',
    'Cataract',
    'Retina',
    'Pediatric',
    'Glaucoma',
    'Cornea & Oculoplasty',
  ];

  static const List<Testimonial> _allTestimonials = [
    Testimonial(
      id: 'test_1',
      patientName: 'Ravi Kumar S.',
      ageAndLocation: '32 Yrs • Visakhapatnam',
      treatment: 'Contoura Vision Topo-Guided LASIK',
      doctorTreated: 'Dr. Rajesh Varma',
      outcomeMetric: '6/6 Vision Restored in 24 Hrs',
      rating: 5.0,
      highlightSnippet: '“Zero pain during the laser. Next morning I had 6/6 crystal clarity without glasses!”',
      fullQuote:
          'I wore -5.5D thick spectacles for over 14 years. Dr. Rajesh Varma and the counseling team explained the entire Contoura Vision procedure with extreme patience. The laser took barely 10 minutes for both eyes with zero blade or pain. The very next morning I woke up and could read the smallest wall clock numbers. Truly life-changing care!',
      dateAgo: '2 weeks ago',
      avatarInitials: 'RK',
      imageAsset: 'assets/images/patient_ravi_kumar.jpg',
      categoryColor: Color(0xFF0284C7),
      procedureTag: 'LASIK & SMILE',
    ),
    Testimonial(
      id: 'test_2',
      patientName: 'Lakshmi Prasanna',
      ageAndLocation: '62 Yrs • Gajuwaka',
      treatment: 'Micro-Incision Phaco Cataract',
      doctorTreated: 'Dr. Rajesh Varma',
      outcomeMetric: 'Painless • Same Day Discharge',
      rating: 5.0,
      highlightSnippet: '“I was terrified of surgery due to my diabetes, but topical drop method was 100% painless.”',
      fullQuote:
          'Being diabetic, I postponed my cataract surgery for two years out of sheer fear. Dr. Rajesh used topical eye drops without any injection needles. The robotic phaco surgery was done in 12 minutes. I was home having lunch the same afternoon. All colors look bright and sharp again!',
      dateAgo: '1 month ago',
      avatarInitials: 'LP',
      imageAsset: 'assets/images/patient_lakshmi_prasanna.jpg',
      categoryColor: AppColors.primary,
      procedureTag: 'Cataract',
    ),
    Testimonial(
      id: 'test_3',
      patientName: 'Venkat Rao M.',
      ageAndLocation: '54 Yrs • MVP Colony',
      treatment: 'Emergency Vitreo-Retinal Laser',
      doctorTreated: 'Dr. Ananya Iyer',
      outcomeMetric: 'Retina Saved • 100% Sight Preserved',
      rating: 5.0,
      highlightSnippet: '“Sunday emergency retina triage caught my retinal tear just in time and saved my eye.”',
      fullQuote:
          'I noticed sudden black curtain floaters and severe flashes on a Sunday evening. Rainbow Eye Hospital’s 24x7 emergency retina team attended to me immediately. Dr. Ananya Iyer performed a precision green barrage laser within 2 hours, preventing permanent retinal detachment. Her surgical expertise is second to none in Andhra Pradesh.',
      dateAgo: '3 weeks ago',
      avatarInitials: 'VR',
      imageAsset: 'assets/images/patient_venkat_rao.jpg',
      categoryColor: Color(0xFFE11D48),
      procedureTag: 'Retina',
    ),
    Testimonial(
      id: 'test_4',
      patientName: 'Sneha & Rahul K.',
      ageAndLocation: 'Parents of Aarav (7) • Siripuram',
      treatment: 'Pediatric Squint Correction',
      doctorTreated: 'Dr. Priya Sharma',
      outcomeMetric: 'Perfect Alignment • 100% Restored',
      rating: 5.0,
      highlightSnippet: '“Dr. Priya handled our 7-year-old with so much love. His squint is completely gone.”',
      fullQuote:
          'Finding a doctor who can keep a 7-year-old calm during surgery is rare. Dr. Priya Sharma is a blessing. Aarav’s squint was completely corrected with microscopic precision. His eye alignment is flawless, and his confidence at school has returned completely.',
      dateAgo: '2 months ago',
      avatarInitials: 'SK',
      imageAsset: 'assets/images/patient_sneha_aarav.jpg',
      categoryColor: Color(0xFF8B5CF6),
      procedureTag: 'Pediatric',
    ),
    Testimonial(
      id: 'test_5',
      patientName: 'K. Srinivas Murthy',
      ageAndLocation: '68 Yrs • Seethammadhara',
      treatment: 'Advanced Glaucoma Valve Implant',
      doctorTreated: 'Dr. Suresh Nair',
      outcomeMetric: 'Pressure Stabilized: 34 ➔ 14 mmHg',
      rating: 5.0,
      highlightSnippet: '“My eye pressure was dangerously high at 34 mmHg. Dr. Suresh saved my optic nerve.”',
      fullQuote:
          'I was losing peripheral vision silently due to chronic open-angle glaucoma. Dr. Suresh Nair performed an advanced Ahmed valve implant. My intraocular pressure dropped from 34 mmHg to a safe 14 mmHg. The entire clinical nursing staff treated me like family.',
      dateAgo: '1 month ago',
      avatarInitials: 'SM',
      imageAsset: 'assets/images/patient_srinivas_murthy.jpg',
      categoryColor: Color(0xFF0D9488),
      procedureTag: 'Glaucoma',
    ),
    Testimonial(
      id: 'test_6',
      patientName: 'Divya Madhavan',
      ageAndLocation: '28 Yrs • Software Engineer • Madhurawada',
      treatment: 'SMILE Pro Blade-Free Laser',
      doctorTreated: 'Dr. Arjun Mehta',
      outcomeMetric: '6/5 Ultra-HD Vision • 0 Dry Eyes',
      rating: 5.0,
      highlightSnippet: '“As a coder working 10+ hours on screen, SMILE Pro was the best investment of my life.”',
      fullQuote:
          'I was worried about flap dislodgement and chronic dry eyes from coding all day. Dr. Arjun Mehta recommended keyhole SMILE laser. It was done in under 8 seconds per eye! I had zero dry eye irritation and was back coding on Monday with sharper than 6/6 vision.',
      dateAgo: '3 weeks ago',
      avatarInitials: 'DM',
      imageAsset: 'assets/images/patient_divya_madhavan.jpg',
      categoryColor: Color(0xFFD97706),
      procedureTag: 'LASIK & SMILE',
    ),
    Testimonial(
      id: 'test_7',
      patientName: 'Pooja Hegde',
      ageAndLocation: '34 Yrs • Architect • Lawsons Bay',
      treatment: 'Ptosis Eyelid Reconstruction',
      doctorTreated: 'Dr. Kavitha Reddy',
      outcomeMetric: '100% Symmetrical Eyelid Lift',
      rating: 5.0,
      highlightSnippet: '“Severe drooping eyelid was blocking my sight. Dr. Kavitha restored natural symmetry with zero scar!”',
      fullQuote:
          'I suffered from congenital ptosis on my left eye which worsened over years. Dr. Kavitha Reddy performed precision oculoplastic surgery. The incision is completely invisible within the eyelid crease, and my visual field has opened up completely.',
      dateAgo: '1 month ago',
      avatarInitials: 'PH',
      imageAsset: 'assets/images/patient_pooja_hegde.jpg',
      categoryColor: Color(0xFFDB2777),
      procedureTag: 'Cornea & Oculoplasty',
    ),
    Testimonial(
      id: 'test_8',
      patientName: 'Anand Varma',
      ageAndLocation: '45 Yrs • Executive • MVP Colony',
      treatment: 'C3R Corneal Cross-Linking',
      doctorTreated: 'Dr. Suresh Nair',
      outcomeMetric: 'Keratoconus Halted • Vision Saved',
      rating: 5.0,
      highlightSnippet: '“Progressive keratoconus was blurring my sight. Custom C3R stopped the disease completely.”',
      fullQuote:
          'I was terrified of losing my vision from progressive keratoconus. Dr. Suresh Nair evaluated my corneal topography and performed customized riboflavin UV cross-linking. 6 months post-op, my cornea is rock solid and vision remains crisp with scleral lenses.',
      dateAgo: '2 weeks ago',
      avatarInitials: 'AV',
      imageAsset: 'assets/images/patient_anand_varma.jpg',
      categoryColor: Color(0xFF059669),
      procedureTag: 'Cornea & Oculoplasty',
    ),
  ];

  List<Testimonial> get _filteredTestimonials {
    if (_selectedCategory == 'All') return _allTestimonials;
    return _allTestimonials
        .where((t) => t.procedureTag == _selectedCategory)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(milliseconds: 4500), (timer) {
      if (!mounted || _isUserInteracting || !_scrollController.hasClients) return;
      final total = _filteredTestimonials.length;
      if (total <= 1) return;

      _goToNext();
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _scrollController.dispose();
    super.dispose();
  }

  int _getCardsPerView(double width) {
    if (width >= 1100) return 4;
    if (width >= 650) return 2;
    return 1;
  }

  void _scrollCardTo(int targetIndex, double cardWidth, double gap, int totalItems, int cardsPerView) {
    if (!_scrollController.hasClients) return;
    
    final maxScrollIndex = mathMax(0, totalItems - cardsPerView);
    final clampedIndex = targetIndex.clamp(0, maxScrollIndex);
    final offset = clampedIndex * (cardWidth + gap);

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 550),
      curve: const Cubic(0.16, 1.0, 0.3, 1.0),
    );
    setState(() => _currentIndex = clampedIndex);
  }

  int mathMax(int a, int b) => a > b ? a : b;

  void _goToPrevious() {
    final total = _filteredTestimonials.length;
    if (total == 0) return;

    final width = MediaQuery.sizeOf(context).width;
    final cardsPerView = _getCardsPerView(width);
    final maxScrollIndex = mathMax(0, total - cardsPerView);

    int prevIndex = _currentIndex - 1;
    if (prevIndex < 0) prevIndex = maxScrollIndex;

    final cardWidth = _calculateCardWidth(width, cardsPerView);
    const gap = 16.0;
    _scrollCardTo(prevIndex, cardWidth, gap, total, cardsPerView);
  }

  void _goToNext() {
    final total = _filteredTestimonials.length;
    if (total == 0) return;

    final width = MediaQuery.sizeOf(context).width;
    final cardsPerView = _getCardsPerView(width);
    final maxScrollIndex = mathMax(0, total - cardsPerView);

    int nextIndex = _currentIndex + 1;
    if (nextIndex > maxScrollIndex) nextIndex = 0;

    final cardWidth = _calculateCardWidth(width, cardsPerView);
    const gap = 16.0;
    _scrollCardTo(nextIndex, cardWidth, gap, total, cardsPerView);
  }

  double _calculateCardWidth(double screenWidth, int cardsPerView) {
    if (cardsPerView == 1) {
      return (screenWidth * 0.86).clamp(280.0, 420.0);
    }
    // For desktop / tablet, calculate within 1320 max width
    final containerWidth = (screenWidth - 2 * ResponsiveHelper.horizontalPadding(context)).clamp(300.0, 1320.0);
    final totalGap = (cardsPerView - 1) * 16.0;
    return (containerWidth - totalGap) / cardsPerView;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 650;
    final cardsPerView = _getCardsPerView(screenWidth);

    return VisibilityDetector(
      key: const Key('testimonials_section_visibility_detector'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.08) {
          if (!_isInView && mounted) {
            setState(() {
              _isInView = true;
              _visibilityEpoch++;
            });
          }
        } else if (info.visibleFraction == 0.0) {
          if (_isInView && mounted) {
            setState(() {
              _isInView = false;
            });
          }
        }
      },
      child: Container(
        key: SectionNavigator.testimonialsKey,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          border: Border(
            top: BorderSide(color: AppColors.divider.withValues(alpha: 0.6)),
            bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.6)),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 40 : 64,
          horizontal: ResponsiveHelper.horizontalPadding(context),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1320),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── 1. Section Header & Google Trust Badge Ribbon ──
                _TestimonialsHeader(
                  key: ValueKey('test_header_$_visibilityEpoch'),
                  isMobile: isMobile,
                ),

                const SizedBox(height: 20),

                // ── 2. Specialty Filter Category Bar ──
                _CategoryFilterBar(
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (cat) {
                    setState(() {
                      _selectedCategory = cat;
                      _currentIndex = 0;
                    });
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(0);
                    }
                  },
                ),

                SizedBox(height: isMobile ? 22 : 32),

                // ── 3. Responsive Multi-Card Carousel (4 on Desktop, 2 on Tablet, 1 on Mobile) ──
                LayoutBuilder(
                  builder: (context, constraints) {
                    return _buildResponsiveShowcase(
                      containerWidth: constraints.maxWidth,
                      isMobile: isMobile,
                      cardsPerView: cardsPerView,
                    );
                  },
                ),

                const SizedBox(height: 24),

                // ── 4. Interactive Bottom Controls (Arrows + Page Indicators) ──
                _buildBottomControls(
                  totalItems: _filteredTestimonials.length,
                  cardsPerView: cardsPerView,
                  isMobile: isMobile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveShowcase({
    required double containerWidth,
    required bool isMobile,
    required int cardsPerView,
  }) {
    final list = _filteredTestimonials;
    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(36),
        child: const Text(
          'No reviews in this category yet.',
          style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
        ),
      );
    }

    const gap = 16.0;
    final double cardWidth;
    if (cardsPerView == 1) {
      cardWidth = (containerWidth * 0.88).clamp(280.0, 420.0);
    } else {
      final totalGap = (cardsPerView - 1) * gap;
      cardWidth = (containerWidth - totalGap) / cardsPerView;
    }

    final double cardHeight = isMobile ? 360.0 : 348.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isUserInteracting = true),
      onExit: (_) => setState(() => _isUserInteracting = false),
      child: SizedBox(
        height: cardHeight,
        child: ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? (containerWidth - cardWidth) / 2 : 0,
            vertical: 4,
          ),
          itemCount: list.length,
          separatorBuilder: (_, _) => const SizedBox(width: gap),
          itemBuilder: (context, index) {
            final item = list[index];
            return SizedBox(
              width: cardWidth,
              height: cardHeight - 8,
              child: _TestimonialCard(
                key: ValueKey('test_card_${item.id}'),
                testimonial: item,
                isMobile: isMobile,
                cardWidth: cardWidth,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomControls({
    required int totalItems,
    required int cardsPerView,
    required bool isMobile,
  }) {
    if (totalItems <= 1) return const SizedBox.shrink();

    final maxScrollIndex = mathMax(0, totalItems - cardsPerView);
    final indicatorCount = maxScrollIndex + 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous Button
        _NavigationArrowButton(
          icon: Icons.arrow_back_rounded,
          onTap: _goToPrevious,
        ),
        const SizedBox(width: 14),

        // Animated Dots / Pills
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(indicatorCount, (idx) {
            final isActive = idx == _currentIndex;
            return GestureDetector(
              onTap: () {
                final width = MediaQuery.sizeOf(context).width;
                final cardWidth = _calculateCardWidth(width, cardsPerView);
                _scrollCardTo(idx, cardWidth, 16.0, totalItems, cardsPerView);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 3.5),
                width: isActive ? 22 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(width: 14),

        // Next Button
        _NavigationArrowButton(
          icon: Icons.arrow_forward_rounded,
          onTap: _goToNext,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. SECTION HEADER WITH GOOGLE TRUST RIBBON
// ─────────────────────────────────────────────────────────────────────────────

class _TestimonialsHeader extends StatelessWidget {
  final bool isMobile;
  const _TestimonialsHeader({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final content = Column(
      children: [
        // Google Reviews Trust Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(
                FontAwesomeIcons.google,
                size: 13,
                color: Color(0xFF4285F4),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (_) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 2),
                    child: Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: Color(0xFFF59E0B),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 8),
              Text(
                '4.9 / 5.0 (2,400+ Verified Patient Reviews)',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: isMobile ? 11 : 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Main Title
        Text(
          'Loved by Patients Across Andhra Pradesh',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: isMobile ? 22 : 30,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),

        // Subtitle
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Text(
            'Real stories of restored clarity, compassionate surgical care, and visual freedom from patients who trusted Rainbow Eye Hospital.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 12.5 : 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ),
      ],
    );

    if (reduceMotion) return content;

    return content
        .animate()
        .fadeIn(duration: 450.ms, curve: Curves.easeOutCubic)
        .slideY(
          begin: 0.06,
          end: 0,
          duration: 500.ms,
          curve: const Cubic(0.16, 1.0, 0.3, 1.0),
        );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. SPECIALTY FILTER PILLS BAR
// ─────────────────────────────────────────────────────────────────────────────

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
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: categories.map((cat) {
            final isSelected = cat == selectedCategory;
            return GestureDetector(
              onTap: () {
                onCategorySelected(cat);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.28),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. TESTIMONIAL CARD
// ─────────────────────────────────────────────────────────────────────────────

class _TestimonialCard extends StatefulWidget {
  final Testimonial testimonial;
  final bool isMobile;
  final double cardWidth;

  const _TestimonialCard({
    super.key,
    required this.testimonial,
    required this.isMobile,
    required this.cardWidth,
  });

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  void _showFullStoryModal() {
    final t = widget.testimonial;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              Row(
                children: [
                  _PatientAvatar(
                    testimonial: t,
                    radius: 26,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.patientName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          t.ageAndLocation,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  const FaIcon(
                    FontAwesomeIcons.google,
                    size: 16,
                    color: Color(0xFF4285F4),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: t.categoryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${t.treatment} • Treated by ${t.doctorTreated}',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: t.categoryColor,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Text(
                t.fullQuote,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF334155),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF10B981)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Verified Outcome: ${t.outcomeMetric}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF047857),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    showBookingDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Book Consultation with Specialist',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.testimonial;
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
          _showFullStoryModal();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: const Cubic(0.16, 1.0, 0.3, 1.0),
          transform: Matrix4.translationValues(0.0, yOffset, 0.0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isActive
                  ? t.categoryColor.withValues(alpha: 0.65)
                  : const Color(0xFFE2E8F0),
              width: isActive ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? t.categoryColor.withValues(alpha: 0.14)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: isActive ? 18 : 8,
                offset: Offset(0, isActive ? 6 : 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Top Row: 5 Stars + Google Verified Badge ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Stars
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (_) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 1.5),
                        child: Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: Color(0xFFF59E0B),
                        ),
                      );
                    }),
                  ),

                  // Google Verified Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4285F4).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF4285F4).withValues(alpha: 0.20),
                        width: 0.8,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.google,
                          size: 8.5,
                          color: Color(0xFF4285F4),
                        ),
                        SizedBox(width: 3.5),
                        Text(
                          'Verified',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4285F4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // ── 2. Treatment Tag & Review Date Row ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: t.categoryColor.withValues(alpha: 0.09),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: t.categoryColor.withValues(alpha: 0.22),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        t.treatment,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: t.categoryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    t.dateAgo,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // ── 3. Styled Quote Container with Patient Excerpt (Fills the Middle Space) ──
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 0.8,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quote Text with Quotation Icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.format_quote_rounded,
                            size: 15,
                            color: t.categoryColor.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              t.highlightSnippet,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                                height: 1.38,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Location & Patient Demographic Chip
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 11,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              t.ageAndLocation,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ── 4. Verified Outcome Trust Banner ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.22),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 12,
                      color: Color(0xFF10B981),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Outcome: ${t.outcomeMetric}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF047857),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // ── 5. Divider & Client Details Footnote ──
              Container(height: 1, color: const Color(0xFFF1F5F9)),
              const SizedBox(height: 8),

              Row(
                children: [
                  // Patient Real Photo Portrait
                  _PatientAvatar(
                    testimonial: t,
                    radius: 17,
                  ),
                  const SizedBox(width: 8),

                  // Patient name and doctor
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.patientName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Treated by ${t.doctorTreated}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Interactive Read Story CTA Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: t.categoryColor.withValues(alpha: isActive ? 0.16 : 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Story',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: t.categoryColor,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 8,
                          color: t.categoryColor,
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

// ─────────────────────────────────────────────────────────────────────────────
// 6. NAVIGATION ARROW BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class _NavigationArrowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavigationArrowButton({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_NavigationArrowButton> createState() => _NavigationArrowButtonState();
}

class _NavigationArrowButtonState extends State<_NavigationArrowButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 160),
          scale: _isPressed ? 0.90 : (_isHovered ? 1.08 : 1.0),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isHovered ? AppColors.primary : Colors.white,
              border: Border.all(
                color: _isHovered ? AppColors.primary : const Color(0xFFCBD5E1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _isHovered ? 0.12 : 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                widget.icon,
                size: 16,
                color: _isHovered ? Colors.white : const Color(0xFF475569),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 7. PATIENT PHOTO AVATAR WITH INITIALS FALLBACK
// ─────────────────────────────────────────────────────────────────────────────

class _PatientAvatar extends StatelessWidget {
  final Testimonial testimonial;
  final double radius;

  const _PatientAvatar({
    required this.testimonial,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: testimonial.categoryColor.withValues(alpha: 0.45),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          testimonial.imageAsset,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: testimonial.categoryColor.withValues(alpha: 0.14),
              alignment: Alignment.center,
              child: Text(
                testimonial.avatarInitials,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: radius * 0.7,
                  fontWeight: FontWeight.w700,
                  color: testimonial.categoryColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

