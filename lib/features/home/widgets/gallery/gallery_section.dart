import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/section_navigator.dart';
import '../../../../shared/widgets/scroll_reveal.dart';
import 'gallery_data.dart';
import 'gallery_modal.dart';

/// Section 9 — Hospital Infrastructure, Clinical OT Suites & Optical Plaza Gallery.
///
/// Features:
/// - One photo for each category (6 photos total by default) representing all infrastructure & community outreach areas:
///   1. Surgical & OT
///   2. Diagnostics
///   3. Patient Recovery
///   4. Campus & Lounge
///   5. Optical & Pharmacy
///   6. Free Eye Camps
/// - Responsive card layouts:
///   * Mobile (< 600px): 1 card per row, scrolling down displays all 5 follow-up category cards
///   * Tablet (600px - 1023px): 2 cards per row
///   * Laptop / PC (>= 1024px): 3 cards per row
/// - "See More" button launches the full interactive Virtual Tour (all 16 photos).
class GallerySection extends StatefulWidget {
  const GallerySection({super.key});

  @override
  State<GallerySection> createState() => _GallerySectionState();
}

class _GallerySectionState extends State<GallerySection> {
  GalleryCategory _selectedCategory = GalleryCategory.all;

  /// Returns 1 representative photo per category when "All" is active (5 cards total),
  /// or all photos belonging to the selected category.
  List<HospitalPhotoItem> get _displayedItems {
    if (_selectedCategory == GalleryCategory.all) {
      final List<HospitalPhotoItem> categoryShowcase = [];
      for (final cat in GalleryCategory.values) {
        if (cat == GalleryCategory.all) continue;
        final match = HospitalGalleryData.items.where((item) => item.category == cat).toList();
        if (match.isNotEmpty) {
          categoryShowcase.add(match.first);
        }
      }
      return categoryShowcase;
    }
    return HospitalGalleryData.items
        .where((item) => item.category == _selectedCategory)
        .toList();
  }

  void _onCategorySelected(GalleryCategory category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _openVirtualTour({int initialIndex = 0}) {
    showHospitalGalleryModal(
      context,
      initialIndex: initialIndex,
      items: HospitalGalleryData.items,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    // Responsive columns:
    // - Phone: 1 card per row (user scrolls down to see each of the 5 categories)
    // - Tablet: 2 cards per row
    // - Desktop: 3 cards per row
    final int crossAxisCount;
    if (isMobile) {
      crossAxisCount = 1;
    } else if (isTablet) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }

    final itemsToDisplay = _displayedItems;

    return Container(
      key: SectionNavigator.galleryKey,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border(
          top: BorderSide(color: AppColors.divider.withValues(alpha: 0.6)),
          bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.6)),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1360),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.horizontalPadding(context),
              vertical: isMobile ? 48 : 64,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── 1. Section Eyebrow Badge (Zero Shadows) ──
                ScrollReveal(
                  duration: const Duration(milliseconds: 700),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.hospital,
                          size: 12,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'OUR INFRASTRUCTURE & FACILITIES',
                          style: AppTypography.sectionEyebrow(
                            color: AppColors.primary,
                            fontSize: isMobile ? 11 : 12,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ── 2. Section Headline ──
                ScrollReveal(
                  duration: const Duration(milliseconds: 700),
                  delay: const Duration(milliseconds: 80),
                  child: Text(
                    'Take A Tour Of Rainbow Eye Hospital',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 24 : 34,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ── 3. Section Subtitle ──
                ScrollReveal(
                  duration: const Duration(milliseconds: 700),
                  delay: const Duration(milliseconds: 140),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Text(
                      'Explore our world-class surgical suites, Carl Zeiss laser diagnostics, recovery lounges, and optical center in Visakhapatnam.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 13 : 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.55,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── 4. Category Filter Tabs ──
                ScrollReveal(
                  duration: const Duration(milliseconds: 700),
                  delay: const Duration(milliseconds: 180),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: GalleryCategory.values.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(
                              category.title,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: isMobile ? 12 : 13,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? Colors.white : const Color(0xFF475569),
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.primary,
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                _onCategorySelected(category);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── 5. Responsive Photo Grid (1 per row on Phone, 2 on Tablet, 3 on Desktop) ──
                LayoutBuilder(
                  builder: (context, constraints) {
                    const double spacing = 20.0;
                    final double totalSpacing = (crossAxisCount - 1) * spacing;
                    final double cardWidth = (constraints.maxWidth - totalSpacing) / crossAxisCount;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      alignment: WrapAlignment.center,
                      children: itemsToDisplay.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        final fullIndex = HospitalGalleryData.items.indexWhere((it) => it.id == item.id);

                        return SizedBox(
                          width: cardWidth,
                          child: ScrollReveal(
                            duration: const Duration(milliseconds: 500),
                            delay: Duration(milliseconds: (index % crossAxisCount) * 80),
                            child: _SimplifiedGalleryCard(
                              item: item,
                              onTap: () => _openVirtualTour(
                                initialIndex: fullIndex >= 0 ? fullIndex : index,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 36),

                // ── 6. "See More" Button ──
                ScrollReveal(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () => _openVirtualTour(initialIndex: 0),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 36 : 48,
                          vertical: isMobile ? 14 : 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                        shadowColor: AppColors.primary.withValues(alpha: 0.35),
                      ),
                      child: Text(
                        'See More',
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 14 : 15.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ── 7. Quality & Accreditation Trust Badges ──
                ScrollReveal(
                  duration: const Duration(milliseconds: 700),
                  delay: const Duration(milliseconds: 250),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 28,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Wrap(
                      alignment: WrapAlignment.spaceAround,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 24,
                      runSpacing: 16,
                      children: [
                        _FeatureBadge(
                          icon: FontAwesomeIcons.shieldHalved,
                          title: 'NABH-Standard OTs',
                          subtitle: '100% Laminar Sterile Airflow',
                        ),
                        _FeatureBadge(
                          icon: FontAwesomeIcons.microscope,
                          title: 'German Carl Zeiss Optics',
                          subtitle: 'Sub-micron surgical precision',
                        ),
                        _FeatureBadge(
                          icon: FontAwesomeIcons.heartPulse,
                          title: 'Day-Care Recovery',
                          subtitle: 'Same-day walk-in discharge',
                        ),
                        _FeatureBadge(
                          icon: FontAwesomeIcons.prescriptionBottleMedical,
                          title: '24/7 Optical & Pharmacy',
                          subtitle: 'Genuine medicines & branded frames',
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
    );
  }
}

/// Simplified Gallery Card containing ONLY:
/// 1. The picture photo at the top
/// 2. The picture name/title centered below
class _SimplifiedGalleryCard extends StatefulWidget {
  final HospitalPhotoItem item;
  final VoidCallback onTap;

  const _SimplifiedGalleryCard({
    required this.item,
    required this.onTap,
  });

  @override
  State<_SimplifiedGalleryCard> createState() => _SimplifiedGalleryCardState();
}

class _SimplifiedGalleryCardState extends State<_SimplifiedGalleryCard> {
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
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary
                  : const Color(0xFFE2E8F0),
              width: _isHovered ? 1.6 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.primary.withValues(alpha: 0.16)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── 1. Photo ──
                AspectRatio(
                  aspectRatio: 1.35,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        color: const Color(0xFFF1F5F9),
                        child: AnimatedScale(
                          scale: _isHovered ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeOutCubic,
                          child: Hero(
                            tag: 'gallery_img_${widget.item.id}',
                            child: Image.asset(
                              widget.item.imageAsset,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: const Color(0xFFE2E8F0),
                                child: const Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: Color(0xFF94A3B8),
                                    size: 36,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Category Tag Badge (e.g., Surgical & OT, Diagnostics, Patient Recovery...)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.70),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: widget.item.category.color.withValues(alpha: 0.6),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                widget.item.category.icon,
                                size: 10,
                                color: widget.item.category.color,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.item.category.title,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Subtle hover zoom icon
                      Positioned(
                        top: 10,
                        right: 10,
                        child: AnimatedOpacity(
                          opacity: _isHovered ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.fullscreen_rounded,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── 2. Picture Name / Title Only ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Text(
                    widget.item.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF0F172A),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
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

class _FeatureBadge extends StatelessWidget {
  final FaIconData icon;
  final String title;
  final String subtitle;

  const _FeatureBadge({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.20),
            ),
          ),
          child: Center(
            child: FaIcon(
              icon,
              size: 15,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
