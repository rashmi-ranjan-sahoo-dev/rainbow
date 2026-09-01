import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/responsive_helper.dart';
import '../features/home/widgets/booking/booking_modal.dart';
import '../features/home/widgets/contact/hospital_footer.dart';
import '../shared/widgets/floating_whatsapp_button.dart';
import '../shared/widgets/rainbow_logo.dart';

/// Standalone Full-Page Terms & Conditions (`/terms`).
class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

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
                    child: _buildTermsContent(context, isMobile),
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
                'Terms & Conditions',
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
            Color(0xFF0E7490),
            Color(0xFF155E75),
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
                    'Terms & Conditions',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Terms of Service & Hospital Policies',
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 22 : 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please read these terms carefully before accessing Rainbow Eye Hospital services, scheduling appointments, or utilizing our digital diagnostic triage tools.',
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
                    child: Icon(Icons.verified_outlined, size: 14, color: AppColors.accentLight),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Last Updated: September 2026 • Governed by AP Clinical Establishments Act',
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

  Widget _buildTermsContent(BuildContext context, bool isMobile) {
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
            title: 'Acceptance of Terms',
            content:
                'By accessing the Rainbow Eye Hospital website, scheduling an outpatient consultation, registering for surgical evaluations, or using our interactive Vision Symptom Checker, you signify your agreement to these Terms and Conditions and our Privacy Policy. If you do not agree with any part of these terms, please do not use our digital services or web portal.',
          ),
          _SectionBlock(
            number: '2',
            title: 'Medical Disclaimer & Emergency Notice',
            content:
                'The information provided on this website—including health blog articles, disease summaries, recovery recommendations, and automated symptom checker results—is intended solely for educational and informational purposes.\n\nIt does NOT constitute professional medical diagnosis, prescription, or clinical advice. Always seek the advice of our qualified ophthalmologists regarding any eye condition.\n\n⚠️ IN CASE OF OCULAR EMERGENCY (e.g., sudden loss of vision, chemical splashes, acute severe eye trauma, or severe eye pain with vomiting), immediately visit our 24/7 Casualty & Emergency Desk at Madhavadhara, Visakhapatnam or call our helpline (+91 83411 04525).',
          ),
          _SectionBlock(
            number: '3',
            title: 'Appointments, Booking & Rescheduling',
            content:
                '• Outpatient (OPD) slots booked online or via WhatsApp are provisional until confirmed by our front-office reception team.\n• Patients are requested to arrive 15 minutes prior to their scheduled slot with existing medical prescriptions, previous eye scans, and government ID.\n• Dilated eye examinations (retina/cataract) may take 2–3 hours. Patients are advised not to drive after dilation.\n• Rescheduling or cancellation can be done without penalty by notifying our helpdesk at least 2 hours in advance.',
          ),
          _SectionBlock(
            number: '4',
            title: 'Surgical Procedures & Informed Consent',
            content:
                'All surgical procedures (including SMILE Pro, Contoura LASIK, Micro-Incision Cataract Surgery, Retinal Interventions, and Glaucoma Shunts) require a mandatory in-person diagnostic evaluation by a senior specialist, comprehensive biometric corneal mapping, and written informed consent outlining surgical benefits, potential risks, and post-operative protocols.',
          ),
          _SectionBlock(
            number: '5',
            title: 'Instant Symptom Checker & AI Triage Tool',
            content:
                'Our Vision Deck Symptom Checker provides rule-based preliminary triage based on patient-entered ocular symptoms. It does not replace a physical slit-lamp examination or optical coherence tomography (OCT) scan. Rainbow Eye Hospital assumes no liability for decisions made solely based on self-assessment triage outputs.',
          ),
          _SectionBlock(
            number: '6',
            title: 'Payment, Insurance & Cashless Claims',
            content:
                'Rainbow Eye Hospital is empaneled with major Third-Party Administrators (TPAs), private health insurers, Aarogyasri, and corporate health policies. Cashless pre-authorization is subject to the insurer’s terms and submission of valid policy documentation. Consultation fees and diagnostic investigations must be settled at the time of service unless covered under an approved cashless claim.',
          ),
          _SectionBlock(
            number: '7',
            title: 'Intellectual Property & Website Usage',
            content:
                'All trademarks, logos, clinical photography, educational diagrams, and website content are the exclusive intellectual property of Rainbow Eye Hospital. Unauthorized duplication, scraping, commercial reproduction, or re-distribution is strictly prohibited without prior written authorization.',
          ),
          _SectionBlock(
            number: '8',
            title: 'Contact Information & Grievance Redressal',
            content:
                'For any legal queries, feedback, or grievances regarding these terms, please contact:\n\nRainbow Eye Hospital\nAttn: Hospital Administrator & Legal Compliance\nOpp. SVBN EM School, Kapparada, NGGO Colony, P.R Gardens, Madhavadhara, Visakhapatnam - 530018\nEmail: rainboweyehospitalvizag@gmail.com\nPhone: +91 83411 04525',
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
              colors: [Color(0xFF0891B2), Color(0xFF0E7490)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Have Questions About Our Policies?',
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 17 : 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Our patient care desk is available 24/7 to assist you with any questions, appointments, or insurance verification.',
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
                      foregroundColor: AppColors.primary,
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
                    foregroundColor: AppColors.primary,
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
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile ? 12 : 13,
                      color: AppColors.primary,
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
