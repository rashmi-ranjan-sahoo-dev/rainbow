import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Single sub-symptom question inside a primary symptom category.
class SubSymptomQuestion {
  final String id;
  final String text;
  final int severityPoints;
  bool? isYes; // null: unselected, true: yes, false: no

  SubSymptomQuestion({
    required this.id,
    required this.text,
    this.severityPoints = 1,
    this.isYes,
  });

  SubSymptomQuestion copyWith({bool? isYes}) {
    return SubSymptomQuestion(
      id: id,
      text: text,
      severityPoints: severityPoints,
      isYes: isYes ?? this.isYes,
    );
  }
}

/// Primary symptom category with expandable sub-questions.
class PrimarySymptomGroup {
  final String id;
  final String title;
  final String subtitle;
  final FaIconData icon;
  final String departmentMatch;
  final int baseWeight;
  bool? isYes; // null: unselected, true: yes, false: no
  final List<SubSymptomQuestion> subQuestions;

  PrimarySymptomGroup({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.departmentMatch,
    this.baseWeight = 1,
    this.isYes,
    required this.subQuestions,
  });

  bool get isExpanded => isYes == true;
  bool get isDismissed => isYes == false;

  int get affirmativeSubCount =>
      subQuestions.where((q) => q.isYes == true).length;
}

/// Urgency level classifications.
enum TriageUrgency {
  routine,
  priority,
  emergency,
}

/// Calculated triage assessment result.
class TriageResult {
  final TriageUrgency urgency;
  final String urgencyTitle;
  final String urgencyBadge;
  final String timeFrame;
  final String suspectedCondition;
  final String conditionDescription;
  final String recommendedSpecialist;
  final String departmentBookingName;
  final List<String> clinicalKeyPoints;
  final Color primaryColor;
  final Color badgeBgColor;
  final FaIconData statusIcon;
  final int totalAffirmativeSymptoms;

  const TriageResult({
    required this.urgency,
    required this.urgencyTitle,
    required this.urgencyBadge,
    required this.timeFrame,
    required this.suspectedCondition,
    required this.conditionDescription,
    required this.recommendedSpecialist,
    required this.departmentBookingName,
    required this.clinicalKeyPoints,
    required this.primaryColor,
    required this.badgeBgColor,
    required this.statusIcon,
    required this.totalAffirmativeSymptoms,
  });
}

/// Clinical Triage Evaluation Engine
class TriageEngine {
  TriageEngine._();

  static List<PrimarySymptomGroup> getInitialSymptoms() {
    return [
      PrimarySymptomGroup(
        id: 'cloudy_vision',
        title: 'Cloudy / Blurry Vision',
        subtitle: 'Gradual fading of sharpness, haziness, or halos around bright light sources.',
        icon: FontAwesomeIcons.eyeLowVision,
        departmentMatch: 'Cataract Micro-Surgery',
        baseWeight: 2,
        subQuestions: [
          SubSymptomQuestion(
            id: 'cloudy_sub1',
            text: 'Need significantly brighter lighting or larger print to read comfortably',
            severityPoints: 1,
          ),
          SubSymptomQuestion(
            id: 'cloudy_sub2',
            text: 'Noticed gradual yellowing or fading of color vibrancy over recent months',
            severityPoints: 1,
          ),
          SubSymptomQuestion(
            id: 'cloudy_sub3',
            text: 'Experienced frequent prescription changes or double vision in a single eye',
            severityPoints: 2,
          ),
        ],
      ),
      PrimarySymptomGroup(
        id: 'flashes_floaters',
        title: 'Flashes & Dark Floaters',
        subtitle: 'Sudden streaks of light, drifting spiderwebs, or dark spots moving across vision.',
        icon: FontAwesomeIcons.boltLightning,
        departmentMatch: 'Retina & Diabetic Eye Care',
        baseWeight: 5,
        subQuestions: [
          SubSymptomQuestion(
            id: 'flashes_sub1',
            text: 'Sudden onset or rapid multiplication of dark floating specks or web-like strands',
            severityPoints: 3,
          ),
          SubSymptomQuestion(
            id: 'flashes_sub2',
            text: 'Bright lightning-like flashes or sparks, especially visible in dim/dark rooms',
            severityPoints: 4,
          ),
          SubSymptomQuestion(
            id: 'flashes_sub3',
            text: 'A dark shadow, gray veil, or curtain pulling across side or central vision',
            severityPoints: 6,
          ),
        ],
      ),
      PrimarySymptomGroup(
        id: 'redness_grittiness',
        title: 'Redness, Burning & Grittiness',
        subtitle: 'Foreign body sensation, dry scratchy friction, stinging, or digital screen fatigue.',
        icon: FontAwesomeIcons.fireFlameSimple,
        departmentMatch: 'Comprehensive 20-Point Checkup',
        baseWeight: 1,
        subQuestions: [
          SubSymptomQuestion(
            id: 'redness_sub1',
            text: 'Persistent sandy/gritty sensation that worsens after prolonged screen use or AC',
            severityPoints: 1,
          ),
          SubSymptomQuestion(
            id: 'redness_sub2',
            text: 'Watery eyes alternating with excessive dryness, sensitivity to wind and light',
            severityPoints: 1,
          ),
          SubSymptomQuestion(
            id: 'redness_sub3',
            text: 'Crusty eyelid residue upon waking or sticky discharge accompanied by redness',
            severityPoints: 2,
          ),
        ],
      ),
      PrimarySymptomGroup(
        id: 'eye_ache_headache',
        title: 'Severe Eye Ache & Brow Strain',
        subtitle: 'Deep ocular pain radiating to temples, throbbing headaches, nausea, or halo rings.',
        icon: FontAwesomeIcons.brain,
        departmentMatch: 'Glaucoma Consultation',
        baseWeight: 4,
        subQuestions: [
          SubSymptomQuestion(
            id: 'ache_sub1',
            text: 'Deep aching pressure behind the eyeball radiating into forehead or temple area',
            severityPoints: 3,
          ),
          SubSymptomQuestion(
            id: 'ache_sub2',
            text: 'Seeing rainbow-colored circular halos around light bulbs or car headlights',
            severityPoints: 4,
          ),
          SubSymptomQuestion(
            id: 'ache_sub3',
            text: 'Eye pain is accompanied by sudden vision blurring, nausea, or light sensitivity',
            severityPoints: 5,
          ),
        ],
      ),
    ];
  }

  /// Evaluates affirmative answers and computes urgency tier & clinical pathway.
  static TriageResult evaluate(List<PrimarySymptomGroup> groups) {
    bool hasFlashes = groups.firstWhere((g) => g.id == 'flashes_floaters').isYes == true;
    final flashesGroup = groups.firstWhere((g) => g.id == 'flashes_floaters');
    bool hasCurtainOrSevereFlashes = flashesGroup.subQuestions.any(
      (q) => (q.id == 'flashes_sub3' || q.id == 'flashes_sub2') && q.isYes == true,
    );

    bool hasAche = groups.firstWhere((g) => g.id == 'eye_ache_headache').isYes == true;
    final acheGroup = groups.firstWhere((g) => g.id == 'eye_ache_headache');
    bool hasHalosOrNausea = acheGroup.subQuestions.any(
      (q) => (q.id == 'ache_sub2' || q.id == 'ache_sub3') && q.isYes == true,
    );

    bool hasCloudy = groups.firstWhere((g) => g.id == 'cloudy_vision').isYes == true;
    bool hasRedness = groups.firstWhere((g) => g.id == 'redness_grittiness').isYes == true;

    // Count total affirmative answers
    int totalAffirmative = 0;
    for (final g in groups) {
      if (g.isYes == true) {
        totalAffirmative++;
        totalAffirmative += g.subQuestions.where((q) => q.isYes == true).length;
      }
    }

    // 🔴 1. EMERGENCY ATTENTION MATRIX
    // Flashes + floaters with curtain or sudden lightning flashes
    if (hasFlashes && (hasCurtainOrSevereFlashes || flashesGroup.affirmativeSubCount >= 2)) {
      return TriageResult(
        urgency: TriageUrgency.emergency,
        urgencyTitle: 'Emergency Medical Attention',
        urgencyBadge: 'CRITICAL PRIORITY',
        timeFrame: 'Within 2 to 4 Hours',
        suspectedCondition: 'Suspected Retinal Tear / Detachment',
        conditionDescription:
            'Sudden onset of flashes, shower of floaters, or a peripheral curtain suggests potential vitreous traction or retinal tear requiring immediate fundus inspection.',
        recommendedSpecialist: 'Vitreo-Retina Emergency Specialist',
        departmentBookingName: 'Retina & Diabetic Eye Care',
        clinicalKeyPoints: [
          'Immediate dilated indirect ophthalmoscopy required',
          'Avoid heavy lifting or vigorous head shaking',
          'Same-day laser retinopexy or vitrectomy may prevent vision loss',
        ],
        primaryColor: const Color(0xFFEF4444),
        badgeBgColor: const Color(0xFFFEE2E2),
        statusIcon: FontAwesomeIcons.triangleExclamation,
        totalAffirmativeSymptoms: totalAffirmative,
      );
    }

    // 🟡 2. PRIORITY MATRIX (24-48 Hours)
    // Severe eye pain, glaucoma signs, halos around lights, or combination of cloudy + ache
    if (hasAche || (hasFlashes && !hasCurtainOrSevereFlashes) || (hasCloudy && hasHalosOrNausea)) {
      final isGlaucomaSuspect = hasHalosOrNausea || acheGroup.affirmativeSubCount >= 1;
      return TriageResult(
        urgency: TriageUrgency.priority,
        urgencyTitle: 'Priority Clinical Evaluation',
        urgencyBadge: 'PRIORITY (24–48 HRS)',
        timeFrame: 'Within 24 to 48 Hours',
        suspectedCondition: isGlaucomaSuspect
            ? 'Acute Intraocular Pressure Spike / Glaucoma Risk'
            : 'Persistent Ocular Strain / Deep Corneal Inflammation',
        conditionDescription:
            'Throbbing brow ache paired with visual halos or acute pain warrants urgent tonometry and gonioscopy to measure optic nerve pressure.',
        recommendedSpecialist: 'Glaucoma & Anterior Segment Specialist',
        departmentBookingName: 'Glaucoma Consultation',
        clinicalKeyPoints: [
          'Non-contact and applanation tonometry IOP measurement',
          'Slit-lamp angle assessment and corneal clarity check',
          'Prevent potential irreversible optic disc compression',
        ],
        primaryColor: const Color(0xFFF59E0B),
        badgeBgColor: const Color(0xFFFEF3C7),
        statusIcon: FontAwesomeIcons.clockRotateLeft,
        totalAffirmativeSymptoms: totalAffirmative,
      );
    }

    // 🟢 3. ROUTINE CONSULTATION MATRIX
    // Cloudy vision (Cataract/Refractive) OR Redness & Grittiness (Dry Eye/Allergy)
    if (hasCloudy) {
      return TriageResult(
        urgency: TriageUrgency.routine,
        urgencyTitle: 'Scheduled Clinical Consultation',
        urgencyBadge: 'ROUTINE CONSULTATION',
        timeFrame: 'Within 3 to 7 Days',
        suspectedCondition: 'Age-Related Cataract / Refractive Vision Error',
        conditionDescription:
            'Gradual visual haziness and glare are classical hallmarks of crystalline lens opacification or progressive refractive changes.',
        recommendedSpecialist: 'Cataract & Refractive Surgeon',
        departmentBookingName: 'Cataract Micro-Surgery',
        clinicalKeyPoints: [
          'High-precision optical biometry and anterior chamber depth scanning',
          'Custom premium intraocular lens (IOL) mapping',
          'Painless micro-incision phacoemulsification evaluation',
        ],
        primaryColor: const Color(0xFF0891B2),
        badgeBgColor: const Color(0xFFCFFAFE),
        statusIcon: FontAwesomeIcons.circleCheck,
        totalAffirmativeSymptoms: totalAffirmative,
      );
    }

    if (hasRedness) {
      return TriageResult(
        urgency: TriageUrgency.routine,
        urgencyTitle: 'Scheduled Clinical Consultation',
        urgencyBadge: 'ROUTINE CONSULTATION',
        timeFrame: 'Within 3 to 7 Days',
        suspectedCondition: 'Ocular Surface Disease / Dry Eye Syndrome',
        conditionDescription:
            'Grittiness, burning, and light sensitivity indicate tear film instability, meibomian gland dysfunction, or allergic conjunctivitis.',
        recommendedSpecialist: 'Cornea & Ocular Surface Specialist',
        departmentBookingName: 'Comprehensive 20-Point Checkup',
        clinicalKeyPoints: [
          'Tear Break-Up Time (TBUT) & Schirmer tear quantification',
          'Meibography for lipid layer gland health assessment',
          'Tailored preservative-free lubrication & thermal therapy plan',
        ],
        primaryColor: const Color(0xFF10B981),
        badgeBgColor: const Color(0xFFD1FAE5),
        statusIcon: FontAwesomeIcons.circleCheck,
        totalAffirmativeSymptoms: totalAffirmative,
      );
    }

    // Fallback: General Comprehensive Checkup
    return TriageResult(
      urgency: TriageUrgency.routine,
      urgencyTitle: 'Comprehensive Vision Screening',
      urgencyBadge: 'PREVENTIVE CARE',
      timeFrame: 'Flexible / Next Available Slot',
      suspectedCondition: 'General Preventive Eye Examination',
      conditionDescription:
          'No severe acute danger signs detected. A routine 20-point comprehensive eye evaluation is recommended for baseline eye health maintenance.',
      recommendedSpecialist: 'General Ophthalmology & Refraction Clinic',
      departmentBookingName: 'Comprehensive 20-Point Checkup',
      clinicalKeyPoints: [
        'Complete digital refraction & auto-keratometry',
        'Slit-lamp bio-microscopy & intraocular pressure screening',
        'Dilated peripheral retina health mapping',
      ],
      primaryColor: const Color(0xFF0891B2),
      badgeBgColor: const Color(0xFFCFFAFE),
      statusIcon: FontAwesomeIcons.circleCheck,
      totalAffirmativeSymptoms: totalAffirmative,
    );
  }
}
