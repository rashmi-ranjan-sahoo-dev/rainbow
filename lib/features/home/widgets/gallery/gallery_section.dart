import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/section_navigator.dart';
import '../../../../shared/widgets/scroll_reveal.dart';
import 'gallery_data.dart';
import 'gallery_modal.dart';

/// Section — Hospital Infrastructure, Clinical OT Suites & Optical Plaza Gallery.
///
/// Highlights:
/// - Progressive 1-Row display by default across all devices.
/// - "See More" button reveals additional rows one by one.
/// - Bright, crisp image cards with 100% unobstructed image visibility.
/// - Fullscreen zoomable lightbox modal on tap.
class GallerySection extends StatefulWidget {
  const GallerySection({super.key});

  @override
  State<GallerySection> createState() => _GallerySectionState();
}

class _GallerySectionState extends State<GallerySection> {
  GalleryCategory _selectedCategory = GalleryCategory.all;
  int _visibleRows = 1;

  List<HospitalPhotoItem> get _filteredItems {
    if (_selectedCategory == GalleryCategory.all) {
      return HospitalGalleryData.items;
    }
    return HospitalGalleryData.items
        .where((item) => item.category == _selectedCategory)
        .toList();
  }

  int _getCategoryCount(GalleryCategory category) {
    if (category == GalleryCategory.all) {
      return HospitalGalleryData.items.length;
    }
    return HospitalGalleryData.items
        .where((item) => item.category == category)
        .length;
  }

  void _onCategorySelected(GalleryCategory category) {
    setState(() {
      _selectedCategory = category;
      _visibleRows = 1; // Reset to 1 row on category switch
    });
  }

  void _showMoreRows(int totalRows) {
    setState(() {
      if (_visibleRows < totalRows) {
        _visibleRows++;
      }
    });
  }

  void _showLessRows() {
    setState(() {
      _visibleRows = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = ResponsiveHelper.isMobile(context);

    // Responsive columns
    final int crossAxisCount;
    if (screenWidth < 600) {
      crossAxisCount = 1; // Mobile: 1 card per row
    } else if (screenWidth < 960) {
      crossAxisCount = 2; // Tablet: 2 cards per row
    } else if (screenWidth < 1280) {
      crossAxisCount = 3; // Small Desktop: 3 cards per row
    } else {
      crossAxisCount = 4; // Desktop: 4 cards per row
    }

    final filtered = _filteredItems;
    final totalRows = (filtered.length / crossAxisCount).ceil();
    final int visibleCount = (_visibleRows * crossAxisCount).clamp(0, filtered.length);
    final visibleItems = filtered.take(visibleCount).toList();
    final hasMoreRows = _visibleRows < totalRows;

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
      child: Stack(
        children: [
          // Background ambient gradient orbs
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1360),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.horizontalPadding(context),
                  vertical: isMobile ? 48 : 72,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── 1. Section Eyebrow Badge ──
                    ScrollReveal(
                      duration: const Duration(milliseconds: 700),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
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
                              size: 13,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'OUR INFRASTRUCTURE & FACILITIES',
                              style: GoogleFonts.poppins(
                                color: AppColors.primary,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
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
                          fontSize: isMobile ? 26 : 36,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── 3. Section Subtitle ──
                    ScrollReveal(
                      duration: const Duration(milliseconds: 700),
                      delay: const Duration(milliseconds: 140),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Text(
                          'Explore our German Carl Zeiss modular surgical OT, sub-micron OCT retina diagnostics, day-care recovery wards, and modern optical plaza in Visakhapatnam.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                            fontSize: isMobile ? 14 : 16,
                            height: 1.55,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── 4. Category Filter Tabs & Tour Action Button ──
                    ScrollReveal(
                      duration: const Duration(milliseconds: 700),
                      delay: const Duration(milliseconds: 180),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 10,
                        children: [
                          ...GalleryCategory.values.map((category) {
                            final isSelected = _selectedCategory == category;
                            final count = _getCategoryCount(category);

                            return InkWell(
                              onTap: () => _onCategorySelected(category),
                              borderRadius: BorderRadius.circular(30),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 12 : 16,
                                  vertical: isMobile ? 8 : 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.divider,
                                    width: 1.2,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withValues(alpha: 0.25),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.03),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(
                                      category.icon,
                                      size: 13,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      category.title,
                                      style: GoogleFonts.inter(
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                        fontSize: isMobile ? 12.5 : 13.5,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white.withValues(alpha: 0.25)
                                            : AppColors.surface,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        count.toString(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.textMuted,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                          // Launch Full Tour Button
                          const SizedBox(width: 6),
                          ElevatedButton.icon(
                            onPressed: () {
                              showHospitalGalleryModal(
                                context,
                                initialIndex: 0,
                                items: HospitalGalleryData.items,
                              );
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.expand,
                              size: 12,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Virtual Tour (${HospitalGalleryData.items.length})',
                              style: GoogleFonts.poppins(
                                fontSize: isMobile ? 12.5 : 13.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 14 : 18,
                                vertical: isMobile ? 12 : 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // ── 5. Responsive Photo Grid (Showing 1 Row at a Time) ──
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: GridView.builder(
                        key: ValueKey('${_selectedCategory}_$_visibleRows'),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: visibleItems.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: isMobile ? 0.95 : 0.88,
                        ),
                        itemBuilder: (context, index) {
                          final item = visibleItems[index];
                          final originalIndex = HospitalGalleryData.items
                              .indexWhere((it) => it.id == item.id);

                          return ScrollReveal(
                            duration: const Duration(milliseconds: 500),
                            delay: Duration(milliseconds: (index % crossAxisCount) * 70),
                            child: _GalleryCard(
                              item: item,
                              onTap: () {
                                showHospitalGalleryModal(
                                  context,
                                  initialIndex: originalIndex >= 0 ? originalIndex : 0,
                                  items: HospitalGalleryData.items,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── 6. "See More" / "Show Less" Row Expansion Controls ──
                    if (totalRows > 1)
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (hasMoreRows)
                              ElevatedButton.icon(
                                onPressed: () => _showMoreRows(totalRows),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'See More Photos (Row ${_visibleRows + 1} of $totalRows)',
                                  style: GoogleFonts.poppins(
                                    fontSize: isMobile ? 13 : 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 20 : 28,
                                    vertical: isMobile ? 13 : 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 3,
                                  shadowColor: AppColors.primary.withValues(alpha: 0.35),
                                ),
                              ),
                            if (!hasMoreRows && totalRows > 1) ...[
                              OutlinedButton.icon(
                                onPressed: _showLessRows,
                                icon: const Icon(
                                  Icons.keyboard_arrow_up_rounded,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                                label: Text(
                                  'Show Less (1 Row)',
                                  style: GoogleFonts.poppins(
                                    fontSize: isMobile ? 13 : 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 18 : 24,
                                    vertical: isMobile ? 12 : 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () {
                                  showHospitalGalleryModal(
                                    context,
                                    initialIndex: 0,
                                    items: HospitalGalleryData.items,
                                  );
                                },
                                icon: const Icon(
                                  Icons.fullscreen_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Full Screen Tour',
                                  style: GoogleFonts.poppins(
                                    fontSize: isMobile ? 13 : 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 18 : 24,
                                    vertical: isMobile ? 12 : 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                    const SizedBox(height: 44),

                    // ── 7. Bottom Quality & Hygiene Trust Banner ──
                    ScrollReveal(
                      duration: const Duration(milliseconds: 700),
                      delay: const Duration(milliseconds: 200),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 28,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
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
                              title: '24/7 Pharmacy & Optical',
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
        ],
      ),
    );
  }
}

/// A clean, bright card that renders the hospital photo 100% unobstructed,
/// with the details placed on a crisp lower container.
class _GalleryCard extends StatefulWidget {
  final HospitalPhotoItem item;
  final VoidCallback onTap;

  const _GalleryCard({
    required this.item,
    required this.onTap,
  });

  @override
  State<_GalleryCard> createState() => _GalleryCardState();
}

class _GalleryCardState extends State<_GalleryCard> {
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
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.only(
            top: _isHovered ? 0 : 5,
            bottom: _isHovered ? 5 : 0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary
                  : AppColors.divider.withValues(alpha: 0.8),
              width: _isHovered ? 1.8 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.primary.withValues(alpha: 0.18)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: _isHovered ? 22 : 10,
                offset: Offset(0, _isHovered ? 8 : 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Crisp, 100% Unobstructed Photo Header ──
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        color: const Color(0xFFF1F5F9),
                        child: AnimatedScale(
                          scale: _isHovered ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                          child: Hero(
                            tag: 'gallery_img_${widget.item.id}',
                            child: Image.asset(
                              widget.item.imageAsset,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(Icons.broken_image_rounded,
                                      color: Colors.grey, size: 36),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Top Category Tag Pill
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.70),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 0.8,
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
                              const SizedBox(width: 5),
                              Text(
                                widget.item.tag,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Zoom indicator on hover
                      Positioned(
                        top: 10,
                        right: 10,
                        child: AnimatedOpacity(
                          opacity: _isHovered ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            padding: const EdgeInsets.all(7),
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
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── 2. Clean Dedicated Details Footer (No darkening on photo) ──
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Color(0xFFF1F5F9), width: 1.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.item.title,
                        style: GoogleFonts.poppins(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.item.subtitle,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Click to view full photo',
                            style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 13,
                            color: AppColors.primary,
                          ),
                        ],
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
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: FaIcon(
            icon,
            size: 15,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 11.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
