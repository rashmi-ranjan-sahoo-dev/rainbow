// ─────────────────────────────────────────────────────────────────────────────
// DOCTORS SECTION — Premium, Motion-Rich Medical Specialists & Faculty
// ─────────────────────────────────────────────────────────────────────────────
//
// MOTION & ANIMATION TUNING GUIDE:
//   • Scroll Re-Reveal:
//     - Automatically resets and replays animations every time the user scrolls
//       into this section from anywhere on the page (via VisibilityDetector).
//   • Mobile Alternating Wave Entrances:
//     - Even indices slide smoothly from Left to Right (slideX: -0.32 -> 0)
//     - Odd indices slide smoothly from Right to Left (slideX: +0.32 -> 0)
//     - Hand-tuned elastic curve Cubic(0.16, 1.0, 0.3, 1.0) with scale 0.90 -> 1.0
//   • Mobile Adaptive Pagination:
//     - Displays 2 specialists initially with an interactive "See More" button.
//     - Clicking "See More" reveals the next 2 specialists with staggered entrance.
//   • Hover Lift & Glow:
//     - -6px translateY, dual-layer border highlight, and soft glowing drop shadow.
//   • Live OPD Radar Beacon:
//     - 2000ms continuous radar pulse indicator for live availability.
//
// ACCESSIBILITY:
//   • Automatically respects MediaQuery.disableAnimations (Reduce Motion).
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/section_navigator.dart';
import '../booking/booking_modal.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 1. DATA MODEL & CURATED INDIAN SPECIALISTS MOCK DATA
// ─────────────────────────────────────────────────────────────────────────────

/// High-contrast, streamlined profile model for Rainbow Eye Hospital specialists.
class DoctorProfile {
  final String id;
  final String name;
  final String category;
  final String specialtyBadge;
  final String qualifications;
  final int experienceYears;
  final double rating;
  final int surgeriesCount;
  final String opdTimings;
  final String localAsset;
  final String fallbackNetworkUrl;
  final Color accentColor;
  final String verificationBadge;
  final String avatarInitials;
  final bool isFemale;

  const DoctorProfile({
    required this.id,
    required this.name,
    required this.category,
    required this.specialtyBadge,
    required this.qualifications,
    required this.experienceYears,
    required this.rating,
    required this.surgeriesCount,
    required this.opdTimings,
    required this.localAsset,
    required this.fallbackNetworkUrl,
    required this.accentColor,
    required this.verificationBadge,
    required this.avatarInitials,
    this.isFemale = false,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. MAIN DOCTORS SECTION WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class DoctorsSection extends StatefulWidget {
  const DoctorsSection({super.key});

  @override
  State<DoctorsSection> createState() => _DoctorsSectionState();
}

class _DoctorsSectionState extends State<DoctorsSection> {
  String _selectedCategory = 'All';
  int _visibilityEpoch = 0;
  bool _isInView = true;

  static const List<String> _categories = [
    'All',
    'Cataract & LASIK',
    'Retina & Vitreous',
    'Glaucoma & Cornea',
    'Pediatric & Oculoplasty',
  ];

  /// Realistic, verified Indian male and female ophthalmologists
  static const List<DoctorProfile> _allDoctors = [
    DoctorProfile(
      id: 'dr_rajesh_varma',
      name: 'Dr. Rajesh Varma',
      category: 'Cataract & LASIK',
      specialtyBadge: 'Chief Cataract & Contoura LASIK',
      qualifications: 'MBBS, MS — AIIMS New Delhi, FICO (UK)',
      experienceYears: 22,
      rating: 4.98,
      surgeriesCount: 28000,
      opdTimings: 'Mon–Sat: 10 AM – 1 PM',
      localAsset: 'assets/images/doctor_rajesh_varma.jpg',
      fallbackNetworkUrl:
          'https://images.unsplash.com/photo-1622253692010-333f2da6031d?q=80&w=800&auto=format&fit=crop',
      accentColor: AppColors.primary,
      verificationBadge: 'AIIMS Gold Medalist',
      avatarInitials: 'RV',
      isFemale: false,
    ),
    DoctorProfile(
      id: 'dr_ananya_iyer',
      name: 'Dr. Ananya Iyer',
      category: 'Retina & Vitreous',
      specialtyBadge: 'Sr. Vitreo-Retinal Surgeon',
      qualifications: 'MBBS, DNB — Sankara Nethralaya, FRCS',
      experienceYears: 18,
      rating: 4.95,
      surgeriesCount: 19500,
      opdTimings: 'Mon–Thu: 2 PM – 6 PM',
      localAsset: 'assets/images/doctor_ananya_iyer.jpg',
      fallbackNetworkUrl:
          'https://images.unsplash.com/photo-1594824813511-6677f5979ad2?q=80&w=800&auto=format&fit=crop',
      accentColor: Color(0xFFE11D48),
      verificationBadge: 'Sankara Nethralaya',
      avatarInitials: 'AI',
      isFemale: true,
    ),
    DoctorProfile(
      id: 'dr_suresh_nair',
      name: 'Dr. Suresh Nair',
      category: 'Glaucoma & Cornea',
      specialtyBadge: 'Head — Glaucoma & Cornea',
      qualifications: 'MBBS, MS — LVPEI, Fellowship USA',
      experienceYears: 16,
      rating: 4.92,
      surgeriesCount: 16200,
      opdTimings: 'Tue–Sat: 9 AM – 12:30 PM',
      localAsset: 'assets/images/doctor_suresh_nair.jpg',
      fallbackNetworkUrl:
          'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?q=80&w=800&auto=format&fit=crop',
      accentColor: Color(0xFF0D9488),
      verificationBadge: 'LVPEI Fellow',
      avatarInitials: 'SN',
      isFemale: false,
    ),
    DoctorProfile(
      id: 'dr_priya_sharma',
      name: 'Dr. Priya Sharma',
      category: 'Pediatric & Oculoplasty',
      specialtyBadge: 'Pediatric & Squint Surgeon',
      qualifications: 'MBBS, DOMS — Maulana Azad, Aravind Fellow',
      experienceYears: 14,
      rating: 4.96,
      surgeriesCount: 13800,
      opdTimings: 'Mon–Fri: 11 AM – 3 PM',
      localAsset: 'assets/images/doctor_priya_sharma.jpg',
      fallbackNetworkUrl:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=800&auto=format&fit=crop',
      accentColor: Color(0xFF8B5CF6),
      verificationBadge: 'Aravind Eye Fellow',
      avatarInitials: 'PS',
      isFemale: true,
    ),
    DoctorProfile(
      id: 'dr_arjun_mehta',
      name: 'Dr. Arjun Mehta',
      category: 'Cataract & LASIK',
      specialtyBadge: 'Refractive & SMILE Laser Lead',
      qualifications: 'MBBS, MS — PGIMER Chandigarh',
      experienceYears: 11,
      rating: 4.91,
      surgeriesCount: 11500,
      opdTimings: 'Mon–Sat: 3 PM – 7 PM',
      localAsset: 'assets/images/doctor_arjun_mehta.jpg',
      fallbackNetworkUrl:
          'https://images.unsplash.com/photo-1537368910025-700350fe46c7?q=80&w=800&auto=format&fit=crop',
      accentColor: Color(0xFF0284C7),
      verificationBadge: 'PGIMER Fellow',
      avatarInitials: 'AM',
      isFemale: false,
    ),
    DoctorProfile(
      id: 'dr_kavitha_reddy',
      name: 'Dr. Kavitha Reddy',
      category: 'Pediatric & Oculoplasty',
      specialtyBadge: 'Oculoplastic & Aesthetic Surgeon',
      qualifications: 'MBBS, MS — Osmania, Fellowship UK',
      experienceYears: 15,
      rating: 4.94,
      surgeriesCount: 14100,
      opdTimings: 'Wed–Sat: 10 AM – 2 PM',
      localAsset: 'assets/images/doctor_kavitha_reddy.jpg',
      fallbackNetworkUrl:
          'https://images.unsplash.com/photo-1651008376811-b90baee60c1f?q=80&w=800&auto=format&fit=crop',
      accentColor: Color(0xFFD97706),
      verificationBadge: 'Royal College Fellow',
      avatarInitials: 'KR',
      isFemale: true,
    ),
  ];

  List<DoctorProfile> get _filteredDoctors {
    if (_selectedCategory == 'All') return _allDoctors;
    return _allDoctors
        .where((doc) => doc.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return VisibilityDetector(
      key: const Key('doctors_section_visibility_detector'),
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
        key: SectionNavigator.doctorsKey,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          border: Border(
            top: BorderSide(color: AppColors.divider.withValues(alpha: 0.6)),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 44 : 72,
          horizontal: ResponsiveHelper.horizontalPadding(context),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1320),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── 1. Section Header & Eyebrow Badge ──
                _SectionHeader(
                  key: ValueKey('header_epoch_$_visibilityEpoch'),
                  isMobile: isMobile,
                ),

                const SizedBox(height: 24),

                // ── 2. Specialty Filter Category Bar ──
                _SpecialtyFilterBar(
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (cat) {
                    setState(() => _selectedCategory = cat);
                  },
                ),

                SizedBox(height: isMobile ? 28 : 40),

                // ── 3. Responsive Animated Doctors Grid with Alternating Motion & Mobile Pagination ──
                _ResponsiveDoctorsGrid(
                  key: ValueKey('doctors_grid_${_selectedCategory}_$_visibilityEpoch'),
                  doctors: _filteredDoctors,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final bool isMobile;
  const _SectionHeader({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final content = Column(
      children: [
        // Eyebrow Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
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
                FontAwesomeIcons.userDoctor,
                size: 11,
                color: AppColors.primary,
              ),
              const SizedBox(width: 7),
              Text(
                'WORLD-CLASS MEDICAL FACULTY',
                style: AppTypography.heroEyebrow.copyWith(
                  color: AppColors.primary,
                  fontSize: isMobile ? 10.5 : 11.5,
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
          'Meet Our Senior Ophthalmologists',
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
        const SizedBox(height: 8),

      ],
    );

    if (reduceMotion) return content;

    return content
        .animate()
        .fadeIn(duration: 500.ms, curve: Curves.easeOutCubic)
        .slideY(
          begin: 0.08,
          end: 0,
          duration: 550.ms,
          curve: const Cubic(0.16, 1.0, 0.3, 1.0),
        );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. SPECIALTY FILTER PILLS BAR
// ─────────────────────────────────────────────────────────────────────────────

class _SpecialtyFilterBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const _SpecialtyFilterBar({
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
            return _FilterPill(
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

class _FilterPill extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_FilterPill> createState() => _FilterPillState();
}

class _FilterPillState extends State<_FilterPill> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.primary
                : (_isHovered ? AppColors.surface : Colors.transparent),
            borderRadius: BorderRadius.circular(24),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.28),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    const BoxShadow(
                      color: Colors.transparent,
                      blurRadius: 0,
                      offset: Offset.zero,
                    ),
                  ],
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12.5,
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
              color: widget.isSelected ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. RESPONSIVE DOCTORS GRID (Alternating Direction Animation + Mobile +2 Pagination)
// ─────────────────────────────────────────────────────────────────────────────

class _ResponsiveDoctorsGrid extends StatefulWidget {
  final List<DoctorProfile> doctors;

  const _ResponsiveDoctorsGrid({super.key, required this.doctors});

  @override
  State<_ResponsiveDoctorsGrid> createState() => _ResponsiveDoctorsGridState();
}

class _ResponsiveDoctorsGridState extends State<_ResponsiveDoctorsGrid> {
  /// Mobile pagination count: Starts at 2 doctors, loads +2 per click
  int _mobileVisibleCount = 2;

  void _handleSeeMore(int totalDoctors) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_mobileVisibleCount < totalDoctors) {
        _mobileVisibleCount = math.min(_mobileVisibleCount + 2, totalDoctors);
      } else {
        _mobileVisibleCount = 2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 650;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final totalDoctors = widget.doctors.length;

    // Mobile: Show only _mobileVisibleCount doctors (initially 2, then 4, 6)
    final displayDoctors = isMobile
        ? widget.doctors.take(_mobileVisibleCount).toList()
        : widget.doctors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final int crossAxisCount = screenWidth >= 1080
            ? 3
            : (screenWidth >= 650 ? 2 : 1);

        final double spacing = screenWidth >= 650 ? 20.0 : 16.0;
        final double cardWidth = crossAxisCount == 1
            ? maxWidth
            : (maxWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;

        return Column(
          children: [
            Wrap(
              spacing: spacing,
              runSpacing: spacing + 4,
              alignment: WrapAlignment.center,
              children: List.generate(displayDoctors.length, (index) {
                final doctor = displayDoctors[index];
                final card = SizedBox(
                  width: cardWidth,
                  child: _DoctorCard(doctor: doctor),
                );

                if (reduceMotion) return card;

                // ── Alternating Direction Entrance Animation ──
                // Even index (0, 2, 4...): Slides in from Left-to-Right
                // Odd index (1, 3, 5...): Slides in from Right-to-Left
                final double startSlideX;
                final double startSlideY;

                if (crossAxisCount == 3) {
                  if (index % 3 == 0) {
                    startSlideX = -0.25; // Left column: Left to Right
                    startSlideY = 0.04;
                  } else if (index % 3 == 2) {
                    startSlideX = 0.25; // Right column: Right to Left
                    startSlideY = 0.04;
                  } else {
                    startSlideX = 0.0; // Center column: Glide Up
                    startSlideY = 0.18;
                  }
                } else {
                  // Mobile (1-col) & Tablet (2-col): Bold Left <-> Right alternation
                  if (index.isEven) {
                    startSlideX = isMobile ? -0.32 : -0.22; // Even: Left to Right
                    startSlideY = 0.04;
                  } else {
                    startSlideX = isMobile ? 0.32 : 0.22; // Odd: Right to Left
                    startSlideY = 0.04;
                  }
                }

                return card
                    .animate(
                      key: ValueKey('doc_card_anim_${doctor.id}_$index'),
                      delay: (index * 85).ms,
                    )
                    .fadeIn(
                      duration: 550.ms,
                      curve: Curves.easeOutCubic,
                    )
                    .slide(
                      begin: Offset(startSlideX, startSlideY),
                      end: Offset.zero,
                      duration: 620.ms,
                      curve: const Cubic(0.16, 1.0, 0.3, 1.0),
                    )
                    .scaleXY(
                      begin: isMobile ? 0.90 : 0.95,
                      end: 1.0,
                      duration: 620.ms,
                      curve: const Cubic(0.16, 1.0, 0.3, 1.0),
                    );
              }),
            ),

            // ── Mobile "See More" Button (+2 Specialists at a time) ──
            if (isMobile && totalDoctors > 2) ...[
              const SizedBox(height: 20),
              _SeeMorePaginationButton(
                isExpanded: _mobileVisibleCount >= totalDoctors,
                remainingCount: math.max(0, totalDoctors - _mobileVisibleCount),
                onTap: () => _handleSeeMore(totalDoctors),
              ),
            ],
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. MOBILE "SEE MORE" PAGINATION BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class _SeeMorePaginationButton extends StatefulWidget {
  final bool isExpanded;
  final int remainingCount;
  final VoidCallback onTap;

  const _SeeMorePaginationButton({
    required this.isExpanded,
    required this.remainingCount,
    required this.onTap,
  });

  @override
  State<_SeeMorePaginationButton> createState() =>
      _SeeMorePaginationButtonState();
}

class _SeeMorePaginationButtonState extends State<_SeeMorePaginationButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final nextBatchCount = math.min(2, widget.remainingCount);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        scale: _isPressed ? 0.95 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isExpanded
                ? const Color(0xFFF1F5F9)
                : AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: widget.isExpanded
                  ? AppColors.divider
                  : AppColors.primaryLight.withValues(alpha: 0.50),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isExpanded
                    ? Colors.transparent
                    : AppColors.primary.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.userDoctor,
                size: 13,
                color: widget.isExpanded
                    ? AppColors.textSecondary
                    : AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                widget.isExpanded
                    ? 'Show Fewer Specialists'
                    : 'See More (+$nextBatchCount Specialists)',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: widget.isExpanded
                      ? AppColors.textPrimary
                      : AppColors.primaryDark,
                ),
              ),
              const SizedBox(width: 6),
              AnimatedRotation(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                turns: widget.isExpanded ? 0.5 : 0.0,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: widget.isExpanded
                      ? AppColors.textSecondary
                      : AppColors.primary,
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
// 7. STREAMLINED DOCTOR PROFILE CARD
// ─────────────────────────────────────────────────────────────────────────────

class _DoctorCard extends StatefulWidget {
  final DoctorProfile doctor;

  const _DoctorCard({required this.doctor});

  @override
  State<_DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<_DoctorCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  late final AnimationController _beaconPulseController;

  @override
  void initState() {
    super.initState();
    _beaconPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _beaconPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.doctor;
    final isActive = _isHovered || _isPressed;
    final yOffset = _isPressed ? 0.0 : (_isHovered ? -6.0 : 0.0);
    final scaleValue = _isPressed ? 0.98 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          HapticFeedback.lightImpact();
          showBookingDialog(context);
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: const Cubic(0.16, 1.0, 0.3, 1.0),
          transform: Matrix4.diagonal3Values(scaleValue, scaleValue, 1.0)
            ..setTranslationRaw(0.0, yOffset, 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive
                  ? doc.accentColor.withValues(alpha: 0.55)
                  : const Color(0xFFE2E8F0),
              width: isActive ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? doc.accentColor.withValues(alpha: 0.16)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: isActive ? 24 : 10,
                offset: Offset(0, isActive ? 8 : 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── A. Header Banner with Avatar, Verified Tag & Experience ──
                _CardHeaderBanner(
                  doctor: doc,
                  isHovered: _isHovered,
                ),

                // ── B. Content Body (Streamlined Credentials & OPD) ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Doctor Name + Verified Check Icon
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              doc.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: Color(0xFF0284C7),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Specialty Pill Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3.5,
                        ),
                        decoration: BoxDecoration(
                          color: doc.accentColor.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.stethoscope,
                              size: 10,
                              color: doc.accentColor,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                doc.specialtyBadge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: doc.accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Qualifications Subtitle
                      Text(
                        doc.qualifications,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Divider
                      Container(
                        height: 1,
                        color: const Color(0xFFF1F5F9),
                      ),
                      const SizedBox(height: 12),

                      // OPD Availability Pill with Live Pulsing Radar Beacon
                      _OpdTimingPill(
                        timings: doc.opdTimings,
                        pulseController: _beaconPulseController,
                      ),
                      const SizedBox(height: 14),

                      // Primary Action CTA Button
                      _ConsultationButton(
                        accentColor: doc.accentColor,
                        isActive: isActive,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 8. CARD HEADER BANNER WITH CIRCULAR AVATAR & FLOATING TAGS
// ─────────────────────────────────────────────────────────────────────────────

class _CardHeaderBanner extends StatelessWidget {
  final DoctorProfile doctor;
  final bool isHovered;

  const _CardHeaderBanner({
    required this.doctor,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            doctor.accentColor.withValues(alpha: 0.12),
            doctor.accentColor.withValues(alpha: 0.04),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: doctor.accentColor.withValues(alpha: 0.10),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Top Floating Badges (Experience + Institution)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Experience Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.medal,
                      size: 9,
                      color: Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${doctor.experienceYears}+ Yrs Exp',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),

              // Rating / Surgeries Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: doctor.accentColor.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: doctor.accentColor.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 11,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 2.5),
                    Text(
                      '${doctor.rating} (${(doctor.surgeriesCount / 1000).toStringAsFixed(0)}k+)',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // High-Resolution Circular Doctor Avatar
          _DoctorAvatar(
            doctor: doctor,
            isHovered: isHovered,
          ),
          const SizedBox(height: 6),

          // Institution Verification Badge Under Avatar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: doctor.accentColor.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_outlined,
                  size: 10.5,
                  color: doctor.accentColor,
                ),
                const SizedBox(width: 4),
                Text(
                  doctor.verificationBadge,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: doctor.accentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 9. ROBUST DOCTOR AVATAR (Asset -> Network -> Initials Shimmer Fallback)
// ─────────────────────────────────────────────────────────────────────────────

class _DoctorAvatar extends StatelessWidget {
  final DoctorProfile doctor;
  final bool isHovered;

  const _DoctorAvatar({
    required this.doctor,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    const double avatarSize = 92.0;

    return AnimatedScale(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      scale: isHovered ? 1.05 : 1.0,
      child: Container(
        width: avatarSize,
        height: avatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              doctor.accentColor,
              doctor.accentColor.withValues(alpha: 0.6),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: doctor.accentColor.withValues(alpha: isHovered ? 0.35 : 0.18),
              blurRadius: isHovered ? 18 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(2.5), // Outer crisp bevel
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(2.0), // Inner white boundary
          child: ClipOval(
            child: Image.asset(
              doctor.localAsset,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) {
                // Primary Network Fallback
                return Image.network(
                  doctor.fallbackNetworkUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _AvatarShimmerPlaceholder(
                      accentColor: doctor.accentColor,
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    // Graceful Initials Avatar Fallback
                    return _InitialsFallback(doctor: doctor);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer loader when avatar is loading
class _AvatarShimmerPlaceholder extends StatelessWidget {
  final Color accentColor;
  const _AvatarShimmerPlaceholder({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: accentColor.withValues(alpha: 0.12),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
          ),
        ),
      ),
    );
  }
}

/// Graceful styled initials fallback
class _InitialsFallback extends StatelessWidget {
  final DoctorProfile doctor;
  const _InitialsFallback({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            doctor.accentColor.withValues(alpha: 0.25),
            doctor.accentColor.withValues(alpha: 0.10),
          ],
        ),
      ),
      child: Center(
        child: Text(
          doctor.avatarInitials,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: doctor.accentColor,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 10. OPD TIMING PILL WITH LIVE PULSE
// ─────────────────────────────────────────────────────────────────────────────

class _OpdTimingPill extends StatelessWidget {
  final String timings;
  final AnimationController pulseController;

  const _OpdTimingPill({
    required this.timings,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          // Live Pulse Beacon Dot
          AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              final val = pulseController.value;
              final ringScale = 1.0 + (val * 0.7);
              final ringOpacity = (1.0 - val).clamp(0.0, 1.0);

              return Stack(
                alignment: Alignment.center,
                children: [
                  Transform.scale(
                    scale: ringScale,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF10B981)
                            .withValues(alpha: ringOpacity * 0.35),
                      ),
                    ),
                  ),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Text(
              timings,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF047857),
              ),
            ),
          ),
          const Icon(
            Icons.access_time_rounded,
            size: 12,
            color: Color(0xFF10B981),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 11. PRIMARY CONSULTATION BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class _ConsultationButton extends StatelessWidget {
  final Color accentColor;
  final bool isActive;

  const _ConsultationButton({
    required this.accentColor,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isActive
              ? [
                  accentColor,
                  accentColor.withValues(alpha: 0.85),
                ]
              : [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.32),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : [
                const BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 0,
                  offset: Offset.zero,
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Flexible(
            child: Text(
              'Book OPD Consult',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(width: 6),
          AnimatedSlide(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            offset: Offset(isActive ? 0.2 : 0.0, 0.0),
            child: const Icon(
              Icons.arrow_forward_rounded,
              size: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
