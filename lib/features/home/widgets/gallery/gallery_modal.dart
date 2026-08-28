import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'gallery_data.dart';

/// Launches the interactive fullscreen Lightbox Gallery Modal with smooth entrance.
void showHospitalGalleryModal(
  BuildContext context, {
  int initialIndex = 0,
  List<HospitalPhotoItem>? items,
}) {
  final photoItems = items ?? HospitalGalleryData.items;
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss Gallery Modal',
    barrierColor: Colors.black.withValues(alpha: 0.88),
    transitionDuration: const Duration(milliseconds: 380),
    pageBuilder: (context, anim1, anim2) {
      return _HospitalGalleryModal(
        initialIndex: initialIndex,
        items: photoItems,
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      final curve = CurvedAnimation(
        parent: anim1,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curve,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(curve),
          child: child,
        ),
      );
    },
  );
}

class _HospitalGalleryModal extends StatefulWidget {
  final int initialIndex;
  final List<HospitalPhotoItem> items;

  const _HospitalGalleryModal({
    required this.initialIndex,
    required this.items,
  });

  @override
  State<_HospitalGalleryModal> createState() => _HospitalGalleryModalState();
}

class _HospitalGalleryModalState extends State<_HospitalGalleryModal> {
  late int _currentIndex;
  late final PageController _pageController;
  late final ScrollController _filmstripController;
  final FocusNode _focusNode = FocusNode();
  bool _showDetails = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.items.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
    _filmstripController = ScrollController();

    // Auto-scroll filmstrip to active item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToThumbnail(_currentIndex);
      _focusNode.requestFocus();
    });
  }

  void _scrollToThumbnail(int index) {
    if (!_filmstripController.hasClients) return;
    const itemWidth = 84.0;
    final targetOffset = (index * itemWidth) - 120.0;
    _filmstripController.animateTo(
      targetOffset.clamp(0.0, _filmstripController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _scrollToThumbnail(index);
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _goToNext() {
    if (_currentIndex < widget.items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _filmstripController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final currentItem = widget.items[_currentIndex];

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _goToPrevious();
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _goToNext();
          } else if (event.logicalKey == LogicalKeyboardKey.escape) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // ── 1. Fullscreen Zoomable Image Carousel ──
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.items.length,
                onPageChanged: _onPageChanged,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 12 : 72,
                        vertical: isMobile ? 80 : 110,
                      ),
                      child: InteractiveViewer(
                        minScale: 1.0,
                        maxScale: 3.5,
                        clipBehavior: Clip.none,
                        child: Hero(
                          tag: 'gallery_img_${item.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(isMobile ? 12 : 18),
                            child: Image.asset(
                              item.imageAsset,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 300,
                                width: 400,
                                color: Colors.grey[900],
                                child: const Center(
                                  child: Icon(Icons.broken_image_rounded,
                                      color: Colors.white54, size: 48),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── 2. Top Header Bar (Counter, Category Pill, Close) ──
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 14 : 28,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      // Rainbow Eye Hospital Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
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
                              isMobile ? 'Rainbow Gallery' : 'Rainbow Eye Hospital Campus',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Category Pill
                      if (!isMobile)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: currentItem.category.color.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: currentItem.category.color.withValues(alpha: 0.6),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                currentItem.category.icon,
                                size: 11,
                                color: currentItem.category.color,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                currentItem.category.title,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const Spacer(),

                      // Index Counter (e.g., 03 / 16)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${(_currentIndex + 1).toString().padLeft(2, '0')} / ${widget.items.length.toString().padLeft(2, '0')}',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Toggle details visibility
                      IconButton(
                        tooltip: _showDetails ? 'Hide Info' : 'Show Info',
                        icon: Icon(
                          _showDetails
                              ? Icons.info_rounded
                              : Icons.info_outline_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() => _showDetails = !_showDetails);
                        },
                      ),

                      const SizedBox(width: 4),

                      // Close Button
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.15),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── 3. Desktop Left Navigation Arrow ──
            if (!isMobile && _currentIndex > 0)
              Positioned(
                left: 18,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _NavArrowButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: _goToPrevious,
                    tooltip: 'Previous Photo (Left Arrow)',
                  ),
                ),
              ),

            // ── 4. Desktop Right Navigation Arrow ──
            if (!isMobile && _currentIndex < widget.items.length - 1)
              Positioned(
                right: 18,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _NavArrowButton(
                    icon: Icons.chevron_right_rounded,
                    onTap: _goToNext,
                    tooltip: 'Next Photo (Right Arrow)',
                  ),
                ),
              ),

            // ── 5. Bottom Info Card & Thumbnail Filmstrip ──
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dynamic Caption Card
                    if (_showDetails)
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: isMobile ? 14 : 32,
                            vertical: 8,
                          ),
                          constraints: const BoxConstraints(maxWidth: 820),
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 14 : 20,
                            vertical: isMobile ? 10 : 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.88),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: currentItem.category.color
                                          .withValues(alpha: 0.25),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      currentItem.tag.toUpperCase(),
                                      style: TextStyle(
                                        color: currentItem.category.color,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      currentItem.title,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: isMobile ? 14 : 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currentItem.description,
                                style: GoogleFonts.inter(
                                  color: Colors.white.withValues(alpha: 0.82),
                                  fontSize: isMobile ? 11.5 : 12.5,
                                  height: 1.35,
                                ),
                                maxLines: isMobile ? 2 : 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Thumbnail Filmstrip Strip
                    Container(
                      height: isMobile ? 56 : 68,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListView.separated(
                        controller: _filmstripController,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 14 : 32,
                        ),
                        itemCount: widget.items.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          final isSelected = index == _currentIndex;

                          return GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOutCubic,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              width: isMobile ? 64 : 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.white.withValues(alpha: 0.2),
                                  width: isSelected ? 2.5 : 1.0,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.45),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      item.imageAsset,
                                      fit: BoxFit.cover,
                                    ),
                                    if (!isSelected)
                                      Container(
                                        color: Colors.black.withValues(alpha: 0.45),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavArrowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const _NavArrowButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  State<_NavArrowButton> createState() => _NavArrowButtonState();
}

class _NavArrowButtonState extends State<_NavArrowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isHovered
                  ? AppColors.primary
                  : Colors.black.withValues(alpha: 0.55),
              border: Border.all(
                color: _isHovered
                    ? Colors.white.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 14,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
