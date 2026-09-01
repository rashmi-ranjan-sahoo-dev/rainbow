import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/responsive_helper.dart';
import '../features/home/widgets/booking/booking_modal.dart';
import '../features/home/widgets/contact/hospital_footer.dart';
import '../shared/widgets/floating_whatsapp_button.dart';
import '../shared/widgets/rainbow_logo.dart';

/// Standalone Full-Page Privacy Policy (`/privacy`).
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 650;
    final isTablet = screenWidth >= 650 && screenWidth < 1080;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildTopNav(context, isMobile),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // ── 1. Hero Header Banner ──
                _buildHeroBanner(context, isMobile, isTablet),

                SizedBox(height: isMobile ? 20 : 36),

                // ── 2. Main Content Card ──
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : ResponsiveHelper.horizontalPadding(context),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1080),
                    child: _buildPrivacyContent(context, isMobile),
                  ),
                ),

                SizedBox(height: isMobile ? 28 : 48),

                // ── 3. Bottom Consultation Banner ──
                _buildBottomBanner(context, isMobile),

                SizedBox(height: isMobile ? 32 : 48),

                // ── 4. Full Hospital Footer ──
                const HospitalFooter(),
              ],
            ),
          ),

          // ── Sticky Floating WhatsApp Button ──
          const FloatingWhatsAppButton(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildTopNav(BuildContext context, bool isMobile) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      titleSpacing: isMobile ? 0 : NavigationToolbar.kMiddleSpacing,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
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
          RainbowLogo(
            iconSize: isMobile ? 24 : 30,
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 10),
            Container(
              height: 18,
              width: 1.5,
              color: const Color(0xFFE2E8F0),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                'Privacy Policy',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: isMobile ? 8 : 16),
          child: ElevatedButton.icon(
            onPressed: () => showBookingDialog(context),
            icon: const FaIcon(FontAwesomeIcons.calendarCheck, size: 12),
            label: Text(
              isMobile ? 'Book' : 'Book Appointment',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 12 : 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 10 : 16,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroBanner(BuildContext context, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF0D9488),
            Color(0xFF134E4A),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : ResponsiveHelper.horizontalPadding(context),
        vertical: isMobile ? 28 : 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/'),
                    child: const Text(
                      'Home',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: Colors.white54,
                    ),
                  ),
                  const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5EEAD4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Patient Privacy & Health Data Protection',
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 22 : 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Rainbow Eye Hospital is committed to safeguarding patient privacy, confidential medical records, and diagnostic information in full compliance with Indian Health Data Privacy Standards.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isMobile ? 13 : 15,
                  color: Colors.white.withValues(alpha: 0.90),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.shield_outlined, size: 14, color: Color(0xFF5EEAD4)),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'NABH Standards & Digital Personal Data Protection (DPDP) Act Compliant',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: isMobile ? 11.5 : 12,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyContent(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _SectionBlock(
            number: '1',
            title: 'Information We Collect',
            content:
                'We collect information necessary to provide safe, personalized eye care and seamless hospital administration:\n\n• Patient Identity & Contact: Full name, age, gender, phone number, email address, and residential address.\n• Clinical & Ocular Data: Medical history, visual acuity measurements, intraocular pressure (IOP), corneal topography scans, OCT images, surgical notes, and prescribed eye medications.\n• Appointment & Booking Details: Preferred specialist, selected date/time, and appointment mode.\n• Insurance & Billing Data: Policy identification, TPA member details, and payment transaction references.',
          ),
          _SectionBlock(
            number: '2',
            title: 'How We Use Your Medical & Personal Data',
            content:
                'Patient data is collected strictly for legitimate clinical and healthcare management purposes:\n\n• Providing accurate ophthalmic diagnosis, surgical interventions, and post-operative follow-up care.\n• Sending appointment confirmations, diagnostic report readiness alerts, and medication reminders via SMS / WhatsApp.\n• Processing cashless insurance pre-authorizations and claims settlement.\n• Internal clinical quality improvement and compliance with NABH / National Health Authority benchmarks.\n\nWe NEVER sell, rent, or trade your personal health information to third-party marketing companies.',
          ),
          _SectionBlock(
            number: '3',
            title: 'Protection of Protected Health Information (PHI)',
            content:
                'Rainbow Eye Hospital employs robust digital and physical safeguards to ensure data confidentiality:\n\n• 256-bit SSL encryption for all digital transmissions and booking submissions.\n• Role-based restricted access allowing only treating ophthalmologists and authorized clinical staff to view medical charts.\n• Secure, access-logged Hospital Information System (HIS) with daily automated backups and disaster recovery protocols.',
          ),
          _SectionBlock(
            number: '4',
            title: 'Information Sharing & Third-Party Disclosure',
            content:
                'Your information may only be shared under the following strictly defined conditions:\n\n• Referring Physicians & Speciality Labs: For specialized pathology or systemic health evaluations.\n• Insurance TPAs & Government Schemes: For cashless claims processing with patient consent.\n• Statutory & Legal Compliance: When mandated by medical regulatory authorities or lawful judicial orders.',
          ),
          _SectionBlock(
            number: '5',
            title: 'Cookies & Digital Analytics',
            content:
                'Our website uses essential and analytics cookies to optimize page load speeds, remember user preferences, and measure website traffic patterns. Cookies do not store sensitive medical records or financial details. You can manage or disable cookie preferences through your web browser settings.',
          ),
          _SectionBlock(
            number: '6',
            title: 'Patient Rights & Data Access',
            content:
                'As a patient of Rainbow Eye Hospital, you have the right to:\n\n• Request digital or printed copies of your medical records, diagnostic scans, and discharge summaries.\n• Request correction of any inaccurate personal or demographic details in our hospital registry.\n• Withdraw consent for non-essential communications (e.g., hospital newsletters or health awareness tips).',
          ),
          _SectionBlock(
            number: '7',
            title: 'Grievance Officer & Data Privacy Officer',
            content:
                'If you have questions, concerns, or grievances regarding our privacy practices or wish to access your diagnostic records, please contact our Data Protection Officer:\n\nData Privacy & Grievance Officer\nRainbow Eye Hospital\nOpp. SVBN EM School, Kapparada, NGGO Colony, P.R Gardens, Madhavadhara, Visakhapatnam - 530018\nEmail: rainboweyehospitalvizag@gmail.com\nHelpline: +91 83411 04525',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBanner(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : ResponsiveHelper.horizontalPadding(context),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 18 : 32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0D9488), Color(0xFF134E4A)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0D9488).withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Health Information Is Confidential',
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 17 : 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Experience world-class eye care backed by secure clinical systems and dedicated medical specialists.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isMobile ? 12.5 : 14,
                  color: Colors.white.withValues(alpha: 0.90),
                ),
              ),
              if (isMobile) ...[
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => showBookingDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0D9488),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Book Consultation',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () => showBookingDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0D9488),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Book Consultation',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final String number;
  final String title;
  final String content;

  const _SectionBlock({
    required this.number,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 650;

    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 22 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: isMobile ? 24 : 28,
                height: isMobile ? 24 : 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile ? 12 : 13,
                      color: const Color(0xFF0D9488),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: isMobile ? 15 : 17,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: isMobile ? 0 : 38),
            child: Text(
              content,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isMobile ? 13 : 14,
                color: const Color(0xFF334155),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
