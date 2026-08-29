import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/section_navigator.dart';
import '../../../../shared/widgets/rainbow_logo.dart';
import '../../../../shared/widgets/social_icon_row.dart';
import '../../../symptom_checker/widgets/vision_deck_modal.dart';
import '../booking/booking_modal.dart';

/// Opens the mobile drawer with a customized smooth 420ms cubic slide-in curve.
void openSmoothDrawer(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss Drawer',
    barrierColor: Colors.black.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 420),
    pageBuilder: (context, anim1, anim2) {
      return const Align(
        alignment: Alignment.centerRight,
        child: MobileDrawer(),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      final curvedAnim = CurvedAnimation(
        parent: anim1,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(curvedAnim),
        child: child,
      );
    },
  );
}

/// Full-screen slide-in navigation drawer for mobile / tablet screens with direct section navigation.
class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.84,
        constraints: const BoxConstraints(maxWidth: 380),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color(0x28000000),
              blurRadius: 30,
              offset: Offset(-8, 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Drawer Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RainbowLogo(
                      iconSize: 34,
                      onTap: () {
                        Navigator.pop(context);
                        SectionNavigator.scrollTo(SectionNavigator.heroKey);
                      },
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded, size: 24),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.divider),

              // ── Navigation List ──
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _DrawerNavItem(
                      title: 'Home',
                      icon: FontAwesomeIcons.house,
                      onTap: () {
                        Navigator.pop(context);
                        SectionNavigator.scrollTo(SectionNavigator.heroKey);
                      },
                    ),
                    _DrawerNavItem(
                      title: 'About Us',
                      icon: FontAwesomeIcons.hospital,
                      onTap: () {
                        Navigator.pop(context);
                        SectionNavigator.scrollTo(SectionNavigator.aboutKey);
                      },
                    ),
                    _DrawerNavItem(
                      title: 'Symptom Checker (AI Triage)',
                      icon: FontAwesomeIcons.heartPulse,
                      onTap: () {
                        Navigator.pop(context);
                        showVisionDeckModal(context);
                      },
                    ),
                    _DrawerNavItem(
                      title: 'Treatments & Services',
                      icon: FontAwesomeIcons.stethoscope,
                      onTap: () {
                        Navigator.pop(context);
                        SectionNavigator.scrollTo(SectionNavigator.servicesKey);
                      },
                    ),
                    _DrawerNavItem(
                      title: 'Our Eye Specialists',
                      icon: FontAwesomeIcons.userDoctor,
                      onTap: () {
                        Navigator.pop(context);
                        SectionNavigator.scrollTo(SectionNavigator.doctorsKey);
                      },
                    ),
                    _DrawerNavItem(
                      title: 'Hospital Tour & Gallery',
                      icon: FontAwesomeIcons.cameraRetro,
                      onTap: () {
                        Navigator.pop(context);
                        SectionNavigator.scrollTo(SectionNavigator.galleryKey);
                      },
                    ),
                    _DrawerNavItem(
                      title: 'Patient Stories & Reviews',
                      icon: FontAwesomeIcons.solidStar,
                      onTap: () {
                        Navigator.pop(context);
                        SectionNavigator.scrollTo(SectionNavigator.testimonialsKey);
                      },
                    ),
                    _DrawerNavItem(
                      title: 'Knowledge Base & Blogs',
                      icon: FontAwesomeIcons.bookOpen,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/blogs');
                      },
                    ),
                    _DrawerNavItem(
                      title: 'Contact Us',
                      icon: FontAwesomeIcons.envelope,
                      onTap: () {
                        Navigator.pop(context);
                        SectionNavigator.scrollTo(SectionNavigator.contactKey);
                      },
                    ),
                  ],
                ),
              ),

              // ── Drawer Bottom Action Area ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    top: BorderSide(color: AppColors.divider, width: 1),
                  ),
                ),
                child: Column(
                  children: [
                    // Phone chip
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.12),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.phone,
                            size: 13,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Emergency Helpline',
                              style: AppTypography.navLink.copyWith(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              '+91 83411 04525',
                              style: AppTypography.navLink.copyWith(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Book Appointment CTA
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.calendarCheck,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Book Appointment',
                              style: AppTypography.buttonPrimary.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Social Icon Row
                    const SocialIconRow(
                      iconSize: 16,
                      iconColor: AppColors.textSecondary,
                      spacing: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerNavItem extends StatelessWidget {
  final String title;
  final FaIconData icon;
  final VoidCallback onTap;

  const _DrawerNavItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FaIcon(
        icon,
        size: 17,
        color: AppColors.primary,
      ),
      title: Text(
        title,
        style: AppTypography.drawerItem.copyWith(fontSize: 14),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: AppColors.textMuted,
      ),
      onTap: onTap,
    );
  }
}
