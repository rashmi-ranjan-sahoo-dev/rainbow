import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../shared/widgets/scroll_reveal.dart';

/// Data model for an animated trust statistic.
class StatData {
  final FaIconData icon;
  final num targetNumber;
  final bool isDecimal;
  final String suffix;
  final String label;

  const StatData({
    required this.icon,
    required this.targetNumber,
    this.isDecimal = false,
    this.suffix = '',
    required this.label,
  });
}

/// Section 4 — Animated trust stats counter bar with smooth hover cards.
class TrustStatsBar extends StatefulWidget {
  const TrustStatsBar({super.key});

  @override
  State<TrustStatsBar> createState() => _TrustStatsBarState();
}

class _TrustStatsBarState extends State<TrustStatsBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hasAnimated = false;

  static const _stats = [
    StatData(
      icon: FontAwesomeIcons.hospital,
      targetNumber: 25,
      suffix: '+',
      label: 'Years of Clinical\nExcellence',
    ),
    StatData(
      icon: FontAwesomeIcons.userDoctor,
      targetNumber: 50,
      suffix: '+',
      label: 'AIIMS & Fellowship\nSurgeons',
    ),
    StatData(
      icon: FontAwesomeIcons.eye,
      targetNumber: 100000,
      suffix: '+',
      label: 'Successful Eye\nProcedures',
    ),
    StatData(
      icon: FontAwesomeIcons.solidStar,
      targetNumber: 4.9,
      isDecimal: true,
      suffix: '',
      label: 'Patient Rating\n(50k+ Reviews)',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction > 0.15 && mounted) {
      _hasAnimated = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return VisibilityDetector(
      key: const Key('trust_stats_bar_trigger'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.statsGradient),
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 32 : 46,
          horizontal: ResponsiveHelper.horizontalPadding(context),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1320),
            child: isMobile
                ? _buildMobileGrid()
                : _buildDesktopRow(),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopRow() {
    return IntrinsicHeight(
      child: Row(
        children: _stats.asMap().entries.map((entry) {
          final isLast = entry.key == _stats.length - 1;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ScrollReveal(
                    delay: Duration(milliseconds: entry.key * 95),
                    duration: const Duration(milliseconds: 750),
                    slideOffset: 0.08,
                    child: _AnimatedStatCard(
                      data: entry.value,
                      animation: _controller,
                      delay: entry.key * 0.15,
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.0),
                          Colors.white.withValues(alpha: 0.25),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMobileGrid() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 24,
      children: _stats.asMap().entries.map((entry) {
        return SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.42,
          child: ScrollReveal(
            delay: Duration(milliseconds: entry.key * 95),
            duration: const Duration(milliseconds: 750),
            slideOffset: 0.08,
            child: _AnimatedStatCard(
              data: entry.value,
              animation: _controller,
              delay: entry.key * 0.15,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// A single interactive stat card with numerical ticker and smooth hover animation.
class _AnimatedStatCard extends StatefulWidget {
  final StatData data;
  final AnimationController animation;
  final double delay;

  const _AnimatedStatCard({
    required this.data,
    required this.animation,
    required this.delay,
  });

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard> {
  bool _isHovered = false;

  String _formatValue(double progress) {
    if (widget.data.isDecimal) {
      final current = (widget.data.targetNumber * progress);
      return current.toStringAsFixed(1);
    } else {
      final current = (widget.data.targetNumber * progress).round();
      if (widget.data.targetNumber >= 100000) {
        if (current >= 100000) {
          return '1,00,000';
        }
        return current.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            );
      }
      return current.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final numberSize = isMobile ? 28.0 : 38.0;
    final labelSize = isMobile ? 12.0 : 13.5;
    final iconSize = isMobile ? 20.0 : 24.0;

    final delayedAnimation = CurvedAnimation(
      parent: widget.animation,
      curve: Interval(
        widget.delay.clamp(0.0, 0.6),
        (widget.delay + 0.5).clamp(0.0, 1.0),
        curve: Curves.easeOutExpo,
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: FadeTransition(
        opacity: delayedAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _isHovered ? -6 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? Colors.white.withValues(alpha: 0.25)
                  : Colors.transparent,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Circle with smooth hover bounce/glow
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: iconSize + 24,
                height: iconSize + 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isHovered
                      ? Colors.white.withValues(alpha: 0.25)
                      : Colors.white.withValues(alpha: 0.12),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.2),
                            blurRadius: 12,
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: FaIcon(
                    widget.data.icon,
                    size: iconSize,
                    color: _isHovered ? AppColors.accentLight : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Animated Number Counter Ticker
              AnimatedBuilder(
                animation: delayedAnimation,
                builder: (context, child) {
                  return Text(
                    '${_formatValue(delayedAnimation.value)}${widget.data.suffix}',
                    style: AppTypography.statNumber(numberSize),
                  );
                },
              ),
              const SizedBox(height: 4),

              // Label
              Text(
                widget.data.label,
                textAlign: TextAlign.center,
                style: AppTypography.statLabel(labelSize),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
