import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';

/// Opens the global "Book Eye Consultation" modal with backdrop blur and smooth scale-fade transition.
void showBookingDialog(
  BuildContext context, {
  String? initialTreatment,
  String? prefilledNotes,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close Appointment Modal',
    barrierColor: Colors.black.withValues(alpha: 0.60),
    transitionDuration: const Duration(milliseconds: 380),
    pageBuilder: (context, anim1, anim2) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Center(
          child: BookingModal(
            initialTreatment: initialTreatment,
            prefilledNotes: prefilledNotes,
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      final curved = CurvedAnimation(
        parent: anim1,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return ScaleTransition(
        scale: Tween<double>(begin: 0.90, end: 1.0).animate(curved),
        child: FadeTransition(
          opacity: curved,
          child: child,
        ),
      );
    },
  );
}

/// Global Interactive Appointment Booking Modal Card
class BookingModal extends StatefulWidget {
  final String? initialTreatment;
  final String? prefilledNotes;

  const BookingModal({
    super.key,
    this.initialTreatment,
    this.prefilledNotes,
  });

  @override
  State<BookingModal> createState() => _BookingModalState();
}

class _BookingModalState extends State<BookingModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  late String _selectedTreatment;
  bool _isSubmitting = false;

  static const List<String> _treatments = [
    'LASIK & Contoura Vision (Blade-Free)',
    'Micro-Incision Cataract Surgery (MICS)',
    'Retina & Diabetic Eye Care',
    'Glaucoma Care & Laser Treatment',
    'Dry Eyes & Ocular Surface Care',
    'Pediatric Ophthalmology & Squint',
    'Cornea & Keratoconus Care',
    'General Comprehensive Eye Checkup',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialTreatment != null) {
      final match = _treatments.firstWhere(
        (t) => t.toLowerCase().contains(widget.initialTreatment!.toLowerCase()) ||
            widget.initialTreatment!.toLowerCase().contains(t.toLowerCase()),
        orElse: () => _treatments.first,
      );
      _selectedTreatment = match;
    } else {
      _selectedTreatment = _treatments.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirmSlot() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final treatment = _selectedTreatment;

    final buffer = StringBuffer();
    buffer.writeln('Hi, I would like to book an eye consultation.');
    buffer.writeln('• Name: $name');
    buffer.writeln('• Mobile: $phone');
    buffer.write('• Treatment: $treatment');

    if (widget.prefilledNotes != null && widget.prefilledNotes!.trim().isNotEmpty) {
      buffer.write('\n• Notes: ${widget.prefilledNotes!.trim()}');
    }

    final encodedText = Uri.encodeComponent(buffer.toString());
    final whatsappUrl =
        'https://wa.me/918341104525?text=$encodedText';

    final uri = Uri.parse(whatsappUrl);

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Fallback in case external application launch fails
      await launchUrl(uri);
    }

    if (mounted) {
      setState(() => _isSubmitting = false);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 580;

    return Material(
      color: Colors.transparent,
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: 24,
          ),
          child: Container(
            width: isMobile ? screenWidth * 0.94 : 520,
            constraints: const BoxConstraints(
              maxWidth: 520,
            ),
            padding: EdgeInsets.all(isMobile ? 20 : 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 36,
                  offset: const Offset(0, 16),
                ),
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 1. Modal Header & Close Button ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.20),
                          ),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.calendarCheck,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Book Eye Consultation',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: isMobile ? 17 : 20,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isMobile
                                  ? 'AIIMS-Trained • Instant Confirmation'
                                  : 'AIIMS-Trained Specialists • Priority Confirmation',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF64748B),
                          size: 22,
                        ),
                        splashRadius: 20,
                        tooltip: 'Close',
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 18),

                  // ── Optional Prefilled Notes Banner ──
                  if (widget.prefilledNotes != null && widget.prefilledNotes!.trim().isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.health_and_safety_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.prefilledNotes!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E293B),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ── 2. Full Name Input ──
                  const Text(
                    'Full Name *',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter patient full name',
                      hintStyle: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.5,
                        color: Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(
                        Icons.person_outline_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.2),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ── 3. Mobile Number Input ──
                  const Text(
                    'Mobile Number *',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d+\s-]')),
                    ],
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. 9876543210',
                      hintStyle: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.5,
                        color: Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.2),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                      if (digitsOnly.length < 8) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ── 4. Treatment / Concern Dropdown ──
                  const Text(
                    'Select Treatment / Concern',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedTreatment,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primary,
                        ),
                        items: _treatments.map((treatment) {
                          return DropdownMenuItem(
                            value: treatment,
                            child: Text(
                              treatment,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedTreatment = val);
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── 5. Submit Button ("Confirm Appointment Slot →") ──
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _handleConfirmSlot,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: AppColors.primary.withValues(alpha: 0.35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Confirm Appointment Slot →',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Privacy / Security guarantee micro-label
                  const Center(
                    child: Text(
                      '🔒 Fast WhatsApp confirmation • No waiting queues',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
