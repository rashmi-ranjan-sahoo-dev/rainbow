import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/section_navigator.dart';
import '../../../../shared/widgets/scroll_reveal.dart';
import 'hospital_footer.dart';
import 'map_embed/map_view.dart';

/// Section 11 — Contact Us & Interactive Real Location Map Section with Consultation Form and Hospital Footer.
/// Includes staggered scroll reveal animations and real satellite location imagery.
class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  static const _googleMapsUrl =
      'https://maps.google.com/?q=Rainbow+Eye+Hospital+Madhavadhara+Visakhapatnam+530018';

  static Future<void> _launchUrlString(String urlStr) async {
    final uri = Uri.parse(urlStr);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      try {
        await launchUrl(uri);
      } catch (_) {}
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 700;
    final isTablet = screenWidth >= 700 && screenWidth < 1100;

    return Container(
      key: SectionNavigator.contactKey,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surface, // Clean Medical Slate Surface (0xFFF8FAFC)
      ),
      child: Column(
        children: [
          // ── Main Content Container ──
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 44 : 64,
              horizontal: ResponsiveHelper.horizontalPadding(context),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1320),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── 1. Section Header with Scroll Reveal ──
                  ScrollReveal(
                    slideOffset: 0.12,
                    duration: const Duration(milliseconds: 700),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.09),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.locationDot,
                                size: 11,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                'GET IN TOUCH & VISIT US',
                                style: AppTypography.sectionEyebrow(
                                  color: AppColors.primary,
                                  fontSize: isMobile ? 11 : 12,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'We Are Here For Your Vision Care\nVisit Us or Send an Enquiry',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: isMobile ? 22 : 34,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.25,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Comprehensive ophthalmic consultations, laser diagnostics, emergency eye care & surgical appointments in Visakhapatnam.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: isMobile ? 12.5 : 14.5,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isMobile ? 28 : 42),

                  // ── 2. Two-Column Layout (Cards + Form on Left, Real Location Map on Right) ──
                  if (isMobile || isTablet)
                    Column(
                      children: [
                        const _ContactInfoCards(),
                        const SizedBox(height: 24),
                        ScrollReveal(
                          delay: const Duration(milliseconds: 200),
                          slideOffset: 0.10,
                          duration: const Duration(milliseconds: 700),
                          child: const _InteractiveContactForm(),
                        ),
                        const SizedBox(height: 24),
                        ScrollReveal(
                          delay: const Duration(milliseconds: 300),
                          slideOffset: 0.10,
                          duration: const Duration(milliseconds: 700),
                          child: const _HospitalMapCard(),
                        ),
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column (Details & Form) with Staggered Reveals
                        const Expanded(
                          flex: 11,
                          child: Column(
                            children: [
                              _ContactInfoCards(),
                              SizedBox(height: 20),
                              ScrollReveal(
                                delay: Duration(milliseconds: 250),
                                slideOffset: 0.10,
                                duration: Duration(milliseconds: 700),
                                child: _InteractiveContactForm(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 28),

                        // Right Column (Real Location Map Card)
                        const Expanded(
                          flex: 10,
                          child: ScrollReveal(
                            delay: Duration(milliseconds: 200),
                            slideOffset: 0.12,
                            duration: Duration(milliseconds: 750),
                            child: _HospitalMapCard(),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // ── 3. Bottom Footer with 4-Columns, Floating Capsule Nav & Scroll-To-Top ──
          const HospitalFooter(),
        ],
      ),
    );
  }
}

/// 4 Quick-Contact Info tiles with staggered scroll animations, click-to-call, click-to-email, and directions.
class _ContactInfoCards extends StatelessWidget {
  const _ContactInfoCards();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 560;

        return Column(
          children: [
            if (isNarrow) ...[
              const ScrollReveal(
                delay: Duration(milliseconds: 80),
                slideOffset: 0.08,
                child: _ContactInfoTile(
                  icon: FontAwesomeIcons.locationDot,
                  accentColor: AppColors.primary,
                  title: 'Hospital Location',
                  primaryText: 'Madhavadhara, Visakhapatnam – 530018',
                  secondaryText: 'Opp. SVBN EM School, Kapparada, NGGO Colony, P.R Gardens',
                  actionLabel: 'Get Directions ↗',
                  actionUrl: _ContactSectionState._googleMapsUrl,
                ),
              ),
              const SizedBox(height: 12),
              const ScrollReveal(
                delay: Duration(milliseconds: 160),
                slideOffset: 0.08,
                child: _ContactInfoTile(
                  icon: FontAwesomeIcons.phone,
                  accentColor: Color(0xFF0D9488),
                  title: 'Phone & Emergency',
                  primaryText: '+91 83411 04525',
                  secondaryText: '0891 2704525 • 24x7 Eye Emergency Helpline',
                  actionLabel: 'Call Now',
                  phoneNumber: '+918341104525',
                ),
              ),
              const SizedBox(height: 12),
              const ScrollReveal(
                delay: Duration(milliseconds: 240),
                slideOffset: 0.08,
                child: _ContactInfoTile(
                  icon: FontAwesomeIcons.envelope,
                  accentColor: Color(0xFF0284C7),
                  title: 'Official Email',
                  primaryText: 'info@rainboweyehospital.com',
                  secondaryText: 'appointments@rainboweyehospital.com',
                  actionLabel: 'Send Email',
                  emailAddress: 'info@rainboweyehospital.com',
                ),
              ),
              const SizedBox(height: 12),
              const ScrollReveal(
                delay: Duration(milliseconds: 320),
                slideOffset: 0.08,
                child: _ContactInfoTile(
                  icon: FontAwesomeIcons.clock,
                  accentColor: Color(0xFFD97706),
                  title: 'Working Hours',
                  primaryText: 'Mon – Sat: 8:00 AM – 8:30 PM',
                  secondaryText: 'Sunday: 9:00 AM – 2:00 PM • 24x7 Retina Trauma',
                ),
              ),
            ] else ...[
              const Row(
                children: [
                  Expanded(
                    child: ScrollReveal(
                      delay: Duration(milliseconds: 100),
                      slideOffset: 0.08,
                      child: _ContactInfoTile(
                        icon: FontAwesomeIcons.locationDot,
                        accentColor: AppColors.primary,
                        title: 'Hospital Location',
                        primaryText: 'Madhavadhara, Visakhapatnam – 530018',
                        secondaryText: 'Opp. SVBN EM School, Kapparada, NGGO Colony',
                        actionLabel: 'Get Directions ↗',
                        actionUrl: _ContactSectionState._googleMapsUrl,
                      ),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: ScrollReveal(
                      delay: Duration(milliseconds: 180),
                      slideOffset: 0.08,
                      child: _ContactInfoTile(
                        icon: FontAwesomeIcons.phone,
                        accentColor: Color(0xFF0D9488),
                        title: 'Phone & Emergency',
                        primaryText: '+91 83411 04525',
                        secondaryText: '0891 2704525 • 24x7 Eye Emergency Helpline',
                        actionLabel: 'Call Now',
                        phoneNumber: '+918341104525',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Row(
                children: [
                  Expanded(
                    child: ScrollReveal(
                      delay: Duration(milliseconds: 260),
                      slideOffset: 0.08,
                      child: _ContactInfoTile(
                        icon: FontAwesomeIcons.envelope,
                        accentColor: Color(0xFF0284C7),
                        title: 'Official Email',
                        primaryText: 'info@rainboweyehospital.com',
                        secondaryText: 'appointments@rainboweyehospital.com',
                        actionLabel: 'Send Email',
                        emailAddress: 'info@rainboweyehospital.com',
                      ),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: ScrollReveal(
                      delay: Duration(milliseconds: 340),
                      slideOffset: 0.08,
                      child: _ContactInfoTile(
                        icon: FontAwesomeIcons.clock,
                        accentColor: Color(0xFFD97706),
                        title: 'Working Hours',
                        primaryText: 'Mon – Sat: 8:00 AM – 8:30 PM',
                        secondaryText: 'Sunday: 9:00 AM – 2:00 PM • 24x7 Retina Care',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

/// A single interactive contact info tile with micro-interaction hover state.
class _ContactInfoTile extends StatefulWidget {
  final FaIconData icon;
  final Color accentColor;
  final String title;
  final String primaryText;
  final String secondaryText;
  final String? actionLabel;
  final String? actionUrl;
  final String? phoneNumber;
  final String? emailAddress;

  const _ContactInfoTile({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.primaryText,
    required this.secondaryText,
    this.actionLabel,
    this.actionUrl,
    this.phoneNumber,
    this.emailAddress,
  });

  @override
  State<_ContactInfoTile> createState() => _ContactInfoTileState();
}

class _ContactInfoTileState extends State<_ContactInfoTile> {
  bool _isHovered = false;

  void _handleTap() {
    if (widget.phoneNumber != null) {
      _ContactSectionState._makeCall(widget.phoneNumber!);
    } else if (widget.emailAddress != null) {
      _ContactSectionState._sendEmail(widget.emailAddress!);
    } else if (widget.actionUrl != null) {
      _ContactSectionState._launchUrlString(widget.actionUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isClickable = widget.phoneNumber != null ||
        widget.emailAddress != null ||
        widget.actionUrl != null;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isClickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: isClickable ? _handleTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor.withValues(alpha: 0.50)
                  : AppColors.divider,
              width: _isHovered ? 1.4 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: widget.accentColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: widget.accentColor.withValues(alpha: 0.22),
                  ),
                ),
                child: Center(
                  child: FaIcon(
                    widget.icon,
                    size: 16,
                    color: widget.accentColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: widget.accentColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.primaryText,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.secondaryText,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                    if (widget.actionLabel != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        widget.actionLabel!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: widget.accentColor,
                        ),
                      ),
                    ],
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

/// Interactive Consultation & Enquiry Form with validation and responsive inputs.
class _InteractiveContactForm extends StatefulWidget {
  const _InteractiveContactForm();

  @override
  State<_InteractiveContactForm> createState() => _InteractiveContactFormState();
}

class _InteractiveContactFormState extends State<_InteractiveContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _isSuccess = false;
    });

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();

    final buffer = StringBuffer();
    buffer.writeln('Hi Rainbow Eye Hospital, I would like to send a consultation enquiry.');
    buffer.writeln('• Name: $name');
    buffer.writeln('• Mobile: $phone');
    if (email.isNotEmpty) {
      buffer.writeln('• Email: $email');
    }
    if (message.isNotEmpty) {
      buffer.writeln('• Query / Notes: $message');
    }

    final encodedText = Uri.encodeComponent(buffer.toString());
    final whatsappUrl = 'https://wa.me/918341104525?text=$encodedText';
    final uri = Uri.parse(whatsappUrl);

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await launchUrl(uri);
    }

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _isSuccess = true;
      });

      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.divider,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.paperPlane,
                      size: 13,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Send Consultation Enquiry',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Our clinical coordinator will call back within 15 minutes',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Success State Banner
            if (_isSuccess) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.40),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Enquiry submitted successfully! Our medical team will contact you shortly.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF065F46),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Input Fields Row 1: Name & Phone
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 500;
                if (isNarrow) {
                  return Column(
                    children: [
                      _buildTextFormField(
                        controller: _nameController,
                        hint: 'Full Patient Name *',
                        icon: Icons.person_outline_rounded,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter name' : null,
                      ),
                      const SizedBox(height: 12),
                      _buildTextFormField(
                        controller: _phoneController,
                        hint: 'Mobile Number *',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (v) => (v == null || v.trim().length < 10) ? 'Enter 10-digit number' : null,
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: _buildTextFormField(
                        controller: _nameController,
                        hint: 'Full Patient Name *',
                        icon: Icons.person_outline_rounded,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter name' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextFormField(
                        controller: _phoneController,
                        hint: 'Mobile Number *',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (v) => (v == null || v.trim().length < 10) ? 'Enter 10-digit number' : null,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),

            // Input Field: Email Address
            _buildTextFormField(
              controller: _emailController,
              hint: 'Email Address (Optional)',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),

            // Message Field
            _buildTextFormField(
              controller: _messageController,
              hint: 'Describe your query or preferred appointment date & time...',
              icon: Icons.chat_bubble_outline_rounded,
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.whatsapp, size: 16, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Submit Enquiry & Request Call Back',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12.5,
          color: Color(0xFF94A3B8),
        ),
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
      ),
    );
  }
}

/// Interactive Live Google Map View without any intrusive cards or popup overlays.
class _HospitalMapCard extends StatelessWidget {
  const _HospitalMapCard();

  static const String _embedMapUrl =
      'https://maps.google.com/maps?q=Rainbow+Eye+Hospital+Madhavadhara+Visakhapatnam&t=&z=16&ie=UTF8&iwloc=near&output=embed';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 700;
    final isTablet = screenWidth >= 700 && screenWidth < 1080;

    // Desktop matches the full height of the left contact column (~540px)
    // Tablet ~440px, Mobile ~360px
    final double mapCardHeight = isMobile ? 360.0 : (isTablet ? 440.0 : 540.0);

    return Container(
      width: double.infinity,
      height: mapCardHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: GoogleMapEmbedView(
          embedUrl: _embedMapUrl,
        ),
      ),
    );
  }
}
