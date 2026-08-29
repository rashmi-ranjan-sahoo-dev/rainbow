import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/widgets/rainbow_logo.dart';
import '../models/symptom_models.dart';

/// Opens the interactive 5-Card Vision Deck Symptom Checker popup modal.
void showVisionDeckModal(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close Symptom Checker',
    barrierColor: Colors.black.withValues(alpha: 0.8),
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, anim1, anim2) {
      return const Center(
        child: VisionDeckModal(),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic);
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 14 * anim1.value,
          sigmaY: 14 * anim1.value,
        ),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(curved),
          child: FadeTransition(
            opacity: anim1,
            child: child,
          ),
        ),
      );
    },
  );
}

/// Interactive 5-Card Symptom Checker Carousel Modal.
class VisionDeckModal extends StatefulWidget {
  const VisionDeckModal({super.key});

  @override
  State<VisionDeckModal> createState() => _VisionDeckModalState();
}

class _VisionDeckModalState extends State<VisionDeckModal> {
  late List<SymptomCardItem> _symptoms;
  late PageController _pageController;
  int _currentPage = 0;
  bool _showResult = false;
  SimpleTriageResult? _triageResult;
  bool _isAutoAdvancing = false;

  @override
  void initState() {
    super.initState();
    _symptoms = SymptomCheckerEngine.getInitialSymptoms();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onAnswer(int index, bool isYes) {
    if (_isAutoAdvancing) return;

    HapticFeedback.lightImpact();
    setState(() {
      _symptoms[index].isYes = isYes;
    });

    _isAutoAdvancing = true;

    // Small delay to let user see selection feedback, then auto-advance
    Future.delayed(const Duration(milliseconds: 220), () {
      if (!mounted) return;
      _isAutoAdvancing = false;

      if (index < _symptoms.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeInOutCubic,
        );
      } else {
        // Last card answered -> evaluate and show result
        _completeAssessment();
      }
    });
  }

  void _completeAssessment() {
    setState(() {
      _triageResult = SymptomCheckerEngine.evaluate(_symptoms);
      _showResult = true;
    });
  }

  void _resetAssessment() {
    HapticFeedback.mediumImpact();
    setState(() {
      _symptoms = SymptomCheckerEngine.getInitialSymptoms();
      _currentPage = 0;
      _showResult = false;
      _triageResult = null;
      _isAutoAdvancing = false;
    });
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  Future<void> _launchWhatsApp(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (_) {
      // Fallback
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 560;

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: isMobile ? screenWidth * 0.94 : 500,
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: isMobile ? 640 : 660,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 20,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF0891B2).withValues(alpha: 0.35),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0891B2).withValues(alpha: 0.2),
                blurRadius: 36,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.7),
                blurRadius: 30,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── 1. Top Header & Step Progress Bar ──
                _buildHeader(isMobile),

                // ── 2. Carousel / Slider Cards OR Triage Results ──
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: _showResult && _triageResult != null
                        ? _buildResultView(isMobile, _triageResult!)
                        : _buildCarouselView(isMobile),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    final total = _symptoms.length;
    final currentStep = _showResult ? total : (_currentPage + 1);

    return Container(
      padding: EdgeInsets.fromLTRB(16, isMobile ? 12 : 14, 14, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.9),
        border: const Border(
          bottom: BorderSide(
            color: Color(0x220891B2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const RainbowLogoIcon(size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Instant Symptom Checker',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 13.5 : 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              if (!_showResult) ...[
                // Step pill badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0891B2).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF22D3EE).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    'Step $currentStep of $total',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF22D3EE),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
                tooltip: 'Close',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Progress Bar & Step Dots
          Row(
            children: [
              // 5 Pagination Indicator Dots
              ...List.generate(total, (i) {
                final isCurrent = i == _currentPage && !_showResult;
                final isAnswered = _symptoms[i].isYes != null;
                final isYes = _symptoms[i].isYes == true;

                Color dotColor;
                if (isCurrent) {
                  dotColor = const Color(0xFF22D3EE);
                } else if (isAnswered) {
                  dotColor = isYes ? const Color(0xFF10B981) : const Color(0xFF64748B);
                } else {
                  dotColor = Colors.white.withValues(alpha: 0.15);
                }

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (!_showResult) {
                        _pageController.animateToPage(
                          i,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOutCubic,
                        );
                      }
                    },
                    child: Container(
                      height: 5,
                      margin: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
                      decoration: BoxDecoration(
                        color: dotColor,
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF22D3EE).withValues(alpha: 0.6),
                                  blurRadius: 6,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselView(bool isMobile) {
    return Column(
      children: [
        // PageView Slider
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: _symptoms.length,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              final symptom = _symptoms[index];
              return _buildSingleCard(index, symptom, isMobile);
            },
          ),
        ),

        // Bottom Carousel Navigation Controls (Arrows & Review)
        _buildBottomNavControls(isMobile),
      ],
    );
  }

  /// Single Symptom Card Layout:
  /// ONLY 3 elements:
  /// 1. High-res illustration/image at the top
  /// 2. Symptom Name/Title centered below the image
  /// 3. Two action buttons: "Yes" and "No"
  Widget _buildSingleCard(int index, SymptomCardItem symptom, bool isMobile) {
    final isYes = symptom.isYes == true;
    final isNo = symptom.isYes == false;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 22,
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── 1. High-Resolution Illustration / Image at Top ──
          Expanded(
            flex: isMobile ? 5 : 6,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF0891B2).withValues(alpha: 0.35),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      symptom.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF0E3B43), Color(0xFF0F172A)],
                            ),
                          ),
                          child: Center(
                            child: FaIcon(
                              symptom.icon,
                              size: 48,
                              color: Colors.white30,
                            ),
                          ),
                        );
                      },
                    ),

                    // Ambient vignette overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.15),
                            Colors.transparent,
                            const Color(0xFF0F172A).withValues(alpha: 0.75),
                          ],
                        ),
                      ),
                    ),

                    // Category Badge Pill at top-left
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF22D3EE).withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(symptom.icon, size: 11, color: const Color(0xFF22D3EE)),
                            const SizedBox(width: 6),
                            Text(
                              symptom.category.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: Color(0xFF22D3EE),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Question Count Indicator at top-right
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '${index + 1} / ${_symptoms.length}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── 2. Centered Symptom Name / Title ──
          Column(
            children: [
              Text(
                symptom.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 17 : 19,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '(${symptom.category})',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 12 : 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── 3. Two Action Buttons: "Yes" and "No" ──
          Row(
            children: [
              // "No" Button
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => _onAnswer(index, false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isNo
                          ? const Color(0xFFEF4444).withValues(alpha: 0.25)
                          : const Color(0xFF1E293B),
                      foregroundColor: isNo ? const Color(0xFFF87171) : Colors.white,
                      elevation: 0,
                      side: BorderSide(
                        color: isNo
                            ? const Color(0xFFEF4444)
                            : Colors.white.withValues(alpha: 0.12),
                        width: isNo ? 2 : 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isNo ? Icons.check_circle_outline_rounded : Icons.close_rounded,
                          size: 18,
                          color: isNo ? const Color(0xFFF87171) : Colors.white70,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'No',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isNo ? const Color(0xFFF87171) : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // "Yes" Button
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => _onAnswer(index, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isYes
                          ? const Color(0xFF0891B2)
                          : const Color(0xFF0891B2).withValues(alpha: 0.2),
                      foregroundColor: Colors.white,
                      elevation: isYes ? 6 : 0,
                      shadowColor: const Color(0xFF0891B2).withValues(alpha: 0.5),
                      side: BorderSide(
                        color: isYes
                            ? const Color(0xFF22D3EE)
                            : const Color(0xFF0891B2).withValues(alpha: 0.6),
                        width: isYes ? 2 : 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: isYes ? Colors.white : const Color(0xFF22D3EE),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isYes ? Colors.white : const Color(0xFF22D3EE),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildBottomNavControls(bool isMobile) {
    final canGoBack = _currentPage > 0;
    final canGoForward = _currentPage < _symptoms.length - 1;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 22,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Arrow Button
          TextButton.icon(
            onPressed: canGoBack
                ? () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                    );
                  }
                : null,
            icon: const Icon(Icons.arrow_back_rounded, size: 16),
            label: const Text('Previous'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white70,
              disabledForegroundColor: Colors.white24,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),

          // Swipe / Drag tip
          Text(
            'Swipe card to navigate',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),

          // Next Arrow or Finish Button
          if (canGoForward)
            TextButton.icon(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                );
              },
              icon: const Text('Next'),
              label: const Icon(Icons.arrow_forward_rounded, size: 16),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF22D3EE),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            )
          else
            TextButton.icon(
              onPressed: _completeAssessment,
              icon: const Text('View Result'),
              label: const Icon(Icons.arrow_forward_rounded, size: 16),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF10B981),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
        ],
      ),
    );
  }

  /// Result / Triage Screen evaluating recorded responses
  Widget _buildResultView(bool isMobile, SimpleTriageResult result) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 18 : 24,
        vertical: 18,
      ),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 6),

          // ── Icon / Badge ──
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: result.statusColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: result.statusColor.withValues(alpha: 0.45),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: result.statusColor.withValues(alpha: 0.3),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                result.icon,
                size: 48,
                color: result.statusColor,
              ),
            ).animate().scale(
                  begin: const Offset(0.7, 0.7),
                  end: const Offset(1.0, 1.0),
                  duration: 400.ms,
                  curve: Curves.elasticOut,
                ),
          ),
          const SizedBox(height: 18),

          // ── Headline ──
          Text(
            result.headline,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 22 : 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ).animate().fadeIn(duration: 350.ms, delay: 100.ms),
          const SizedBox(height: 10),

          // ── Message ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Text(
              result.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 13.5 : 14.5,
                color: const Color(0xFFCBD5E1),
                height: 1.45,
              ),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 180.ms),
          const SizedBox(height: 16),

          // ── Reported Symptoms Breakdown Chips (if any) ──
          if (result.affirmativeSymptoms.isNotEmpty) ...[
            Text(
              'Reported Symptoms (${result.yesCount} of ${_symptoms.length}):',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: result.affirmativeSymptoms.map((title) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: result.statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: result.statusColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, size: 12, color: result.statusColor),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: result.statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // ── Actions: WhatsApp CTA (Condition C) or Retake Check ──
          if (result.condition == TriageConditionType.urgentConsult &&
              result.ctaUrl != null) ...[
            // Condition C: Prominent WhatsApp CTA Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF25D366).withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => _launchWhatsApp(result.ctaUrl!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 20, color: Colors.white),
                label: Text(
                  result.ctaLabel ?? 'Book Appointment on WhatsApp',
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 14 : 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 250.ms).scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                ),
            const SizedBox(height: 14),

            // Secondary Action: Retake Check
            Center(
              child: TextButton.icon(
                onPressed: _resetAssessment,
                icon: const Icon(Icons.restart_alt_rounded, size: 16),
                label: const Text('Retake Check'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF94A3B8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
            ),
          ] else ...[
            // Condition A & B: Retake Check Button
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _resetAssessment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0891B2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.restart_alt_rounded, size: 18),
                label: const Text(
                  'Retake Check',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 250.ms),
          ],
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
