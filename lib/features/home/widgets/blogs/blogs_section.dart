// ─────────────────────────────────────────────────────────────────────────────
// REFERENCE PATTERN & RATIONALE:
//   • Pattern: "Rainbow Clinical Knowledge Base & Medical Research Showcase with
//     Dual Stepped Infinite Scrolling Rows, Featured Clinical Imagery between
//     content and doctor author, In-App Article Reader, and Category Filters."
//   • Motion Stack:
//     - Line 1 (Upper Row): Steps left-to-right every 2s with easeInOutCubic curve.
//     - Line 2 (Lower Row): Steps right-to-left every 2s with easeInOutCubic curve.
//     - Pause on mouse hover & touch drag for smooth reading.
//   • Responsive Breakdown:
//     - PC / Laptop (>= 1100px): Exactly 3 cards visible.
//     - Tablet (650px - 1099px): Exactly 2 cards visible.
//     - Mobile (< 650px): Exactly 1 card visible (84% peek width).
//   • Sizing: Compact proportions with featured clinical image in between excerpt
//     and doctor footer.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/section_navigator.dart';
import '../booking/booking_modal.dart';

/// Direction for stepped infinite auto-scroll tracks.
enum BlogMarqueeDirection { leftToRight, rightToLeft }

// ─────────────────────────────────────────────────────────────────────────────
// 1. DATA MODEL FOR CLINICAL BLOGS & KNOWLEDGE BASE
// ─────────────────────────────────────────────────────────────────────────────

class BlogArticle {
  final String id;
  final String title;
  final String summary;
  final String fullContent;
  final String category;
  final String author;
  final String authorRole;
  final String publishedDate;
  final String readTime;
  final String hospitalBadge;
  final String imageAsset;
  final String doctorAsset;
  final Color categoryColor;
  final IconData iconData;
  final List<String> keyTakeaways;

  const BlogArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.fullContent,
    required this.category,
    required this.author,
    required this.authorRole,
    required this.publishedDate,
    required this.readTime,
    this.hospitalBadge = 'Rainbow Eye Research',
    required this.imageAsset,
    required this.doctorAsset,
    required this.categoryColor,
    required this.iconData,
    required this.keyTakeaways,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. MAIN BLOGS SECTION WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class BlogsSection extends StatefulWidget {
  const BlogsSection({super.key});

  @override
  State<BlogsSection> createState() => _BlogsSectionState();
}

class _BlogsSectionState extends State<BlogsSection> {
  String _selectedCategory = 'All';
  int _visibilityEpoch = 0;
  bool _isInView = false;

  static const List<String> _categories = [
    'All',
    'Laser & SMILE',
    'Cataract & Retina',
    'Pediatric Care',
    'Digital Eye Health',
  ];

  static const List<BlogArticle> _allArticles = [
    BlogArticle(
      id: 'blog_1',
      title: 'At What Age Should Squint (Strabismus) Treatment Be Done?',
      summary:
          'Early intervention is critical. Learn why pediatric ophthalmologists recommend squint correction before age 7 to preserve 3D stereoscopic vision.',
      fullContent:
          'Squint (Strabismus) is a condition where both eyes do not align simultaneously. Pediatric ophthalmologists at Rainbow Eye Hospital emphasize that treatment should begin as early as possible — ideally between 6 months and 7 years of age.\n\nLeaving squint untreated during early neural development can cause the brain to ignore input from the misaligned eye, leading to Amblyopia (lazy eye) and permanent loss of binocular 3D vision. Modern squint correction incorporates custom optical lenses, prism therapy, patching protocols, and microscopic muscle re-alignment surgery with rapid next-day discharge.',
      category: 'Pediatric Care',
      author: 'Dr. Priya Sharma',
      authorRole: 'Pediatric Strabismus Specialist',
      publishedDate: 'Aug 24, 2026',
      readTime: '4 min read',
      hospitalBadge: 'Rainbow Pediatric Clinic',
      imageAsset: 'assets/images/blog_squint_pediatric.jpg',
      doctorAsset: 'assets/images/doctor_priya_sharma.jpg',
      categoryColor: Color(0xFF8B5CF6),
      iconData: Icons.child_care_rounded,
      keyTakeaways: [
        'Critical window for best visual outcomes is before age 7.',
        'Early patching & prism therapy can avoid surgical intervention.',
        'Micro-muscle surgery offers 98%+ precision alignment.',
      ],
    ),
    BlogArticle(
      id: 'blog_2',
      title: 'What is the Blind Spot of the Eye & How Does Vision Compensate?',
      summary:
          'Explore the optic disc where nerve fibers exit without photoreceptors, and how the visual cortex seamlessly interpolates missing sight details.',
      fullContent:
          'The physiological blind spot (scotoma) is an anatomical feature present in every human eye. It corresponds to the optic disc — the exact point where 1.2 million optic nerve fibers exit the retina to transmit visual signals to the brain.\n\nBecause this area contains no light-detecting rod or cone photoreceptor cells, no image is formed here. However, our visual cortex utilizes binocular overlapping fields and predictive perceptual interpolation to seamlessly fill in the gap. Regular dilated retinal evaluations ensure this natural blind spot is distinguished from pathological scotomas caused by glaucoma or retinal detachment.',
      category: 'Cataract & Retina',
      author: 'Dr. Ananya Iyer',
      authorRole: 'Vitreo-Retinal Surgeon',
      publishedDate: 'Aug 21, 2026',
      readTime: '5 min read',
      hospitalBadge: 'Rainbow Retina Centre',
      imageAsset: 'assets/images/blog_blind_spot.jpg',
      doctorAsset: 'assets/images/doctor_ananya_iyer.jpg',
      categoryColor: Color(0xFFE11D48),
      iconData: Icons.remove_red_eye_outlined,
      keyTakeaways: [
        'Natural optic disc lacks rod and cone photoreceptors.',
        'Brain fills the gap using bilateral field overlap.',
        'Distinguishing natural blind spots from retinal pathology is vital.',
      ],
    ),
    BlogArticle(
      id: 'blog_3',
      title: 'How to Avoid Digital Eye Strain in 10+ Hour Screen Work',
      summary:
          'Evidence-based ergonomics: The 20-20-20 rule, contrast optimization, artificial tear protocols, and how blue light management relieves asthenopia.',
      fullContent:
          'With IT professionals and students spending over 10 hours daily on digital displays, Computer Vision Syndrome (CVS) has become widespread. Display viewing reduces natural blink rate from 16–20 blinks/min to under 6 blinks/min, causing rapid tear film evaporation and corneal surface dryness.\n\nRainbow Eye Hospital’s refractive specialists recommend:\n1. The 20-20-20 Rule: Every 20 minutes, gaze at an object 20 feet away for 20 seconds.\n2. Preservative-free lubricating eye drops.\n3. Display positioned 20–28 inches away at a 15-degree downward angle.\n4. Matte anti-glare filters to eliminate harsh overhead reflections.',
      category: 'Digital Eye Health',
      author: 'Dr. Arjun Mehta',
      authorRole: 'Refractive & Cornea Specialist',
      publishedDate: 'Aug 20, 2026',
      readTime: '3 min read',
      hospitalBadge: 'Rainbow Wellness Guide',
      imageAsset: 'assets/images/blog_digital_eyestrain.jpg',
      doctorAsset: 'assets/images/doctor_arjun_mehta.jpg',
      categoryColor: Color(0xFF0284C7),
      iconData: Icons.laptop_chromebook_rounded,
      keyTakeaways: [
        'Blink rate drops by 65% during intensive computer screen work.',
        'Follow 20-20-20 rule to relax ciliary accommodative muscles.',
        'Use preservative-free ocular lubricants for lasting tear stability.',
      ],
    ),
    BlogArticle(
      id: 'blog_4',
      title: 'Comprehensive Guide to Blade-Free SMILE Pro vs Contoura LASIK',
      summary:
          'Comparing keyhole lenticule extraction with topography-guided ablation. Understand flapless stability and next-day visual recovery.',
      fullContent:
          'Carl Zeiss SMILE Pro represents the 3rd generation of laser vision correction. Unlike traditional LASIK which creates a 20mm corneal flap, SMILE Pro creates a microscopic 2mm keyhole incision using high-frequency femtosecond lasers in under 9 seconds.\n\nKey Advantages of SMILE Pro:\n• Flapless: Zero risk of traumatic flap dislodgement during sports or active lifestyle.\n• Biomechanical Strength: Preserves 80% more anterior corneal stroma.\n• Dry Eye Prevention: Leaves superficial sub-basal corneal nerves intact, preventing chronic postoperative dryness.\n• Faster Clarity: Most patients achieve 6/6 or sharper vision by the next morning.',
      category: 'Laser & SMILE',
      author: 'Dr. Rajesh Varma',
      authorRole: 'Chief Refractive Surgeon',
      publishedDate: 'Aug 18, 2026',
      readTime: '6 min read',
      hospitalBadge: 'Rainbow LASIK Suite',
      imageAsset: 'assets/images/blog_smile_lasik.jpg',
      doctorAsset: 'assets/images/doctor_rajesh_varma.jpg',
      categoryColor: Color(0xFFD97706),
      iconData: Icons.flash_on_rounded,
      keyTakeaways: [
        'SMILE Pro uses a 2mm micro-incision with zero flap creation.',
        'Preserves maximum corneal biomechanical stability.',
        'Back to work and screen use within 24–48 hours.',
      ],
    ),
    BlogArticle(
      id: 'blog_5',
      title: 'Senior Tips to Beat the Heat, Protect Vision & Manage Cataracts',
      summary:
          'How UV radiation accelerates cataract density and why stitchless micro-incision phacoemulsification with premium IOLs restores spectacle-free sight.',
      fullContent:
          'High summer temperatures and prolonged UV-A/UV-B radiation accelerate oxidative stress within the natural crystalline lens, speeding up cataract clouding in seniors aged 50+.\n\nModern Micro-Incision Cataract Surgery (MICS) at Rainbow Eye Hospital uses robotic phacoemulsification through a 1.8mm incision. The clouded lens is gently dissolved and replaced with advanced Toric, Trifocal, or Extended Depth of Focus (EDOF) intraocular lens implants, restoring crystal-clear distance, intermediate computer, and near reading vision without glasses.',
      category: 'Cataract & Retina',
      author: 'Dr. Suresh Nair',
      authorRole: 'Glaucoma & Senior Eye Care',
      publishedDate: 'Aug 14, 2026',
      readTime: '4 min read',
      hospitalBadge: 'Rainbow Senior Care',
      imageAsset: 'assets/images/blog_cataract_senior.jpg',
      doctorAsset: 'assets/images/doctor_suresh_nair.jpg',
      categoryColor: Color(0xFF059669),
      iconData: Icons.elderly_rounded,
      keyTakeaways: [
        '100% UV400 sunglasses prevent accelerated cataract progression.',
        'Stitchless MICS takes under 15 minutes under topical drop anesthesia.',
        'Premium Trifocal IOLs eliminate need for reading glasses.',
      ],
    ),
    BlogArticle(
      id: 'blog_6',
      title: 'Early Warning Signs of Retinal Tears & Diabetic Retinopathy',
      summary:
          'Sudden dark floaters, peripheral light flashes, or shadow curtains require rapid laser triage. Learn how green barrage photocoagulation preserves permanent vision.',
      fullContent:
          'The retina is the neurosensory photographic film of the eye. Retinal tears and diabetic micro-aneurysms develop silently without pain, making early symptom awareness critical for sight preservation.\n\nEmergency Symptoms Requiring Same-Day Evaluation:\n1. Sudden appearance of dense cobweb floaters.\n2. Arcs of bright light flashing in peripheral vision.\n3. A dark curtain or shadow falling across your field of view.\n\nRainbow Eye Hospital’s 24x7 retina unit utilizes 3D high-resolution Spectral OCT and argon green laser photocoagulation to seal retinal breaks and prevent complete retinal detachment.',
      category: 'Cataract & Retina',
      author: 'Dr. Ananya Iyer',
      authorRole: 'Vitreo-Retina Consultant',
      publishedDate: 'Aug 10, 2026',
      readTime: '5 min read',
      hospitalBadge: 'Rainbow Emergency Retina',
      imageAsset: 'assets/images/blog_retinal_tears.jpg',
      doctorAsset: 'assets/images/doctor_ananya_iyer.jpg',
      categoryColor: Color(0xFFE11D48),
      iconData: Icons.healing_rounded,
      keyTakeaways: [
        'Flashes and floaters indicate vitreoretinal traction.',
        'Prompt green laser treatment takes 10 mins and avoids major surgery.',
        'Diabetic patients require comprehensive dilated fundus exams yearly.',
      ],
    ),
  ];

  static final List<BlogArticle> _upperArticles = [
    _allArticles[0],
    _allArticles[1],
    _allArticles[2],
  ];

  static final List<BlogArticle> _lowerArticles = [
    _allArticles[3],
    _allArticles[4],
    _allArticles[5],
  ];

  List<BlogArticle> get _filteredArticles {
    if (_selectedCategory == 'All') return _allArticles;
    return _allArticles.where((a) => a.category == _selectedCategory).toList();
  }

  void _showArticleReader(BlogArticle article) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BlogReaderModal(article: article),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 650;
    final isTablet = screenWidth >= 650 && screenWidth < 1100;

    // Card width calculation:
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

    final double rowHeight = isMobile ? 324.0 : 316.0;
    const double cardSpacing = 16.0;

    return VisibilityDetector(
      key: const Key('blogs_section_visibility_detector'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.08) {
          if (!_isInView && mounted) {
            setState(() {
              _isInView = true;
              _visibilityEpoch++;
            });
          }
        }
      },
      child: Container(
        key: SectionNavigator.blogsKey,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.divider.withValues(alpha: 0.7)),
            bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.7)),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 40 : 64,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── 1. Section Header & Clinical Knowledge Eyebrow ──
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.horizontalPadding(context),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1320),
                child: Column(
                  children: [
                    _BlogsHeader(
                      key: ValueKey('blogs_header_$_visibilityEpoch'),
                      isMobile: isMobile,
                    ),

                    const SizedBox(height: 20),

                    // ── 2. Specialty Category Filter Bar ──
                    _CategoryFilterBar(
                      categories: _categories,
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (cat) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: isMobile ? 20 : 28),

            // ── 3. Dual Stepped Infinite Scroll Rows (2s Auto-Step) ──
            if (_selectedCategory == 'All') ...[
              // Line 1: Upper Row (Steps smoothly Left-to-Right every 2s)
              _SteppedInfiniteBlogRow(
                key: const ValueKey('blog_upper_stream_all'),
                items: _upperArticles,
                direction: BlogMarqueeDirection.leftToRight,
                cardWidth: cardWidth,
                cardSpacing: cardSpacing,
                height: rowHeight,
                onCardTap: _showArticleReader,
              ),

              SizedBox(height: isMobile ? 12 : 16),

              // Line 2: Lower Row (Steps smoothly Right-to-Left every 2s)
              _SteppedInfiniteBlogRow(
                key: const ValueKey('blog_lower_stream_all'),
                items: _lowerArticles,
                direction: BlogMarqueeDirection.rightToLeft,
                cardWidth: cardWidth,
                cardSpacing: cardSpacing,
                height: rowHeight,
                onCardTap: _showArticleReader,
              ),
            ] else ...[
              // Filtered Category Stream
              _SteppedInfiniteBlogRow(
                key: ValueKey('blog_filtered_stream_$_selectedCategory'),
                items: _filteredArticles,
                direction: BlogMarqueeDirection.leftToRight,
                cardWidth: cardWidth,
                cardSpacing: cardSpacing,
                height: rowHeight,
                onCardTap: _showArticleReader,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. STEPPED INFINITE AUTO-SCROLLING ROW (Dual Stream Animation)
// ─────────────────────────────────────────────────────────────────────────────

class _SteppedInfiniteBlogRow extends StatefulWidget {
  final List<BlogArticle> items;
  final BlogMarqueeDirection direction;
  final double cardWidth;
  final double cardSpacing;
  final double height;
  final ValueChanged<BlogArticle> onCardTap;

  static const Duration _stepInterval = Duration(seconds: 2);
  static const Duration _stepDuration = Duration(milliseconds: 850);

  const _SteppedInfiniteBlogRow({
    super.key,
    required this.items,
    required this.direction,
    required this.cardWidth,
    required this.cardSpacing,
    required this.height,
    required this.onCardTap,
  });

  @override
  State<_SteppedInfiniteBlogRow> createState() => _SteppedInfiniteBlogRowState();
}

class _SteppedInfiniteBlogRowState extends State<_SteppedInfiniteBlogRow> {
  late final ScrollController _scrollController;
  Timer? _timer;
  bool _isHovered = false;
  bool _isAnimating = false;

  static const int _bufferMultiplier = 16;

  double get _stride => widget.cardWidth + widget.cardSpacing;
  double get _singleSetWidth => widget.items.length * _stride;

  List<BlogArticle> get _bufferedItems {
    if (widget.items.isEmpty) return [];
    final list = <BlogArticle>[];
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
    _timer = Timer.periodic(_SteppedInfiniteBlogRow._stepInterval, (timer) {
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

    if (widget.direction == BlogMarqueeDirection.rightToLeft) {
      targetOffset = currentOffset + _stride;
    } else {
      targetOffset = currentOffset - _stride;
    }

    try {
      await _scrollController.animateTo(
        targetOffset,
        duration: _SteppedInfiniteBlogRow._stepDuration,
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
            final article = items[index];
            return SizedBox(
              width: widget.cardWidth,
              height: widget.height - 8,
              child: _CompactBlogCard(
                article: article,
                onTap: () => widget.onCardTap(article),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. COMPACT SLEEK BLOG CARD COMPONENT WITH FEATURED IMAGE
// ─────────────────────────────────────────────────────────────────────────────

class _CompactBlogCard extends StatefulWidget {
  final BlogArticle article;
  final VoidCallback onTap;

  const _CompactBlogCard({
    required this.article,
    required this.onTap,
  });

  @override
  State<_CompactBlogCard> createState() => _CompactBlogCardState();
}

class _CompactBlogCardState extends State<_CompactBlogCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.article;
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
                  ? a.categoryColor.withValues(alpha: 0.65)
                  : const Color(0xFFE2E8F0),
              width: isActive ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? a.categoryColor.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: isActive ? 14 : 6,
                offset: Offset(0, isActive ? 5 : 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ── 1. Top Section: Category Tag + Read Time + Title + Excerpt ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Category Tag Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: a.categoryColor.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: a.categoryColor.withValues(alpha: 0.22),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              a.iconData,
                              size: 10,
                              color: a.categoryColor,
                            ),
                            const SizedBox(width: 3.5),
                            Text(
                              a.category,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: a.categoryColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Read Time Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 9.5,
                              color: Color(0xFF64748B),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              a.readTime,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Article Title (2 lines max)
                  Text(
                    a.title,
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

                  // Article Summary Excerpt (2 lines max)
                  Text(
                    a.summary,
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

              // ── 2. Middle Section: Related Blog Featured Image ──
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: a.categoryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Featured Blog Image
                        Image.asset(
                          a.imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, error, stackTrace) => Container(
                            color: a.categoryColor.withValues(alpha: 0.12),
                            child: Center(
                              child: Icon(
                                a.iconData,
                                size: 32,
                                color: a.categoryColor,
                              ),
                            ),
                          ),
                        ),

                        // Subtle Gradient Overlay
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.35),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Bottom-right Clinical Eye Badge
                        Positioned(
                          right: 8,
                          bottom: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
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
                                  a.hospitalBadge,
                                  style: const TextStyle(
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

              // ── 3. Bottom Section: Doctor Author + Read CTA ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 1, color: const Color(0xFFF1F5F9)),
                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Doctor Photo Avatar & Credentials
                      Expanded(
                        child: Row(
                          children: [
                            ClipOval(
                              child: Container(
                                width: 26,
                                height: 26,
                                color: a.categoryColor.withValues(alpha: 0.15),
                                child: Image.asset(
                                  a.doctorAsset,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, error, stackTrace) => Icon(
                                    Icons.medical_services_rounded,
                                    size: 13,
                                    color: a.categoryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.author,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    a.authorRole,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Read Guide CTA Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: a.categoryColor.withValues(alpha: isActive ? 0.18 : 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Read',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: a.categoryColor,
                              ),
                            ),
                            const SizedBox(width: 2.5),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 8,
                              color: a.categoryColor,
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

// ─────────────────────────────────────────────────────────────────────────────
// 5. IN-APP CLINICAL ARTICLE READER MODAL
// ─────────────────────────────────────────────────────────────────────────────

class _BlogReaderModal extends StatelessWidget {
  final BlogArticle article;
  const _BlogReaderModal({required this.article});

  @override
  Widget build(BuildContext context) {
    final a = article;

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
                  // Featured Article Top Banner Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: a.categoryColor.withValues(alpha: 0.10),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            a.imageAsset,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, error, stackTrace) => Center(
                              child: Icon(a.iconData, size: 48, color: a.categoryColor),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: a.categoryColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                a.category,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10.5,
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

                  // Publish Date & Read Time
                  Text(
                    '${a.publishedDate} • ${a.readTime}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Article Headline
                  Text(
                    a.title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Author Byline Card with Doctor Avatar
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Container(
                            width: 40,
                            height: 40,
                            color: a.categoryColor.withValues(alpha: 0.15),
                            child: Image.asset(
                              a.doctorAsset,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, error, stackTrace) => Icon(
                                Icons.medical_services_rounded,
                                size: 20,
                                color: a.categoryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.author,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                '${a.authorRole} • Rainbow Eye Hospital',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Full Content
                  Text(
                    a.fullContent,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF334155),
                      height: 1.65,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Clinical Key Takeaways Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: a.categoryColor.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: a.categoryColor.withValues(alpha: 0.20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_rounded, size: 16, color: a.categoryColor),
                            const SizedBox(width: 6),
                            Text(
                              'Clinical Key Takeaways',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: a.categoryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...a.keyTakeaways.map(
                          (takeaway) => Padding(
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
                                    takeaway,
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

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showBookingDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.calendarCheck, size: 14, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Book Consultation with Specialist',
                            style: TextStyle(
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

// ─────────────────────────────────────────────────────────────────────────────
// 6. SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _BlogsHeader extends StatelessWidget {
  final bool isMobile;
  const _BlogsHeader({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final content = Column(
      children: [
        // Knowledge Base Eyebrow Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: 13,
                color: AppColors.primary,
              ),
              const SizedBox(width: 7),
              Text(
                'RAINBOW CLINICAL KNOWLEDGE BASE',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Main Headline
        Text(
          'Latest Eye Care Insights & Research Guides',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: isMobile ? 22 : 30,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.5,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            'Explore clinical breakthroughs, surgical guides, and daily eye health tips published by Rainbow Eye Hospital specialists.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 13 : 14.5,
              color: const Color(0xFF64748B),
              height: 1.55,
            ),
          ),
        ),
      ],
    );

    if (reduceMotion) return content;

    return content
        .animate()
        .fadeIn(duration: 500.ms, curve: Curves.easeOutCubic)
        .slideY(begin: 0.08, end: 0, duration: 500.ms, curve: Curves.easeOutCubic);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 7. CATEGORY FILTER BAR
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
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: categories.map((cat) {
            final isSelected = cat == selectedCategory;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onCategorySelected(cat);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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
