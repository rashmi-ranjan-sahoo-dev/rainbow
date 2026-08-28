import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/section_navigator.dart';
import '../../../../shared/widgets/scroll_reveal.dart';

/// Premium Multi-Column Hospital Footer matching the app's primary brand theme:
/// - Primary Brand Cyan/Teal Gradient Backdrop
/// - 4 Information Columns (About, Links, Services, Contacts)
/// - Dot Pattern Background Accents
/// - Copyright Bar with Scroll-To-Top Button
/// - Fully Responsive across Mobile, Tablet, and Desktop
class HospitalFooter extends StatelessWidget {
  const HospitalFooter({super.key});

  static Future<void> _makeCall(String phoneNumber) async {
    final clean = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static Future<void> _sendEmail(String email) async {
    final uri = Uri.parse('mailto:$email?subject=Enquiry%20to%20Rainbow%20Eye%20Hospital');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static Future<void> _launchMaps() async {
    const url = 'https://maps.google.com/?q=Rainbow+Eye+Hospital+Madhavadhara+Visakhapatnam+530018';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 700;
    final isTablet = screenWidth >= 700 && screenWidth < 1080;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,  // Color(0xFF0E7490)
            AppColors.primary,      // Color(0xFF0891B2)
            AppColors.primaryDeep,  // Color(0xFF155E75)
          ],
        ),
      ),
      child: Stack(
        children: [
          // ── Decorative Dot Pattern Grid in Corners ──
          Positioned(
            top: 10,
            left: 10,
            child: Opacity(
              opacity: 0.14,
              child: CustomPaint(
                size: const Size(120, 100),
                painter: _DotPatternPainter(),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 15,
            child: Opacity(
              opacity: 0.14,
              child: CustomPaint(
                size: const Size(130, 110),
                painter: _DotPatternPainter(),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: screenWidth * 0.35,
            child: Opacity(
              opacity: 0.10,
              child: CustomPaint(
                size: const Size(110, 70),
                painter: _DotPatternPainter(),
              ),
            ),
          ),

          // ── Main Content Container ──
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 36 : 52,
              horizontal: ResponsiveHelper.horizontalPadding(context),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1320),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── Top Four Information Columns ──
                    if (isMobile)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ScrollReveal(
                            delay: Duration(milliseconds: 100),
                            slideOffset: 0.08,
                            child: _AboutColumn(),
                          ),
                          const SizedBox(height: 32),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ScrollReveal(
                                  delay: Duration(milliseconds: 200),
                                  slideOffset: 0.08,
                                  child: _LinksColumn(),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: ScrollReveal(
                                  delay: Duration(milliseconds: 300),
                                  slideOffset: 0.08,
                                  child: _ServicesColumn(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          const ScrollReveal(
                            delay: Duration(milliseconds: 400),
                            slideOffset: 0.08,
                            child: _ContactsColumn(),
                          ),
                        ],
                      )
                    else if (isTablet)
                      Column(
                        children: [
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: ScrollReveal(
                                  delay: Duration(milliseconds: 100),
                                  slideOffset: 0.08,
                                  child: _AboutColumn(),
                                ),
                              ),
                              SizedBox(width: 32),
                              Expanded(
                                flex: 6,
                                child: ScrollReveal(
                                  delay: Duration(milliseconds: 200),
                                  slideOffset: 0.08,
                                  child: _ContactsColumn(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 36),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ScrollReveal(
                                  delay: Duration(milliseconds: 300),
                                  slideOffset: 0.08,
                                  child: _LinksColumn(),
                                ),
                              ),
                              SizedBox(width: 32),
                              Expanded(
                                child: ScrollReveal(
                                  delay: Duration(milliseconds: 400),
                                  slideOffset: 0.08,
                                  child: _ServicesColumn(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Column 1: About
                          Expanded(
                            flex: 9,
                            child: ScrollReveal(
                              delay: Duration(milliseconds: 100),
                              slideOffset: 0.08,
                              child: _AboutColumn(),
                            ),
                          ),
                          SizedBox(width: 36),

                          // Column 2: Links
                          Expanded(
                            flex: 5,
                            child: ScrollReveal(
                              delay: Duration(milliseconds: 200),
                              slideOffset: 0.08,
                              child: _LinksColumn(),
                            ),
                          ),
                          SizedBox(width: 24),

                          // Column 3: Services
                          Expanded(
                            flex: 6,
                            child: ScrollReveal(
                              delay: Duration(milliseconds: 300),
                              slideOffset: 0.08,
                              child: _ServicesColumn(),
                            ),
                          ),
                          SizedBox(width: 36),

                          // Column 4: Contacts
                          Expanded(
                            flex: 10,
                            child: ScrollReveal(
                              delay: Duration(milliseconds: 400),
                              slideOffset: 0.08,
                              child: _ContactsColumn(),
                            ),
                          ),
                        ],
                      ),

                    SizedBox(height: isMobile ? 32 : 44),
                    Divider(color: Colors.white.withValues(alpha: 0.20), height: 1),
                    SizedBox(height: isMobile ? 22 : 28),

                    // ── Bottom Copyright Bar & Scroll-To-Top Button ──
                    const _BottomCopyrightBar(),
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

/// Column 1: About Hospital + Social Media Icons
class _AboutColumn extends StatelessWidget {
  const _AboutColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Rainbow Eye Hospital is a leading center of excellence in Visakhapatnam committed to precision clinical diagnosis, advanced laser surgeries, and compassionate eye care for all generations.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.85),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        const _SocialMediaButtonsRow(),
      ],
    );
  }
}

/// Column 2: Quick Links
class _LinksColumn extends StatelessWidget {
  const _LinksColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Links',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 14),
        _FooterLinkItem(
          title: 'About',
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.aboutKey),
        ),
        _FooterLinkItem(
          title: 'Surgical',
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.servicesKey),
        ),
        _FooterLinkItem(
          title: 'Ophthalmology',
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.servicesKey),
        ),
        _FooterLinkItem(
          title: 'Lenses',
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.servicesKey),
        ),
        _FooterLinkItem(
          title: 'Laser Eye',
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.servicesKey),
        ),
        _FooterLinkItem(
          title: 'Vision Correction',
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.servicesKey),
        ),
      ],
    );
  }
}

/// Column 3: Services List
class _ServicesColumn extends StatelessWidget {
  const _ServicesColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Services',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 14),
        _FooterLinkItem(
          title: 'Contact Lens',
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.servicesKey),
        ),
        _FooterLinkItem(
          title: 'Retinopathy',
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.servicesKey),
        ),
        _FooterLinkItem(
          title: 'Qualified Doctors',
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.doctorsKey),
        ),
        _FooterLinkItem(
          title: 'Modern Equipment',
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.aboutKey),
        ),
        _FooterLinkItem(
          title: 'Emergency Help',
          onTap: () => HospitalFooter._makeCall('+918341104525'),
        ),
        _FooterLinkItem(
          title: 'Individual Approach',
          onTap: () => SectionNavigator.scrollTo(SectionNavigator.aboutKey),
        ),
      ],
    );
  }
}

/// Column 4: Contact details with icons
class _ContactsColumn extends StatelessWidget {
  const _ContactsColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contacts',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 14),

        // Address
        _ContactRow(
          icon: FontAwesomeIcons.locationDot,
          text: 'Opp. SVBN EM School, Kapparada,\nNGGO Colony, P.R Gardens,\nMadhavadhara, Visakhapatnam - 530018',
          onTap: HospitalFooter._launchMaps,
        ),
        const SizedBox(height: 12),

        // Landline Phone
        _ContactRow(
          icon: FontAwesomeIcons.phone,
          text: '0891 - 2554525 / 2704525',
          onTap: () => HospitalFooter._makeCall('08912554525'),
        ),
        const SizedBox(height: 12),

        // Mobile / Emergency Phone
        _ContactRow(
          icon: FontAwesomeIcons.phoneFlip,
          text: '+91 - 8341104525',
          onTap: () => HospitalFooter._makeCall('+918341104525'),
        ),
        const SizedBox(height: 12),

        // Official Email
        _ContactRow(
          icon: FontAwesomeIcons.envelope,
          text: 'rainboweyehospitalvizag@gmail.com',
          onTap: () => HospitalFooter._sendEmail('rainboweyehospitalvizag@gmail.com'),
        ),
      ],
    );
  }
}

/// Contact row with crisp white/aqua icon and interactive link
class _ContactRow extends StatefulWidget {
  final FaIconData icon;
  final String text;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  State<_ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<_ContactRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              child: FaIcon(
                widget.icon,
                size: 13,
                color: _isHovered ? Colors.white : const Color(0xFF00E5FF),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.5,
                  color: _isHovered ? Colors.white : Colors.white.withValues(alpha: 0.90),
                  height: 1.45,
                  decoration: _isHovered ? TextDecoration.underline : TextDecoration.none,
                  decorationColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Single interactive footer link item with hover animation
class _FooterLinkItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _FooterLinkItem({
    required this.title,
    required this.onTap,
  });

  @override
  State<_FooterLinkItem> createState() => _FooterLinkItemState();
}

class _FooterLinkItemState extends State<_FooterLinkItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: _isHovered ? const Color(0xFF00E5FF) : Colors.white.withValues(alpha: 0.85),
              fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w400,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isHovered) ...[
                  const Icon(Icons.arrow_right_rounded, size: 14, color: Color(0xFF00E5FF)),
                  const SizedBox(width: 2),
                ],
                Text(widget.title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Social media circular buttons row
class _SocialMediaButtonsRow extends StatelessWidget {
  const _SocialMediaButtonsRow();

  static const _socials = [
    {'icon': FontAwesomeIcons.facebookF, 'url': 'https://facebook.com'},
    {'icon': FontAwesomeIcons.instagram, 'url': 'https://instagram.com'},
    {'icon': FontAwesomeIcons.youtube, 'url': 'https://youtube.com'},
    {'icon': FontAwesomeIcons.linkedinIn, 'url': 'https://linkedin.com'},
    {'icon': FontAwesomeIcons.xTwitter, 'url': 'https://twitter.com'},
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: _socials.map((item) {
        return _SocialIconButton(
          icon: item['icon'] as FaIconData,
          url: item['url'] as String,
        );
      }).toList(),
    );
  }
}

class _SocialIconButton extends StatefulWidget {
  final FaIconData icon;
  final String url;

  const _SocialIconButton({
    required this.icon,
    required this.url,
  });

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          HapticFeedback.lightImpact();
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered
                ? Colors.white
                : Colors.white.withValues(alpha: 0.15),
            border: Border.all(
              color: _isHovered ? Colors.white : Colors.white.withValues(alpha: 0.35),
              width: 1.2,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.40),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: FaIcon(
              widget.icon,
              size: 13,
              color: _isHovered ? AppColors.primary : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom Copyright Bar with Smooth Scroll-To-Top button
class _BottomCopyrightBar extends StatelessWidget {
  const _BottomCopyrightBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 40), // Balances the scroll-to-top button on wide screens
        const Expanded(
          child: Text(
            'Rainbow Eye Hospital © 2026 All Right Reserved',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        const _ScrollToTopFloatingButton(),
      ],
    );
  }
}

/// Floating Scroll-to-Top circular button (↑)
class _ScrollToTopFloatingButton extends StatefulWidget {
  const _ScrollToTopFloatingButton();

  @override
  State<_ScrollToTopFloatingButton> createState() => _ScrollToTopFloatingButtonState();
}

class _ScrollToTopFloatingButtonState extends State<_ScrollToTopFloatingButton> {
  bool _isHovered = false;

  void _scrollToTop() {
    HapticFeedback.mediumImpact();
    SectionNavigator.scrollTo(SectionNavigator.heroKey);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _scrollToTop,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered ? const Color(0xFF00E5FF) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.20),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.arrow_upward_rounded,
              color: _isHovered ? Colors.white : AppColors.primary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

/// Subtle dot pattern grid painter for background corners
class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const double dotRadius = 1.8;
    const double spacing = 12.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
