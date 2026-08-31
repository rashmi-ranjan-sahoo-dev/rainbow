import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_colors.dart';

enum GalleryCategory {
  all(
    title: 'All Photos',
    icon: FontAwesomeIcons.images,
    color: AppColors.primary,
  ),
  surgical(
    title: 'Surgical & OT',
    icon: FontAwesomeIcons.microscope,
    color: Color(0xFF0284C7),
  ),
  diagnostics(
    title: 'Diagnostics',
    icon: FontAwesomeIcons.eye,
    color: Color(0xFF0D9488),
  ),
  recovery(
    title: 'Patient Recovery',
    icon: FontAwesomeIcons.bedPulse,
    color: Color(0xFF8B5CF6),
  ),
  campus(
    title: 'Campus & Lounge',
    icon: FontAwesomeIcons.hospital,
    color: Color(0xFFD97706),
  ),
  optical(
    title: 'Optical & Pharmacy',
    icon: FontAwesomeIcons.glasses,
    color: Color(0xFFEC4899),
  ),
  medicalCamps(
    title: 'Free Eye Camps',
    icon: FontAwesomeIcons.handHoldingHeart,
    color: Color(0xFF059669),
  );

  final String title;
  final FaIconData icon;
  final Color color;

  const GalleryCategory({
    required this.title,
    required this.icon,
    required this.color,
  });
}

class HospitalPhotoItem {
  final String id;
  final String title;
  final String subtitle;
  final GalleryCategory category;
  final String imageAsset;
  final String tag;
  final String description;
  final double aspectRatio;

  const HospitalPhotoItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.imageAsset,
    required this.tag,
    required this.description,
    this.aspectRatio = 1.33,
  });
}

class HospitalGalleryData {
  HospitalGalleryData._();

  static const List<HospitalPhotoItem> items = [
    // 1. Surgical OT 1
    HospitalPhotoItem(
      id: 'ot_suite_1',
      title: 'Modular Eye Operation Theatre',
      subtitle: 'Carl Zeiss Surgical Microscope & Motorized Surgical Bed',
      category: GalleryCategory.surgical,
      imageAsset: 'assets/images/gallery/ot_suite_1.jpg',
      tag: 'Zeiss OT Suite',
      description:
          'NABH-accredited laminar airflow sterile OT suite designed for micro-incision cataract, retina interventions, and stitch-less laser surgeries.',
      aspectRatio: 0.75, // Vertical
    ),

    // 2. OT Suite Wide
    HospitalPhotoItem(
      id: 'ot_suite_wide',
      title: 'Advanced Surgical & Anaesthesia Suite',
      subtitle: 'Sterile OT with Multi-Parameter Life-Guard Station',
      category: GalleryCategory.surgical,
      imageAsset: 'assets/images/gallery/ot_suite_wide.jpg',
      tag: 'Sterile OT',
      description:
          'Fully equipped surgical bay with continuous biometric vital monitoring, HEPA air filtration, and emergency backup systems.',
      aspectRatio: 1.77, // Landscape wide
    ),

    // 3. Diagnostics Optovue OCT
    HospitalPhotoItem(
      id: 'diagnostic_suite',
      title: 'Optovue High-Resolution Retina OCT Suite',
      subtitle: 'Non-Invasive Cross-Sectional Retinal & Macular Imaging',
      category: GalleryCategory.diagnostics,
      imageAsset: 'assets/images/gallery/diagnostic_suite.jpg',
      tag: 'Optovue OCT',
      description:
          'Sub-micron optical coherence tomography for early detection of glaucoma, diabetic retinopathy, and macular degeneration.',
      aspectRatio: 1.33,
    ),

    // 4. Consultation Chamber
    HospitalPhotoItem(
      id: 'consultation_chamber',
      title: 'Senior Consultant Examination Chamber',
      subtitle: 'Integrated High-Definition Slit Lamp Diagnostic Station',
      category: GalleryCategory.diagnostics,
      imageAsset: 'assets/images/gallery/consultation_chamber.jpg',
      tag: 'Consultation',
      description:
          'Private doctor consultation room with ergonomic motorized slit-lamp station for comprehensive anterior and posterior segment examination.',
      aspectRatio: 1.33,
    ),

    // 5. Vision Testing
    HospitalPhotoItem(
      id: 'vision_testing_room',
      title: 'Digital Vision Testing & Refraction Suite',
      subtitle: 'Automated Digital Snellen Chart & Precision Trial Lenses',
      category: GalleryCategory.diagnostics,
      imageAsset: 'assets/images/gallery/vision_testing_room.jpg',
      tag: 'Refraction Room',
      description:
          'Acoustically calibrated refraction room for pinpoint prescription measurement, astigmatism analysis, and contrast sensitivity evaluation.',
      aspectRatio: 0.75, // Vertical
    ),

    // 6. Day-Care Recovery Ward
    HospitalPhotoItem(
      id: 'recovery_ward_1',
      title: 'Day-Care Post-Operative Recovery Ward',
      subtitle: 'Hygienic Hospital Beds with Individual IV Care',
      category: GalleryCategory.recovery,
      imageAsset: 'assets/images/gallery/recovery_ward_1.jpg',
      tag: 'Recovery Ward',
      description:
          'Air-conditioned recovery cubicles with sanitized bedding, dedicated curtains for privacy, and nurse call stations.',
      aspectRatio: 1.33,
    ),

    // 7. Recovery Ward Wide
    HospitalPhotoItem(
      id: 'recovery_ward_wide',
      title: 'Spacious Patient Observation Bay',
      subtitle: 'Comfortable Monitored Day-Care Facility',
      category: GalleryCategory.recovery,
      imageAsset: 'assets/images/gallery/recovery_ward_wide.jpg',
      tag: 'Observation Bay',
      description:
          'Continuous post-surgical nursing care area where patients rest comfortably under specialist supervision before same-day discharge.',
      aspectRatio: 1.77, // Landscape wide
    ),

    // 8. Hospital Exterior Night
    HospitalPhotoItem(
      id: 'hospital_exterior_night',
      title: 'Rainbow Eye Hospital Campus',
      subtitle: 'Night View of Main Facility & Optical Plaza',
      category: GalleryCategory.campus,
      imageAsset: 'assets/images/gallery/hospital_exterior_night.jpg',
      tag: 'Main Campus',
      description:
          'Multi-storey eye care hospital & optical plaza located at NGGOs Colony, Akkayyapalem, Visakhapatnam with dedicated parking.',
      aspectRatio: 0.75, // Vertical
    ),

    // 9. Central Reception
    HospitalPhotoItem(
      id: 'central_reception',
      title: 'Central Reception & Help Desk',
      subtitle: 'Warm Welcome & Quick Patient Check-In',
      category: GalleryCategory.campus,
      imageAsset: 'assets/images/gallery/central_reception.jpg',
      tag: 'Reception',
      description:
          'Modern front desk with digital token registration, cashless insurance assistance, digital payments, and patient support officers.',
      aspectRatio: 1.33,
    ),

    // 10. Main Waiting Hall
    HospitalPhotoItem(
      id: 'main_waiting_hall',
      title: 'Main Patient Waiting Hall',
      subtitle: 'Spacious Seating with Digital Token Calling',
      category: GalleryCategory.campus,
      imageAsset: 'assets/images/gallery/main_waiting_hall.jpg',
      tag: 'Waiting Hall',
      description:
          'Well-lit and ventilated waiting lounge with comfortable steel seating rows, patient counseling chambers, and magazine stands.',
      aspectRatio: 1.33,
    ),

    // 11. Waiting Corridor 1
    HospitalPhotoItem(
      id: 'waiting_corridor_1',
      title: 'Specialist OPD Waiting Corridor',
      subtitle: 'Air-Conditioned Hallway & Health Awareness Displays',
      category: GalleryCategory.campus,
      imageAsset: 'assets/images/gallery/waiting_corridor_1.jpg',
      tag: 'OPD Lounge',
      description:
          'Clean clinical corridor connecting doctor chambers with informative eye health literature and insurance empanelment displays.',
      aspectRatio: 1.33,
    ),

    // 12. Waiting Corridor 2
    HospitalPhotoItem(
      id: 'waiting_corridor_2',
      title: 'Doctor Chambers & Consultation Corridor',
      subtitle: 'Streamlined Access to Speciality Eye Clinics',
      category: GalleryCategory.campus,
      imageAsset: 'assets/images/gallery/waiting_corridor_2.jpg',
      tag: 'Speciality Wing',
      description:
          'Dedicated wing housing doctor consultation chambers, patient counseling, and refraction stations for smooth patient flow.',
      aspectRatio: 1.77,
    ),

    // 13. Optical Plaza
    HospitalPhotoItem(
      id: 'optical_plaza',
      title: 'Rainbow Optical Plaza',
      subtitle: 'Designer Frames, Blue-Cut & Progressive Lenses',
      category: GalleryCategory.optical,
      imageAsset: 'assets/images/gallery/optical_plaza.jpg',
      tag: 'Optical Plaza',
      description:
          'Premium eyewear studio featuring Ray-Ban, BLUMAX, NOVA, IRUS, digital eye-strain protection, and precision lens dispensing.',
      aspectRatio: 1.33,
    ),

    // 14. Pharmacy Helpdesk
    HospitalPhotoItem(
      id: 'pharmacy_helpdesk',
      title: 'Rainbow Medicals & 24/7 Pharmacy',
      subtitle: 'Authentic Ophthalmic Medications & Consumables',
      category: GalleryCategory.optical,
      imageAsset: 'assets/images/gallery/pharmacy_helpdesk.jpg',
      tag: 'Pharmacy',
      description:
          'In-house licensed pharmacy providing temperature-controlled eye drops, post-op care kits, and emergency ophthalmic medications.',
      aspectRatio: 1.33,
    ),

    // 15. Glaucoma Poster
    HospitalPhotoItem(
      id: 'glaucoma_awareness_poster',
      title: 'Clinical Glaucoma Awareness Guide',
      subtitle: 'Silent Vision Loss Prevention & Pressure Screening',
      category: GalleryCategory.optical,
      imageAsset: 'assets/images/gallery/glaucoma_awareness_poster.jpg',
      tag: 'Patient Education',
      description:
          'Educational visual guides helping patients identify early symptoms like eye pain, halos, morning headaches, and peripheral vision loss.',
      aspectRatio: 1.77,
    ),

    // 16. Cataract Banner
    HospitalPhotoItem(
      id: 'cataract_care_banner',
      title: 'Senior Citizen Cataract Care Program',
      subtitle: 'Advanced Sutureless Micro-Incision Cataract Surgery',
      category: GalleryCategory.optical,
      imageAsset: 'assets/images/gallery/cataract_care_banner.jpg',
      tag: 'Cataract Care',
      description:
          'Community awareness program for elderly patients offering painless 10-minute laser procedures and premium intraocular lenses.',
      aspectRatio: 1.77,
    ),

    // 17. Free Eye Screening Camp
    HospitalPhotoItem(
      id: 'medical_camp_vision_screening',
      title: 'Free Eye Screening & Diagnosis Camp',
      subtitle: 'Rural Vision Health Outreach & Slit-Lamp Examinations',
      category: GalleryCategory.medicalCamps,
      imageAsset: 'assets/images/gallery/medical_camp_1.jpg',
      tag: 'Free Eye Camp',
      description:
          'Community eye health screening camp offering free cataract detection, refractive error examination, intraocular pressure checks, and specialist consultations.',
      aspectRatio: 1.33,
    ),

    // 18. Community Spectacles Distribution
    HospitalPhotoItem(
      id: 'medical_camp_glasses_distribution',
      title: 'Community Spectacles & Cataract Outreach',
      subtitle: 'Free Vision Testing & Glasses Distribution',
      category: GalleryCategory.medicalCamps,
      imageAsset: 'assets/images/gallery/medical_camp_2.jpg',
      tag: 'Outreach Camp',
      description:
          'Charitable eye screening program providing free vision aids, reading glasses, and surgical referrals for underprivileged rural patients across Andhra Pradesh.',
      aspectRatio: 1.33,
    ),
  ];
}
