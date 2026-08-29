import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../features/symptom_checker/models/symptom_models.dart';
import '../shared/widgets/rainbow_logo.dart';

/// Dedicated Instant Eye Symptom Checker Screen (`/symptom-checker`)
/// Features a streamlined 5-card carousel/slider with auto-advance,
/// interactive manual navigation, and conditional triage results.
class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
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

    // Brief feedback pause before sliding to next card
    Future.delayed(const Duration(milliseconds: 220), () {
      if (!mounted) return;
      _isAutoAdvancing = false;

      if (index < _symptoms.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 340),
          curve: Curves.easeInOutCubic,
        );
      } else {
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
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 650;
    final isTablet = screenWidth >= 650 && screenWidth <= 1024;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120), // Deep Obsidian
      appBar: _buildTopNav(context, isMobile),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 14 : (isTablet ? 24 : 32),
                  vertical: isMobile ? 14 : 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── 1. Hero / Clinical Header ──
                    _buildHeaderHero(isMobile),
                    const SizedBox(height: 16),

                    // ── 2. Carousel & Triage Card Container ──
                    _buildMainCardContainer(isMobile),
                    const SizedBox(height: 20),

                    // ── 3. Clinical Disclaimer Footer ──
                    _buildClinicalDisclaimerFooter(isMobile),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTopNav(BuildContext context, bool isMobile) {
    return AppBar(
      backgroundColor: const Color(0xFF0F172A).withValues(alpha: 0.96),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: isMobile ? 0 : NavigationToolbar.kMiddleSpacing,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        tooltip: 'Back to Home',
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacementNamed(context, '/');
          }
        },
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isMobile
              ? const RainbowLogoIcon(size: 26)
              : const RainbowLogo(iconSize: 28),
          const SizedBox(width: 8),
          Container(
            height: 16,
            width: 1,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Symptom Checker',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: isMobile ? 14 : 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.restart_alt_rounded, color: Colors.white70, size: 20),
          tooltip: 'Reset Assessment',
          padding: isMobile ? const EdgeInsets.all(4) : const EdgeInsets.all(8),
          constraints: const BoxConstraints(),
          onPressed: _resetAssessment,
        ),
        SizedBox(width: isMobile ? 8 : 14),
      ],
    );
  }

  Widget _buildHeaderHero(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1E293B),
            Color(0xFF0E3B43),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF0891B2).withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0891B2).withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF0891B2).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF22D3EE).withValues(alpha: 0.5),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(FontAwesomeIcons.stethoscope, size: 11, color: Color(0xFF22D3EE)),
                    SizedBox(width: 6),
                    Text(
                      'INSTANT EYE TRIAGE',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: Color(0xFF22D3EE),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_outlined, size: 13, color: Colors.white70),
                  SizedBox(width: 4),
                  Text(
                    '5 Quick Questions',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Instant Eye Symptom Checker',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: isMobile ? 20 : 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Answer 5 simple yes/no questions to check your symptoms and receive instant guidance.',
            style: TextStyle(
              fontSize: isMobile ? 12.5 : 14,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildMainCardContainer(bool isMobile) {
    final total = _symptoms.length;
    final currentStep = _showResult ? total : (_currentPage + 1);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF0891B2).withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0891B2).withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            // ── Top Step Indicator Bar ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.8),
                border: const Border(
                  bottom: BorderSide(
                    color: Color(0x1F0891B2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _showResult ? 'Assessment Complete' : 'Step $currentStep of $total',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF22D3EE),
                        ),
                      ),
                      Text(
                        _showResult
                            ? '100%'
                            : '${((currentStep / total) * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 5 Step Segment Progress Dots
                  Row(
                    children: List.generate(total, (i) {
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
                            height: 6,
                            margin: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
                            decoration: BoxDecoration(
                              color: dotColor,
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: isCurrent
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF22D3EE).withValues(alpha: 0.6),
                                        blurRadius: 8,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // ── Dynamic Body: Carousel Slider OR Result View ──
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: _showResult && _triageResult != null
                  ? _buildResultView(isMobile, _triageResult!)
                  : _buildCarouselView(isMobile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselView(bool isMobile) {
    return Column(
      children: [
        SizedBox(
          height: isMobile ? 440 : 480,
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
        _buildBottomNavControls(isMobile),
      ],
    );
  }

  Widget _buildSingleCard(int index, SymptomCardItem symptom, bool isMobile) {
    final isYes = symptom.isYes == true;
    final isNo = symptom.isYes == false;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 18 : 28,
        vertical: 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── 1. Top Image Banner ──
          Expanded(
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

                    // Question Pill at top-left
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            const Text(
                              'EYE CHECK',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: Color(0xFF22D3EE),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Card index pill
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '${index + 1} / ${_symptoms.length}',
                          style: const TextStyle(
                            fontSize: 11.5,
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
          const SizedBox(height: 16),

          // ── 2. Centered Symptom Question / Title ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              symptom.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 18 : 21,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // ── 3. Two Action Buttons: "Yes" and "No" ──
          Row(
            children: [
              // "No" Button
              Expanded(
                child: SizedBox(
                  height: 54,
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
                          size: 20,
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
                  height: 54,
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
                          size: 20,
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
        horizontal: isMobile ? 18 : 28,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
            ),
          ),
          Text(
            'Swipe left / right to review',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),
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
              ),
            )
          else
            TextButton.icon(
              onPressed: _completeAssessment,
              icon: const Text('View Result'),
              label: const Icon(Icons.arrow_forward_rounded, size: 16),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF10B981),
              ),
            ),
        ],
      ),
    );
  }

  /// Result / Triage Screen evaluating recorded responses
  Widget _buildResultView(bool isMobile, SimpleTriageResult result) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Icon / Badge ──
          Center(
            child: Container(
              padding: const EdgeInsets.all(22),
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
                    blurRadius: 32,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                result.icon,
                size: 52,
                color: result.statusColor,
              ),
            ).animate().scale(
                  begin: const Offset(0.7, 0.7),
                  end: const Offset(1.0, 1.0),
                  duration: 400.ms,
                  curve: Curves.elasticOut,
                ),
          ),
          const SizedBox(height: 20),

          // ── Headline ──
          Text(
            result.headline,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ).animate().fadeIn(duration: 350.ms, delay: 100.ms),
          const SizedBox(height: 12),

          // ── Message ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Text(
              result.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 14 : 15.5,
                color: const Color(0xFFCBD5E1),
                height: 1.5,
              ),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 180.ms),
          const SizedBox(height: 20),

          // ── Reported Symptoms Breakdown Chips (if any) ──
          if (result.affirmativeSymptoms.isNotEmpty) ...[
            Text(
              'Reported Symptoms (${result.yesCount} of ${_symptoms.length}):',
              style: const TextStyle(
                fontSize: 12.5,
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: result.statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: result.statusColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, size: 13, color: result.statusColor),
                      const SizedBox(width: 6),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: result.statusColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // ── Actions: WhatsApp CTA (Condition C) or Retake Check ──
          if (result.condition == TriageConditionType.urgentConsult &&
              result.ctaUrl != null) ...[
            // Prominent WhatsApp CTA Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF25D366).withValues(alpha: 0.45),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => _launchWhatsApp(result.ctaUrl!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 22, color: Colors.white),
                label: Text(
                  result.ctaLabel ?? 'Book Appointment on WhatsApp',
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 15 : 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 250.ms).scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                ),
            const SizedBox(height: 16),

            // Secondary Action: Retake Check
            Center(
              child: TextButton.icon(
                onPressed: _resetAssessment,
                icon: const Icon(Icons.restart_alt_rounded, size: 16),
                label: const Text('Retake Check'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF94A3B8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
          ] else ...[
            // Condition A & B: Retake Check Button
            SizedBox(
              height: 52,
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
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 250.ms),
          ],
        ],
      ),
    );
  }

  Widget _buildClinicalDisclaimerFooter(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: Color(0xFF94A3B8),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Clinical Advisory & Disclaimer: This automated diagnostic triage tool is designed for informational and educational orientation purposes only. It does not replace a clinical examination by an ophthalmologist. For acute trauma, sudden vision loss, or severe pain, immediately visit our 24/7 Emergency Eye Care unit or dial +91 83411 04525.',
              style: TextStyle(
                fontSize: isMobile ? 11.5 : 12,
                color: const Color(0xFF94A3B8),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
