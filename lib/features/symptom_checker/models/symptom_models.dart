import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Single 5-Card Symptom Item
class SymptomCardItem {
  final String id;
  final String title;
  final String category;
  final String imageAsset;
  final FaIconData icon;
  bool? isYes; // null = unselected, true = Yes, false = No

  SymptomCardItem({
    required this.id,
    required this.title,
    required this.category,
    required this.imageAsset,
    required this.icon,
    this.isYes,
  });

  String get fullTitle => '$title\n($category)';

  SymptomCardItem copyWith({bool? isYes}) {
    return SymptomCardItem(
      id: id,
      title: title,
      category: category,
      imageAsset: imageAsset,
      icon: icon,
      isYes: isYes ?? this.isYes,
    );
  }
}

/// Urgency / Result Condition Types
enum TriageConditionType {
  allClear, // Condition A: 0 "Yes"
  mildDiscomfort, // Condition B: Exactly 1 "Yes"
  urgentConsult, // Condition C: 2 or More "Yes"
}

/// Evaluated Triage Result
class SimpleTriageResult {
  final TriageConditionType condition;
  final String headline;
  final String message;
  final Color statusColor;
  final Color badgeBgColor;
  final IconData icon;
  final int yesCount;
  final List<String> affirmativeSymptoms;
  final String? ctaLabel;
  final String? ctaUrl;

  const SimpleTriageResult({
    required this.condition,
    required this.headline,
    required this.message,
    required this.statusColor,
    required this.badgeBgColor,
    required this.icon,
    required this.yesCount,
    required this.affirmativeSymptoms,
    this.ctaLabel,
    this.ctaUrl,
  });
}

/// Symptom Checker Evaluation Engine
class SymptomCheckerEngine {
  SymptomCheckerEngine._();

  static const String whatsAppAppointmentUrl =
      'https://wa.me/8341104525?text=Hi%20Sir%2C%20Is%20appointment%20available%20for%20eye%20checkup%3F';

  static List<SymptomCardItem> getInitialSymptoms() {
    return [
      SymptomCardItem(
        id: 'cloudy_vision',
        title: 'Cloudy / Blurry Vision',
        category: 'Cataract & Refraction',
        imageAsset: 'assets/images/symptom_blurry_cataract.jpg',
        icon: FontAwesomeIcons.eyeLowVision,
      ),
      SymptomCardItem(
        id: 'flashes_floaters',
        title: 'Flashes & Dark Floaters',
        category: 'Retina & Vitreous',
        imageAsset: 'assets/images/symptom_flashes_floaters.jpg',
        icon: FontAwesomeIcons.boltLightning,
      ),
      SymptomCardItem(
        id: 'redness_burning',
        title: 'Redness, Burning & Dryness',
        category: 'Ocular Surface & Dry Eye',
        imageAsset: 'assets/images/symptom_dry_redness.jpg',
        icon: FontAwesomeIcons.fireFlameSimple,
      ),
      SymptomCardItem(
        id: 'eye_strain_pain',
        title: 'Severe Eye Strain & Brow Pain',
        category: 'Glaucoma & Asthenopia',
        imageAsset: 'assets/images/symptom_strain_pain.jpg',
        icon: FontAwesomeIcons.brain,
      ),
      SymptomCardItem(
        id: 'sudden_loss_double',
        title: 'Sudden Loss of Vision / Double Vision',
        category: 'Emergency & Neuro-Ophthalmic',
        imageAsset: 'assets/images/blog_blind_spot.jpg',
        icon: FontAwesomeIcons.triangleExclamation,
      ),
    ];
  }

  static SimpleTriageResult evaluate(List<SymptomCardItem> cards) {
    final affirmative = cards.where((c) => c.isYes == true).toList();
    final yesCount = affirmative.length;

    if (yesCount == 0) {
      // Condition A: 0 "Yes" / All "No"
      return const SimpleTriageResult(
        condition: TriageConditionType.allClear,
        headline: 'You are Fine!',
        message:
            'No significant symptoms detected. Give your eyes adequate rest and take regular screen breaks.',
        statusColor: Color(0xFF10B981), // Green
        badgeBgColor: Color(0xFF064E3B),
        icon: Icons.check_circle_rounded,
        yesCount: 0,
        affirmativeSymptoms: [],
      );
    } else if (yesCount == 1) {
      // Condition B: Exactly 1 "Yes" / 4 "No"
      return SimpleTriageResult(
        condition: TriageConditionType.mildDiscomfort,
        headline: 'Mild Eye Discomfort',
        message:
            'Consider using lubricating eye drops and take a proper rest away from digital screens.',
        statusColor: const Color(0xFFF59E0B), // Amber/Yellow
        badgeBgColor: const Color(0xFF78350F),
        icon: Icons.warning_amber_rounded,
        yesCount: 1,
        affirmativeSymptoms: affirmative.map((c) => c.title).toList(),
      );
    } else {
      // Condition C: 2 or More "Yes"
      return SimpleTriageResult(
        condition: TriageConditionType.urgentConsult,
        headline: 'Consultation Recommended',
        message:
            'You have reported multiple eye symptoms. We strongly recommend scheduling an appointment with an eye specialist.',
        statusColor: const Color(0xFFEF4444), // Red
        badgeBgColor: const Color(0xFF7F1D1D),
        icon: Icons.error_outline_rounded,
        yesCount: yesCount,
        affirmativeSymptoms: affirmative.map((c) => c.title).toList(),
        ctaLabel: 'Book Appointment on WhatsApp',
        ctaUrl: whatsAppAppointmentUrl,
      );
    }
  }
}
