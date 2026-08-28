import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../features/home/widgets/booking/booking_modal.dart';
import '../features/symptom_checker/models/symptom_models.dart';
import '../shared/widgets/rainbow_logo.dart';

/// Dedicated Instant Eye Symptom Checker Screen (`/symptom-checker`)
/// Features the sleek Obsidian Dark theme with frosted glassmorphic UI,
/// vibrant neon triage highlights, and complete cross-device responsiveness.
class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _resultCardKey = GlobalKey();

  late List<PrimarySymptomGroup> _symptomGroups;
  TriageResult? _triageResult;
  bool _isAnalyzing = false;
  bool _hasAnalyzed = false;

  @override
  void initState() {
    super.initState();
    _symptomGroups = TriageEngine.getInitialSymptoms();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _resetAssessment() {
    setState(() {
      _symptomGroups = TriageEngine.getInitialSymptoms();
      _triageResult = null;
      _isAnalyzing = false;
      _hasAnalyzed = false;
    });
  }

  void _togglePrimarySymptom(PrimarySymptomGroup group, bool isYes) {
    setState(() {
      if (group.isYes == isYes) {
        group.isYes = null;
        for (final sub in group.subQuestions) {
          sub.isYes = null;
        }
      } else {
        group.isYes = isYes;
        if (!isYes) {
          for (final sub in group.subQuestions) {
            sub.isYes = null;
          }
        }
      }
      if (_hasAnalyzed) {
        _runTriage(autoScroll: false);
      }
    });
  }

  void _toggleSubSymptom(SubSymptomQuestion question, bool isYes) {
    setState(() {
      if (question.isYes == isYes) {
        question.isYes = null;
      } else {
        question.isYes = isYes;
      }
      if (_hasAnalyzed) {
        _runTriage(autoScroll: false);
      }
    });
  }

  void _runTriage({bool autoScroll = true}) {
    setState(() {
      _isAnalyzing = true;
    });

    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() {
        _triageResult = TriageEngine.evaluate(_symptomGroups);
        _isAnalyzing = false;
        _hasAnalyzed = true;
      });

      if (autoScroll) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (!mounted) return;
          final resultContext = _resultCardKey.currentContext;
          if (resultContext != null && resultContext.mounted) {
            Scrollable.ensureVisible(
              resultContext,
              duration: const Duration(milliseconds: 650),
              curve: Curves.easeInOutCubic,
              alignment: 0.08,
            );
          }
        });
      }
    });
  }

  int get _selectedPrimaryCount =>
      _symptomGroups.where((g) => g.isYes == true).length;

  int get _answeredCount =>
      _symptomGroups.where((g) => g.isYes != null).length;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 650;
    final isTablet = screenWidth >= 650 && screenWidth <= 1024;
    final isDesktop = screenWidth > 1024;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120), // Obsidian Deep Theme
      appBar: _buildTopNav(context, isMobile),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 14 : (isTablet ? 24 : 32),
                  vertical: isMobile ? 16 : 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── 1. Hero & Clinical Intro Header ──
                    _buildHeaderHero(isMobile, isDesktop),
                    const SizedBox(height: 18),

                    // ── 2. Assessment Progress & Status Ribbon ──
                    _buildAssessmentTrackerBar(isMobile),
                    const SizedBox(height: 22),

                    // ── 3. Responsive Layout: Desktop 2-Column vs Mobile/Tablet Flow ──
                    if (isDesktop)
                      _buildDesktopTwoColumnLayout()
                    else
                      _buildMobileTabletLayout(isMobile, isTablet),

                    const SizedBox(height: 28),

                    // ── 4. Bottom Clinical Standards & Disclaimer Footer ──
                    _buildClinicalDisclaimerFooter(isMobile),
                    const SizedBox(height: 24),
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
        tooltip: 'Back to Homepage',
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
              'Symptom Triage',
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
        // Live status pill
        Container(
          margin: EdgeInsets.symmetric(
            vertical: isMobile ? 12 : 10,
            horizontal: isMobile ? 4 : 6,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 10,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF0891B2).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF22D3EE).withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                    begin: const Offset(0.85, 0.85),
                    end: const Offset(1.3, 1.3),
                    duration: 1000.ms,
                  ),
              const SizedBox(width: 5),
              Text(
                isMobile ? 'Active' : 'AI Triage Active',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF22D3EE),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.restart_alt_rounded, color: Colors.white70, size: 20),
          tooltip: 'Reset Assessment',
          padding: isMobile ? const EdgeInsets.all(4) : const EdgeInsets.all(8),
          constraints: const BoxConstraints(),
          onPressed: _resetAssessment,
        ),
        SizedBox(width: isMobile ? 8 : 12),
      ],
    );
  }

  Widget _buildHeaderHero(bool isMobile, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 26),
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
          color: const Color(0xFF0891B2).withValues(alpha: 0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0891B2).withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF0891B2).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF22D3EE).withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(FontAwesomeIcons.stethoscope, size: 11, color: Color(0xFF22D3EE)),
                    SizedBox(width: 6),
                    Text(
                      'CLINICAL OPHTHALMIC TRIAGE',
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, size: 13, color: Colors.white70),
                    SizedBox(width: 5),
                    Text(
                      'Takes ~60 Seconds',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Instant Eye Symptom Checker',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: isMobile ? 20 : 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select your active ocular symptoms below for automated clinical severity scoring, recommended ophthalmic specialist department, and urgent care timelines.',
            style: TextStyle(
              fontSize: isMobile ? 12.5 : 14.5,
              color: const Color(0xFF94A3B8),
              height: 1.45,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildAssessmentTrackerBar(bool isMobile) {
    final totalPrimary = _symptomGroups.length;
    final progress = _answeredCount / totalPrimary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 18,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  isMobile
                      ? 'Progress: $_answeredCount/$totalPrimary Evaluated'
                      : 'Assessment Progress: $_answeredCount of $totalPrimary Categories Evaluated',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isMobile ? 11.5 : 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF22D3EE),
                ),
              ),
              if (_selectedPrimaryCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0891B2).withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFF0891B2).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    '$_selectedPrimaryCount Selected',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF22D3EE),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0891B2)),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 80.ms);
  }

  /// Desktop layout with Left Symptom Checklist and Right Floating Live Result Panel
  Widget _buildDesktopTwoColumnLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Interactive Symptom Cards & Action Trigger
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._symptomGroups.asMap().entries.map((entry) {
                final index = entry.key;
                final group = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _SymptomGroupCard(
                    group: group,
                    onTogglePrimary: (isYes) => _togglePrimarySymptom(group, isYes),
                    onToggleSub: (sub, isYes) => _toggleSubSymptom(sub, isYes),
                  ).animate().fadeIn(duration: 400.ms, delay: (100 + index * 60).ms),
                );
              }),
              const SizedBox(height: 8),
              _buildAnalyzeTriggerButton(false),
            ],
          ),
        ),
        const SizedBox(width: 24),

        // Right Column: Live Triage Preview / Result Glassmorphic Card
        Expanded(
          flex: 4,
          child: _buildRightSideResultPanel(),
        ),
      ],
    );
  }

  /// Mobile & Tablet Stacked Flow
  Widget _buildMobileTabletLayout(bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isTablet)
          // 2-column balanced grid on tablet
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: _symptomGroups.map((group) {
              return SizedBox(
                width: (MediaQuery.sizeOf(context).width - 76) / 2,
                child: _SymptomGroupCard(
                  group: group,
                  onTogglePrimary: (isYes) => _togglePrimarySymptom(group, isYes),
                  onToggleSub: (sub, isYes) => _toggleSubSymptom(sub, isYes),
                ),
              );
            }).toList(),
          )
        else
          // Single-column stacked cards on mobile
          ..._symptomGroups.asMap().entries.map((entry) {
            final index = entry.key;
            final group = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _SymptomGroupCard(
                group: group,
                onTogglePrimary: (isYes) => _togglePrimarySymptom(group, isYes),
                onToggleSub: (sub, isYes) => _toggleSubSymptom(sub, isYes),
              ).animate().fadeIn(duration: 350.ms, delay: (80 + index * 50).ms),
            );
          }),

        const SizedBox(height: 16),
        _buildAnalyzeTriggerButton(true),
        const SizedBox(height: 24),

        // Result Card on Mobile / Tablet
        if (_hasAnalyzed && _triageResult != null)
          Container(
            key: _resultCardKey,
            child: _TriageResultCard(
              result: _triageResult!,
              onBookAppointment: () => _handleBookAppointment(_triageResult!),
              onReset: _resetAssessment,
            ),
          ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.05, end: 0),
      ],
    );
  }

  Widget _buildAnalyzeTriggerButton(bool isFullWidth) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0891B2).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isAnalyzing ? null : () => _runTriage(autoScroll: true),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0891B2),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF0891B2).withValues(alpha: 0.6),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (_isAnalyzing)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              const FaIcon(
                FontAwesomeIcons.wandMagicSparkles,
                size: 15,
                color: Colors.white,
              ),
            const SizedBox(width: 10),
            Text(
              _isAnalyzing
                  ? 'Evaluating Clinical Data...'
                  : (_hasAnalyzed ? 'Recalculate Triage Analysis' : 'Analyze My Symptoms'),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildRightSideResultPanel() {
    if (!_hasAnalyzed || _triageResult == null) {
      return _buildPendingAnalysisPlaceholder();
    }

    return Container(
      key: _resultCardKey,
      child: _TriageResultCard(
        result: _triageResult!,
        onBookAppointment: () => _handleBookAppointment(_triageResult!),
        onReset: _resetAssessment,
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildPendingAnalysisPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0891B2).withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF0891B2).withValues(alpha: 0.3),
              ),
            ),
            child: const FaIcon(
              FontAwesomeIcons.shieldHeart,
              size: 30,
              color: Color(0xFF22D3EE),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Live Triage Scoring Panel',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Review each symptom category on the left, select Yes or No to explore clinical sub-indicators, and click "Analyze My Symptoms" to generate your personalized triage report.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF94A3B8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline_rounded, size: 14, color: Color(0xFF94A3B8)),
                SizedBox(width: 6),
                Text(
                  '100% Confidential & Secure Assessment',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleBookAppointment(TriageResult result) {
    final symptomSummary = _symptomGroups
        .where((g) => g.isYes == true)
        .map((g) => g.title)
        .join(', ');

    final prefilledNotes = 'Triage Concern: ${result.suspectedCondition}\nActive Symptoms: $symptomSummary (${result.urgencyBadge})';

    showBookingDialog(
      context,
      initialTreatment: result.departmentBookingName,
      prefilledNotes: prefilledNotes,
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

/// Interactive primary symptom card with responsive layout and animated expandable sub-questions.
class _SymptomGroupCard extends StatelessWidget {
  final PrimarySymptomGroup group;
  final ValueChanged<bool> onTogglePrimary;
  final Function(SubSymptomQuestion, bool) onToggleSub;

  const _SymptomGroupCard({
    required this.group,
    required this.onTogglePrimary,
    required this.onToggleSub,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = group.isYes == true;
    final isDismissed = group.isYes == false;

    final cardOpacity = isDismissed ? 0.58 : 1.0;

    Color borderColor = Colors.white.withValues(alpha: 0.08);
    if (isSelected) {
      borderColor = const Color(0xFF0891B2).withValues(alpha: 0.75);
    } else if (isDismissed) {
      borderColor = Colors.white.withValues(alpha: 0.04);
    }

    Color bgColor = const Color(0xFF1E293B).withValues(alpha: 0.75);
    if (isSelected) {
      bgColor = const Color(0xFF132D46).withValues(alpha: 0.85);
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: cardOpacity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0891B2).withValues(alpha: 0.22),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Primary Symptom Header with LayoutBuilder for narrow screen resilience ──
              Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrowCard = constraints.maxWidth < 480;

                    if (isNarrowCard) {
                      // Stacked layout for narrow screen
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _buildIconBox(isSelected, isDismissed),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  group.title,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : (isDismissed ? const Color(0xFF94A3B8) : Colors.white),
                                  ),
                                ),
                              ),
                              if (isSelected && group.affirmativeSubCount > 0) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0891B2).withValues(alpha: 0.35),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${group.affirmativeSubCount}/3 Present',
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF22D3EE),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            group.subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDismissed ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: _PrimaryYesNoToggle(
                              isYes: group.isYes,
                              onToggle: onTogglePrimary,
                            ),
                          ),
                        ],
                      );
                    }

                    // Standard responsive row layout
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildIconBox(isSelected, isDismissed),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      group.title,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white
                                            : (isDismissed ? const Color(0xFF94A3B8) : Colors.white),
                                      ),
                                    ),
                                  ),
                                  if (isSelected && group.affirmativeSubCount > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0891B2).withValues(alpha: 0.35),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '${group.affirmativeSubCount}/3 Present',
                                        style: const TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF22D3EE),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                group.subtitle,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: isDismissed
                                      ? const Color(0xFF64748B)
                                      : const Color(0xFF94A3B8),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        _PrimaryYesNoToggle(
                          isYes: group.isYes,
                          onToggle: onTogglePrimary,
                        ),
                      ],
                    );
                  },
                ),
              ),

              // ── Expandable Sub-Symptoms Section ──
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: _buildSubSymptomsList(),
                crossFadeState: isSelected
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
                sizeCurve: Curves.easeInOutCubic,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconBox(bool isSelected, bool isDismissed) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF0891B2).withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF22D3EE).withValues(alpha: 0.6)
              : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: FaIcon(
        group.icon,
        size: 18,
        color: isSelected
            ? const Color(0xFF22D3EE)
            : (isDismissed ? const Color(0xFF64748B) : Colors.white),
      ),
    );
  }

  Widget _buildSubSymptomsList() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.65),
        border: const Border(
          top: BorderSide(
            color: Color(0x200891B2),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.checklist_rounded,
                size: 14,
                color: Color(0xFF22D3EE),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'CLINICAL INDICATORS (TAP TO SPECIFY)',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: const Color(0xFF22D3EE).withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...group.subQuestions.map((sub) {
            return _SubSymptomPillRow(
              question: sub,
              onToggle: (isYes) => onToggleSub(sub, isYes),
            );
          }),
        ],
      ),
    );
  }
}

/// Primary Yes/No Action Toggle
class _PrimaryYesNoToggle extends StatelessWidget {
  final bool? isYes;
  final ValueChanged<bool> onToggle;

  const _PrimaryYesNoToggle({
    required this.isYes,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isYesActive = isYes == true;
    final isNoActive = isYes == false;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Yes Button
          InkWell(
            onTap: () => onToggle(true),
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isYesActive ? const Color(0xFF0891B2) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isYesActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0891B2).withValues(alpha: 0.5),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_rounded,
                    size: 13,
                    color: isYesActive ? Colors.white : const Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: isYesActive ? Colors.white : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 2),

          // No Button
          InkWell(
            onTap: () => onToggle(false),
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isNoActive ? const Color(0xFF0891B2) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isNoActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0891B2).withValues(alpha: 0.5),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.close_rounded,
                    size: 13,
                    color: isNoActive ? Colors.white : const Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'No',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: isNoActive ? Colors.white : const Color(0xFF94A3B8),
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

/// Sub-symptom question row with adaptive responsive layout for narrow mobile screens.
class _SubSymptomPillRow extends StatelessWidget {
  final SubSymptomQuestion question;
  final ValueChanged<bool> onToggle;

  const _SubSymptomPillRow({
    required this.question,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isYes = question.isYes == true;
    final isNo = question.isYes == false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: (isYes || isNo)
              ? const Color(0xFF0891B2).withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: (isYes || isNo)
                ? const Color(0xFF0891B2).withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 420;

            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.text,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: (isYes || isNo) ? FontWeight.w600 : FontWeight.w400,
                      color: (isYes || isNo) ? Colors.white : const Color(0xFFCBD5E1),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPillButton('Yes', isYes, const Color(0xFF0891B2), () => onToggle(true)),
                        const SizedBox(width: 6),
                        _buildPillButton('No', isNo, const Color(0xFF0891B2), () => onToggle(false)),
                      ],
                    ),
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: Text(
                    question.text,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: (isYes || isNo) ? FontWeight.w600 : FontWeight.w400,
                      color: (isYes || isNo) ? Colors.white : const Color(0xFFCBD5E1),
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPillButton('Yes', isYes, const Color(0xFF0891B2), () => onToggle(true)),
                    const SizedBox(width: 6),
                    _buildPillButton('No', isNo, const Color(0xFF0891B2), () => onToggle(false)),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPillButton(String label, bool isSelected, Color activeColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? activeColor : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }
}

/// Glassmorphic Clinical Triage Result Card
class _TriageResultCard extends StatelessWidget {
  final TriageResult result;
  final VoidCallback onBookAppointment;
  final VoidCallback onReset;

  const _TriageResultCard({
    required this.result,
    required this.onBookAppointment,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final isEmergency = result.urgency == TriageUrgency.emergency;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: result.primaryColor.withValues(alpha: 0.55),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: result.primaryColor.withValues(alpha: isEmergency ? 0.28 : 0.16),
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Urgency Ribbon Header ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: result.primaryColor.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: result.primaryColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            result.statusIcon,
                            size: 12,
                            color: result.primaryColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            result.urgencyBadge,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: result.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      result.timeFrame,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: result.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Suspected Condition Title ──
                Text(
                  result.suspectedCondition,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),

                // Condition Description
                Text(
                  result.conditionDescription,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFFCBD5E1),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Recommended Specialist Highlight ──
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF0891B2).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0891B2).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.userDoctor,
                          size: 15,
                          color: Color(0xFF22D3EE),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'RECOMMENDED CLINICAL SPECIALIST',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              result.recommendedSpecialist,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Clinical Assessment Protocols ──
                const Text(
                  'Recommended Clinical Pathway:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                ...result.clinicalKeyPoints.map((point) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 14,
                          color: result.primaryColor,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            point,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF94A3B8),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 18),

                // ── CTAs ──
                ElevatedButton(
                  onPressed: onBookAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: result.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.calendarCheck,
                        size: 14,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Book Specialist Appointment',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: onReset,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF94A3B8),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Retake Assessment',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
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
