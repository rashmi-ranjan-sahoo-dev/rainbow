import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/social_icon_row.dart';

/// Section 1 — Slim dark utility strip above the header.
/// Shows official hospital address, landline & mobile numbers, timings, and social icons.
class TopUtilityBar extends StatelessWidget {
  const TopUtilityBar({super.key});

  static Future<void> _makeCall(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hide entirely on mobile screens < 600px
    if (ResponsiveHelper.isMobile(context)) {
      return const SizedBox.shrink();
    }

    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      width: double.infinity,
      color: AppColors.secondary,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.horizontalPadding(context),
            ),
            child: Row(
              children: [
                // ── Left side: Contact Info ──
                Expanded(
                  child: Wrap(
                    spacing: 18,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (!isTablet)
                        const _InfoChip(
                          icon: FontAwesomeIcons.locationDot,
                          text: 'Madhavadhara, Visakhapatnam – 530018',
                          tooltip: 'Opp. SVBN EM School, Kapparada, NGGO Colony, P.R Gardens, Madhavadhara, Visakhapatnam – 530018',
                        ),
                      _InfoChip(
                        icon: FontAwesomeIcons.phone,
                        text: '+91 83411 04525',
                        onTap: () => _makeCall('+918341104525'),
                      ),
                      // _InfoChip(
                      //   icon: FontAwesomeIcons.phoneFlip,
                      //   text: '0891-2554525',
                      //   onTap: () => _makeCall('08912554525'),
                      // ),
                      const _InfoChip(
                        icon: FontAwesomeIcons.solidClock,
                        text: 'Mon–Sat: 9 AM – 7 PM',
                      ),
                    ],
                  ),
                ),

                // ── Right side: Social Icons ──
                const SocialIconRow(
                  iconSize: 12.5,
                  iconColor: Colors.white70,
                  spacing: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A single interactive chip inside the utility bar with hover effect and click action.
class _InfoChip extends StatefulWidget {
  final FaIconData icon;
  final String text;
  final String? tooltip;
  final VoidCallback? onTap;

  const _InfoChip({
    required this.icon,
    required this.text,
    this.tooltip,
    this.onTap,
  });

  @override
  State<_InfoChip> createState() => _InfoChipState();
}

class _InfoChipState extends State<_InfoChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Widget child = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _isHovered && widget.onTap != null
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                widget.icon,
                size: 11,
                color: _isHovered ? AppColors.primaryLight : AppColors.primaryLight.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 6),
              Text(
                widget.text,
                style: AppTypography.utilityBar.copyWith(
                  color: _isHovered && widget.onTap != null
                      ? Colors.white
                      : AppColors.textLight,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: child,
      );
    }

    return child;
  }
}
