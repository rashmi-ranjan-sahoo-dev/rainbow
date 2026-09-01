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
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/section_navigator.dart';
import '../../../../shared/widgets/scroll_reveal.dart';
import '../booking/booking_modal.dart';
import 'google_reviews_service.dart';

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
  final String? profilePhotoUrl;
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
    this.profilePhotoUrl,
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

  static const List<Testimonial> curatedTestimonials = [
    Testimonial(
      id: 'google_rev_1',
      patientName: 'sai ligiberi',
      ageAndLocation: '3 reviews',
      treatment: 'Consultation & Eye Care',
      doctorTreated: 'Dr. Sukesh',
      outcomeMetric: 'Patient Consultation & Best Advice',
      rating: 5.0,
      highlightSnippet: '“Dr sukesh sir is soft spoken human being and highly qualified doctor. He always listens to problems very patiently.”',
      fullQuote:
          'Dr sukesh sir is soft spoken human being and highly qualified doctor.He always listens to problems very patiently,gives best advice,explains everything in clean manner Practically,one of the best ophthalmologist i highly recommend him',
      dateAgo: '4 months ago',
      avatarInitials: 'SL',
      imageAsset: '',
      categoryColor: Color(0xFF0284C7),
      procedureTag: 'Google Review',
      isVerifiedGoogle: true,
    ),
    Testimonial(
      id: 'google_rev_2',
      patientName: 'Tirupathi Rao Ganta',
      ageAndLocation: 'Local Guide • 16 reviews',
      treatment: 'Comprehensive Eye Treatment',
      doctorTreated: 'Rainbow Clinical Team',
      outcomeMetric: 'Smooth & Professional Treatment',
      rating: 5.0,
      highlightSnippet: '“Very good experience at RAINBOW EYE HOSPITAL.. The Doctors and staff were very caring and professional.”',
      fullQuote:
          'Very good experience at RAINBOW EYE HOSPITAL.. The Doctors and staff were very caring and professional. The hospital was clean and treatment was also smooth&Good.Highly recommended for your eye releted problems.',
      dateAgo: '3 months ago',
      avatarInitials: 'TG',
      imageAsset: '',
      categoryColor: Color(0xFF0D9488),
      procedureTag: 'Google Review',
      isVerifiedGoogle: true,
    ),
    Testimonial(
      id: 'google_rev_3',
      patientName: 'sumitra kasireddi',
      ageAndLocation: '8 reviews',
      treatment: 'LASIK Surgery Opinion',
      doctorTreated: 'Refractive Specialists',
      outcomeMetric: 'Quick Checkup & Best LASIK Guidance',
      rating: 5.0,
      highlightSnippet: '“I came for lasik surgery opinion. Doctors here are well experienced and suggested the best option for me.”',
      fullQuote:
          'I came for lasik surgery opinion. Doctors here are well experienced and suggested the best option for me. Polite staff, checkup and overall consultation was quick and very good.',
      dateAgo: '6 months ago',
      avatarInitials: 'SK',
      imageAsset: '',
      categoryColor: Color(0xFFD97706),
      procedureTag: 'Google Review',
      isVerifiedGoogle: true,
    ),
    Testimonial(
      id: 'google_rev_4',
      patientName: 'Kalla Tharun',
      ageAndLocation: '2 reviews',
      treatment: 'Inpatient & Clinical Care',
      doctorTreated: 'Floor Nursing & Surgical Team',
      outcomeMetric: 'Spotless Facility & Attentive Care',
      rating: 5.0,
      highlightSnippet: '“From the moment I checked in, the staff was professional, kind, and attentive. The facility was spotless.”',
      fullQuote:
          'I had a wonderful experience at Rainbow eye Hospital. From the moment I checked in, the staff was professional, kind, and attentive. A special thank you to the nursing team on the Floor they made me feel comfortable and well-cared for during a stressful time. The facility was spotless, and the level of communication regarding my treatment was excellent.',
      dateAgo: '7 months ago',
      avatarInitials: 'KT',
      imageAsset: '',
      categoryColor: Color(0xFF8B5CF6),
      procedureTag: 'Google Review',
      isVerifiedGoogle: true,
    ),
    Testimonial(
      id: 'google_rev_5',
      patientName: 'Venkatesh Kumar',
      ageAndLocation: '2 reviews',
      treatment: 'Cataract Surgery',
      doctorTreated: 'Cataract Specialists',
      outcomeMetric: 'Cataract Surgery • 100% Satisfaction',
      rating: 5.0,
      highlightSnippet: '“My father have under gone with cataract surgery they have treated us very well and taken very good care.”',
      fullQuote:
          'A very well experienced with this hospital my father have under gone with cataract surgery they have treated us very well and also taken a very good care of us .. recommend for best eye care',
      dateAgo: '3 months ago',
      avatarInitials: 'VK',
      imageAsset: '',
      categoryColor: Color(0xFFE11D48),
      procedureTag: 'Google Review',
      isVerifiedGoogle: true,
    ),
    Testimonial(
      id: 'google_rev_6',
      patientName: 'Shaik Akbar',
      ageAndLocation: 'Local Guide • 8 reviews',
      treatment: 'Clinical Treatment & Counseling',
      doctorTreated: 'Rainbow Medical Team',
      outcomeMetric: 'Clear Guidance & Curing Process',
      rating: 5.0,
      highlightSnippet: '“Staff and Doctors are so helpful in making us understand the situation and curing process. Very friendly!”',
      fullQuote:
          'Staff and Doctors are so helpful in making understand us about the situation and what is the curing process. They are so friendly and elaborate each and every point to make us understand.',
      dateAgo: '5 months ago',
      avatarInitials: 'SA',
      imageAsset: '',
      categoryColor: Color(0xFF0284C7),
      procedureTag: 'Google Review',
      isVerifiedGoogle: true,
    ),
    Testimonial(
      id: 'google_rev_7',
      patientName: 'Ganga Yerraiah',
      ageAndLocation: '6 reviews',
      treatment: 'General Eye Examination',
      doctorTreated: 'Clinical Specialists',
      outcomeMetric: 'Trained Staff • Quality Treatment',
      rating: 5.0,
      highlightSnippet: '“Way of behaviour and treatment is good. Well trained staff.”',
      fullQuote:
          'Way of behaviour and treatment is good. Well trained staff',
      dateAgo: '1 month ago',
      avatarInitials: 'GY',
      imageAsset: '',
      categoryColor: Color(0xFF0D9488),
      procedureTag: 'Google Review',
      isVerifiedGoogle: true,
    ),
    Testimonial(
      id: 'google_rev_8',
      patientName: 'srujan kumar',
      ageAndLocation: '5 reviews',
      treatment: 'Eye Checkup & Diagnosis',
      doctorTreated: 'Ophthalmic Team',
      outcomeMetric: 'Knowledgeable Doctors & Polite Staff',
      rating: 5.0,
      highlightSnippet: '“Very politest staff and well maintained hospital and well knowledge Doctors and helpful.”',
      fullQuote:
          'Very politest staff and well maintained hospital and well knowledge Doctors and helpful',
      dateAgo: '3 months ago',
      avatarInitials: 'SK',
      imageAsset: '',
      categoryColor: Color(0xFFD97706),
      procedureTag: 'Google Review',
      isVerifiedGoogle: true,
    ),
    Testimonial(
      id: 'google_rev_9',
      patientName: 'kalla satish kumar',
      ageAndLocation: '8 reviews',
      treatment: 'Doctor Consultation & Counseling',
      doctorTreated: 'Consultation & Diagnostics',
      outcomeMetric: 'Excellent Consultation & Quick Response',
      rating: 5.0,
      highlightSnippet: '“Doctor consultation and counseling is excellent... Staff behaviour and response is also good...”',
      fullQuote:
          'Doctor consultation and counseling is excellent... Staff behaviour and response is also good...',
      dateAgo: '4 months ago',
      avatarInitials: 'KS',
      imageAsset: '',
      categoryColor: Color(0xFF8B5CF6),
      procedureTag: 'Google Review',
      isVerifiedGoogle: true,
    ),
  ];

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  Timer? _autoPlayTimer;
  bool _isUserInteracting = false;
  bool _isLoading = true;
  double _googleRating = 4.9;
  int _googleTotalReviews = 248;
  String _googleMapsUrl = GoogleReviewsService.officialGoogleMapsUrl;
  List<Testimonial> _testimonials = TestimonialsSection.curatedTestimonials;
  bool _isLiveGoogle = false;

  @override
  void initState() {
    super.initState();
    _loadLiveGoogleReviews();
    _startAutoPlay();
  }

  Future<void> _loadLiveGoogleReviews() async {
    try {
      final res = await GoogleReviewsService.fetchReviews();
      if (!mounted) return;
      setState(() {
        _testimonials = res.testimonials;
        _googleRating = res.rating;
        _googleTotalReviews = res.totalReviews;
        _googleMapsUrl = res.googleMapsUrl;
        _isLiveGoogle = res.isLiveFromGoogle;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
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

  List<Testimonial> get _filteredTestimonials => _testimonials;

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
                child: _TestimonialsHeader(
                  isMobile: isMobile,
                  rating: _googleRating,
                  totalReviews: _googleTotalReviews,
                  isLive: _isLiveGoogle,
                ),
              ),

              SizedBox(height: isMobile ? 24 : 36),

              // ── 2. Responsive PageView Showcase ──
              AnimatedOpacity(
                duration: const Duration(milliseconds: 350),
                opacity: _isLoading ? 0.7 : 1.0,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return _buildResponsiveShowcase(
                      containerWidth: constraints.maxWidth,
                      isMobile: isMobile,
                      cardsPerView: cardsPerView,
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ── 3. Interactive Bottom Controls (Arrows + Page Indicators) ──
              if (totalPages > 1)
                _buildBottomControls(
                  totalPages: totalPages,
                  isMobile: isMobile,
                ),

              const SizedBox(height: 28),

              // ── 4. "See More Reviews on Google" CTA Button ──
              _GoogleReviewsCtaButton(
                googleMapsUrl: _googleMapsUrl,
                rating: _googleRating,
                totalReviews: _googleTotalReviews,
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
  final double rating;
  final int totalReviews;
  final bool isLive;

  const _TestimonialsHeader({
    required this.isMobile,
    required this.rating,
    required this.totalReviews,
    required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Verified Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
            ),
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
                color: Color(0xFFEA4335),
              ),
              const SizedBox(width: 8),
              Text(
                '★ ${rating.toStringAsFixed(1)} RATING • $totalReviews+ VERIFIED REVIEWS',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: const Color(0xFF0F172A),
                  fontSize: isMobile ? 10.5 : 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
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
                          children: List.generate(5, (index) {
                            final filled = index < t.rating.floor();
                            return Padding(
                              padding: const EdgeInsets.only(right: 1.5),
                              child: Icon(
                                filled ? Icons.star_rounded : Icons.star_half_rounded,
                                size: 16,
                                color: const Color(0xFFF59E0B),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                t.patientName,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            if (t.isVerifiedGoogle) ...[
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified_rounded,
                                size: 15,
                                color: Color(0xFF0284C7),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          '${t.ageAndLocation} • ${t.dateAgo}',
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
                        'Verified Patient Review • ${t.outcomeMetric}',
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
                          children: List.generate(5, (index) {
                            final filled = index < t.rating.floor();
                            return Padding(
                              padding: const EdgeInsets.only(right: 1.5),
                              child: Icon(
                                filled ? Icons.star_rounded : Icons.star_half_rounded,
                                size: 15,
                                color: const Color(0xFFF59E0B),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 2),

                        // Patient Name
                        Row(
                          children: [
                            Flexible(
                              child: Text(
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
                            ),
                            if (t.isVerifiedGoogle) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified_rounded,
                                size: 13,
                                color: Color(0xFF0284C7),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 1.5),

                        // Subtitle / Location / Treatment
                        Text(
                          t.ageAndLocation.contains('review')
                              ? '${t.ageAndLocation} • ${t.dateAgo}'
                              : '${t.ageAndLocation.split('•').last.trim()} • ${t.dateAgo}',
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
// 5. "SEE MORE REVIEWS ON GOOGLE" CTA BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class _GoogleReviewsCtaButton extends StatefulWidget {
  final String googleMapsUrl;
  final double rating;
  final int totalReviews;
  final bool isMobile;

  const _GoogleReviewsCtaButton({
    required this.googleMapsUrl,
    required this.rating,
    required this.totalReviews,
    required this.isMobile,
  });

  @override
  State<_GoogleReviewsCtaButton> createState() => _GoogleReviewsCtaButtonState();
}

class _GoogleReviewsCtaButtonState extends State<_GoogleReviewsCtaButton> {
  bool _isHovered = false;

  Future<void> _launchGoogleReviews() async {
    final uri = Uri.parse(widget.googleMapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _launchGoogleReviews,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 18 : 24,
            vertical: widget.isMobile ? 11 : 13,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: _isHovered ? AppColors.primary : const Color(0xFFE2E8F0),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: _isHovered ? 16 : 8,
                offset: Offset(0, _isHovered ? 5 : 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(
                FontAwesomeIcons.google,
                size: 15,
                color: Color(0xFFEA4335),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 3),
                    Text(
                      widget.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'See More Reviews on Google',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: widget.isMobile ? 12.5 : 14,
                  fontWeight: FontWeight.w600,
                  color: _isHovered ? AppColors.primary : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.open_in_new_rounded,
                size: 14,
                color: _isHovered ? AppColors.primary : const Color(0xFF64748B),
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
// 7. PATIENT PHOTO AVATAR WITH INITIALS / NETWORK IMAGE FALLBACK
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
        child: _buildAvatarImage(),
      ),
    );
  }

  Widget _buildAvatarImage() {
    // 1. Google Profile Photo URL
    if (testimonial.profilePhotoUrl != null && testimonial.profilePhotoUrl!.isNotEmpty) {
      return Image.network(
        testimonial.profilePhotoUrl!,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildInitials(),
      );
    }

    // 2. Local Asset Image
    if (testimonial.imageAsset.isNotEmpty) {
      return Image.asset(
        testimonial.imageAsset,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildInitials(),
      );
    }

    // 3. Fallback Initials Avatar with branded category color gradient
    return _buildInitials();
  }

  Widget _buildInitials() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            testimonial.categoryColor.withValues(alpha: 0.18),
            testimonial.categoryColor.withValues(alpha: 0.32),
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        testimonial.avatarInitials,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: radius * 0.68,
          fontWeight: FontWeight.w800,
          color: testimonial.categoryColor,
        ),
      ),
    );
  }
}

