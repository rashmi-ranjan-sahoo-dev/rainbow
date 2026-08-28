import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';

/// Opens the interactive Appointment Booking dialog with smooth 450ms scale-fade animation.
void showBookingDialog(
  BuildContext context, {
  String? initialTreatment,
  String? prefilledNotes,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close Appointment Modal',
    barrierColor: Colors.black.withValues(alpha: 0.6),
    transitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (context, anim1, anim2) {
      return Center(
        child: BookingModal(
          initialTreatment: initialTreatment,
          prefilledNotes: prefilledNotes,
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
      return ScaleTransition(
        scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved),
        child: FadeTransition(opacity: anim1, child: child),
      );
    },
  );
}

/// Interactive appointment booking modal card with department selector and confirmation.
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
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  late String _selectedTreatment;
  bool _isSubmitted = false;

  final List<String> _treatments = [
    'LASIK & Contoura Vision',
    'Cataract Micro-Surgery',
    'Retina & Diabetic Eye Care',
    'Glaucoma Consultation',
    'Pediatric & Squint Clinic',
    'Comprehensive 20-Point Checkup',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialTreatment != null &&
        _treatments.contains(widget.initialTreatment)) {
      _selectedTreatment = widget.initialTreatment!;
    } else {
      _selectedTreatment = 'LASIK & Contoura Vision';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 550;

    return Material(
      color: Colors.transparent,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: isMobile ? screenWidth * 0.92 : 520,
            constraints: const BoxConstraints(maxWidth: 520),
            margin: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: 24,
            ),
            padding: EdgeInsets.all(isMobile ? 18 : 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.25),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: _isSubmitted
                ? _buildSuccessView()
                : _buildBookingForm(isMobile),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingForm(bool isMobile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Modal Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.calendarCheck,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Book Eye Consultation',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: isMobile ? 15.5 : 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          isMobile
                              ? 'AIIMS-Trained • Zero Wait'
                              : 'AIIMS-Trained Specialists • Zero Waiting Time',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
              splashRadius: 20,
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Divider(height: 1, color: AppColors.divider),
        if (widget.prefilledNotes != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
                width: 1,
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
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ] else ...[
          const SizedBox(height: 18),
        ],

        // Patient Name Field
        const Text(
          'Full Name',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Enter patient full name',
            hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            prefixIcon: const Icon(Icons.person_outline_rounded, size: 18, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Phone Number Field
        const Text(
          'Mobile Number',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: '+91 98765 43210',
            hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            prefixIcon: const Icon(Icons.phone_outlined, size: 18, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Treatment Selection Dropdown
        const Text(
          'Select Treatment / Concern',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.divider),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTreatment,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
              items: _treatments.map((t) {
                return DropdownMenuItem(
                  value: t,
                  child: Text(
                    t,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedTreatment = val);
              },
            ),
          ),
        ),
        const SizedBox(height: 22),

        // Submit Button
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: 'Confirm Appointment Slot',
            padding: const EdgeInsets.symmetric(vertical: 14),
            onPressed: () {
              setState(() => _isSubmitted = true);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF10B981).withValues(alpha: 0.12),
          ),
          child: const Center(
            child: Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 40),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Consultation Requested!',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Thank you ${_nameController.text.isNotEmpty ? _nameController.text : "valued patient"}.\nOur care coordinator will call you shortly to confirm your appointment.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13.5,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        AppButton(
          label: 'Close Window',
          isOutlined: true,
          showArrow: false,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
