// ─────────────────────────────────────────────────────────────────────────────
// REFERENCE PATTERN & RATIONALE:
//   • Clean, Modern Testimonials: Photo, 5 Stars Rating, Name & Subtitle,
//     and Feedback Quote.
//   • Responsive Breakdown:
//     - Desktop (>= 1080px): Exactly 3 cards per page in a smooth PageView carousel.
//     - Tablet (650px - 1079px): Exactly 2 cards per page side-by-side.
//     - Mobile (< 650px): Exactly 1 full-width card per page with crisp snapping
//       (eliminates half-screen cut-offs and scroll misalignment).
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/section_navigator.dart';
import '../../../../shared/widgets/scroll_reveal.dart';
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
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  Timer? _autoPlayTimer;
  bool _isUserInteracting = false;

  static const List<Testimonial> _allTestimonials = [
    Testimonial(
      id: 'test_1',
      patientName: 'Ravi Kumar S.',
      ageAndLocation: '32 Yrs • Visakhapatnam',
      treatment: 'Contoura Vision LASIK',
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
      treatment: 'Micro-Incision Cataract',
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
      treatment: 'Emergency Retina Laser',
      doctorTreated: 'Dr. Ananya Iyer',
      outcomeMetric: 'Retina Saved • 100% Sight Preserved',
      rating: 5.0,
      highlightSnippet: '“Sunday emergency retina triage caught my retinal tear just in time and saved my eye.”',
      fullQuote:
          'I noticed sudden black curtain floaters and severe flashes on a Sunday evening. Rainbow Eye Hospital’s emergency retina team attended to me immediately. Dr. Ananya Iyer performed a precision green barrage laser within 2 hours, preventing permanent retinal detachment. Her surgical expertise is second to none.',
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
      treatment: 'Advanced Glaucoma Valve',
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
      ageAndLocation: '28 Yrs • Madhurawada',
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
      ageAndLocation: '34 Yrs • Lawsons Bay',
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
      ageAndLocation: '45 Yrs • MVP Colony',
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

  List<Testimonial> get _filteredTestimonials => _allTestimonials;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(milliseconds: 3500), (timer) {
      if (!mounted || _isUserInteracting || !_pageController.hasClients) return;
      final totalPages = _getTotalPages();
      if (totalPages <= 1) return;

      final nextPage = (_currentPageIndex + 1) % totalPages;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    super.dispose();
  }

  int _getCardsPerView(double width) {
    if (width >= 1080) return 3;
    if (width >= 650) return 2;
    return 1;
  }

  int _getTotalPages() {
    final width = MediaQuery.sizeOf(context).width;
    final cardsPerView = _getCardsPerView(width);
    final totalItems = _filteredTestimonials.length;
    if (totalItems == 0) return 1;
    return (totalItems / cardsPerView).ceil();
  }

  void _goToPrevious() {
    final totalPages = _getTotalPages();
    if (totalPages <= 1 || !_pageController.hasClients) return;

    final prevPage = (_currentPageIndex - 1 + totalPages) % totalPages;
    _pageController.animateToPage(
      prevPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
    _startAutoPlay();
  }

  void _goToNext() {
    final totalPages = _getTotalPages();
    if (totalPages <= 1 || !_pageController.hasClients) return;

    final nextPage = (_currentPageIndex + 1) % totalPages;
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
    _startAutoPlay();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 650;
    final cardsPerView = _getCardsPerView(screenWidth);
    final totalPages = _getTotalPages();

    return Container(
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
              // ── 1. Section Header (ScrollReveal) ──
              ScrollReveal(
                duration: const Duration(milliseconds: 600),
                slideOffset: 0.06,
                child: _TestimonialsHeader(isMobile: isMobile),
              ),

              SizedBox(height: isMobile ? 24 : 36),

              // ── 2. Responsive PageView Showcase ──
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
              if (totalPages > 1)
                _buildBottomControls(
                  totalPages: totalPages,
                  isMobile: isMobile,
                ),
            ],
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
        alignment: Alignment.center,
        child: const Text(
          'No reviews in this category yet.',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFF64748B),
            fontSize: 14,
          ),
        ),
      );
    }

    final double cardHeight = isMobile ? 180.0 : 170.0;
    final totalPages = (list.length / cardsPerView).ceil();

    return MouseRegion(
      onEnter: (_) => _isUserInteracting = true,
      onExit: (_) => _isUserInteracting = false,
      child: SizedBox(
        height: cardHeight,
        child: PageView.builder(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          itemCount: totalPages,
          onPageChanged: (idx) {
            setState(() => _currentPageIndex = idx);
          },
          itemBuilder: (context, pageIndex) {
            final startIndex = pageIndex * cardsPerView;
            final pageItems = list.skip(startIndex).take(cardsPerView).toList();

            if (cardsPerView == 1) {
              // Mobile: Exactly 1 card filling the full container width with zero cutoff
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: _TestimonialCard(
                  key: ValueKey('test_card_${pageItems[0].id}'),
                  testimonial: pageItems[0],
                  isMobile: true,
                ),
              );
            }

            // Tablet / Desktop: Multiple cards side-by-side with clean spacing
            const gap = 16.0;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(cardsPerView, (i) {
                if (i < pageItems.length) {
                  final item = pageItems[i];
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: i == 0 ? 0 : gap / 2,
                        right: i == cardsPerView - 1 ? 0 : gap / 2,
                      ),
                      child: _TestimonialCard(
                        key: ValueKey('test_card_${item.id}'),
                        testimonial: item,
                        isMobile: false,
                      ),
                    ),
                  );
                } else {
                  // Transparent placeholder for unfilled slot in last page
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: i == 0 ? 0 : gap / 2,
                        right: i == cardsPerView - 1 ? 0 : gap / 2,
                      ),
                      child: const SizedBox.shrink(),
                    ),
                  );
                }
              }),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomControls({
    required int totalPages,
    required bool isMobile,
  }) {
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
          children: List.generate(totalPages, (idx) {
            final isActive = idx == _currentPageIndex;
            return GestureDetector(
              onTap: () {
                if (_pageController.hasClients) {
                  _pageController.animateToPage(
                    idx,
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeOutCubic,
                  );
                }
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
// 3. SECTION HEADER (Clean Eyebrow + Bold Title)
// ─────────────────────────────────────────────────────────────────────────────

class _TestimonialsHeader extends StatelessWidget {
  final bool isMobile;
  const _TestimonialsHeader({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Clean Eyebrow Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.20),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(
                FontAwesomeIcons.heartPulse,
                size: 11,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'PATIENT STORIES & EXPERIENCES',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.primary,
                  fontSize: isMobile ? 11 : 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
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
            fontSize: isMobile ? 22 : 32,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. CLEAN, MODERN TESTIMONIAL CARD (PHOTO, RATINGS, NAME, FEEDBACK)
// ─────────────────────────────────────────────────────────────────────────────

class _TestimonialCard extends StatefulWidget {
  final Testimonial testimonial;
  final bool isMobile;

  const _TestimonialCard({
    super.key,
    required this.testimonial,
    required this.isMobile,
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
                        // Stars
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (_) {
                            return const Padding(
                              padding: EdgeInsets.only(right: 1.5),
                              child: Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: Color(0xFFF59E0B),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 3),
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
                          '${t.ageAndLocation} • ${t.treatment}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                '“${t.fullQuote}”',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
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
                        'Verified Clinical Outcome: ${t.outcomeMetric}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
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
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0.0, yOffset, 0.0),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 15 : 18,
            vertical: widget.isMobile ? 12 : 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isActive
                  ? AppColors.primary.withValues(alpha: 0.50)
                  : const Color(0xFFE2E8F0),
              width: isActive ? 1.4 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.035),
                blurRadius: isActive ? 18 : 8,
                offset: Offset(0, isActive ? 6 : 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Top Row: Patient Photo + (Ratings, Name, Subtitle) ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Photo Avatar
                  _PatientAvatar(
                    testimonial: t,
                    radius: widget.isMobile ? 22 : 25,
                  ),
                  const SizedBox(width: 12),

                  // Ratings, Name & Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 5 Stars
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (_) {
                            return const Padding(
                              padding: EdgeInsets.only(right: 1.5),
                              child: Icon(
                                Icons.star_rounded,
                                size: 15,
                                color: Color(0xFFF59E0B),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 2),

                        // Patient Name
                        Text(
                          t.patientName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: widget.isMobile ? 14 : 14.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 1.5),

                        // Subtitle / Location / Treatment
                        Text(
                          '${t.ageAndLocation.split('•').last.trim()} • ${t.treatment}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: widget.isMobile ? 10.5 : 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ── 2. Feedback Quote ──
              Expanded(
                child: Text(
                  '“${t.fullQuote}”',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: widget.isMobile ? 12.0 : 12.5,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF475569),
                    height: 1.45,
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
          color: const Color(0xFFE2E8F0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
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
              color: AppColors.primary.withValues(alpha: 0.12),
              alignment: Alignment.center,
              child: Text(
                testimonial.avatarInitials,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: radius * 0.7,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
