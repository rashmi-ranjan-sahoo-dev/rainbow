import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/responsive_helper.dart';
import '../features/home/widgets/blogs/blogs_section.dart';
import '../features/home/widgets/booking/booking_modal.dart';
import '../shared/widgets/floating_whatsapp_button.dart';
import '../shared/widgets/rainbow_logo.dart';

/// Standalone Full-Page Clinical Knowledge Base & Researched Blogs (`/blogs`).
class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  static const List<BlogArticle> _allArticles = [
    BlogArticle(
      id: 'blog_1',
      title: 'At What Age Should Squint (Strabismus) Treatment Be Done?',
      summary:
          'Early intervention is critical. Learn why pediatric ophthalmologists recommend squint correction before age 7 to preserve 3D stereoscopic vision.',
      fullContent:
          'Squint (Strabismus) is a condition where both eyes do not align simultaneously. Pediatric ophthalmologists at Rainbow Eye Hospital emphasize that treatment should begin as early as possible — ideally between 6 months and 7 years of age.\n\nLeaving squint untreated during early neural development can cause the brain to ignore input from the misaligned eye, leading to Amblyopia (lazy eye) and permanent loss of binocular 3D vision. Modern squint correction incorporates custom optical lenses, prism therapy, patching protocols, and microscopic muscle re-alignment surgery with rapid next-day discharge.',
      category: 'Pediatric Care',
      author: 'Dr. Priya Sharma',
      authorRole: 'Pediatric Strabismus Specialist',
      publishedDate: 'Aug 24, 2026',
      readTime: '4 min read',
      hospitalBadge: 'Rainbow Pediatric Clinic',
      imageAsset: 'assets/images/blog_squint_pediatric.jpg',
      doctorAsset: 'assets/images/doctor_priya_sharma.jpg',
      categoryColor: Color(0xFF8B5CF6),
      iconData: Icons.child_care_rounded,
      keyTakeaways: [
        'Critical window for best visual outcomes is before age 7.',
        'Early patching & prism therapy can avoid surgical intervention.',
        'Micro-muscle surgery offers 98%+ precision alignment.',
      ],
    ),
    BlogArticle(
      id: 'blog_2',
      title: 'What is the Blind Spot of the Eye & How Does Vision Compensate?',
      summary:
          'Explore the optic disc where nerve fibers exit without photoreceptors, and how the visual cortex seamlessly interpolates missing sight details.',
      fullContent:
          'The physiological blind spot (scotoma) is an anatomical feature present in every human eye. It corresponds to the optic disc — the exact point where 1.2 million optic nerve fibers exit the retina to transmit visual signals to the brain.\n\nBecause this area contains no light-detecting rod or cone photoreceptor cells, no image is formed here. However, our visual cortex utilizes binocular overlapping fields and predictive perceptual interpolation to seamlessly fill in the gap. Regular dilated retinal evaluations ensure this natural blind spot is distinguished from pathological scotomas caused by glaucoma or retinal detachment.',
      category: 'Cataract & Retina',
      author: 'Dr. Ananya Iyer',
      authorRole: 'Vitreo-Retinal Surgeon',
      publishedDate: 'Aug 21, 2026',
      readTime: '5 min read',
      hospitalBadge: 'Rainbow Retina Centre',
      imageAsset: 'assets/images/blog_blind_spot.jpg',
      doctorAsset: 'assets/images/doctor_ananya_iyer.jpg',
      categoryColor: Color(0xFFE11D48),
      iconData: Icons.remove_red_eye_outlined,
      keyTakeaways: [
        'Natural optic disc lacks rod and cone photoreceptors.',
        'Brain fills the gap using bilateral field overlap.',
        'Distinguishing natural blind spots from retinal pathology is vital.',
      ],
    ),
    BlogArticle(
      id: 'blog_3',
      title: 'How to Avoid Digital Eye Strain in 10+ Hour Screen Work',
      summary:
          'Evidence-based ergonomics: The 20-20-20 rule, contrast optimization, artificial tear protocols, and how blue light management relieves asthenopia.',
      fullContent:
          'With IT professionals and students spending over 10 hours daily on digital displays, Computer Vision Syndrome (CVS) has become widespread. Display viewing reduces natural blink rate from 16–20 blinks/min to under 6 blinks/min, causing rapid tear film evaporation and corneal surface dryness.\n\nRainbow Eye Hospital’s refractive specialists recommend:\n1. The 20-20-20 Rule: Every 20 minutes, gaze at an object 20 feet away for 20 seconds.\n2. Preservative-free lubricating eye drops.\n3. Display positioned 20–28 inches away at a 15-degree downward angle.\n4. Matte anti-glare filters to eliminate harsh overhead reflections.',
      category: 'Digital Eye Health',
      author: 'Dr. Suresh Nair',
      authorRole: 'Cornea & Refractive Specialist',
      publishedDate: 'Aug 18, 2026',
      readTime: '6 min read',
      hospitalBadge: 'Rainbow Dry Eye Clinic',
      imageAsset: 'assets/images/blog_digital_eyestrain.jpg',
      doctorAsset: 'assets/images/doctor_suresh_nair.jpg',
      categoryColor: Color(0xFF0D9488),
      iconData: Icons.laptop_chromebook_rounded,
      keyTakeaways: [
        'Screen usage cuts natural blink frequency by over 65%.',
        '20-20-20 rule dynamically restores ciliary muscle focus.',
        'Preservative-free tears maintain stable tear film osmolarity.',
      ],
    ),
    BlogArticle(
      id: 'blog_4',
      title: 'Contoura Vision vs SMILE Pro Laser: Which is Right for You?',
      summary:
          'A comprehensive comparative analysis of 22,000 elevation points topography-guided LASIK vs lenticule extraction for high myopia.',
      fullContent:
          'Choosing between Contoura Vision and SMILE Pro is one of the most common decisions for candidates seeking permanent spectacle freedom.\n\n• Contoura Vision maps 22,000 elevation points on your cornea, smoothing microscopic irregularities for super-human visual acuity (often 6/5 or better).\n• SMILE Pro uses a 2mm micro-tunnel without creating a corneal flap, making it the premier choice for athletes, military personnel, and patients with active physical lifestyles.\n\nOur AIIMS-trained refractive team conducts a thorough 18-parameter corneal tomography (Pentacam HR) to determine your ideal customized laser procedure.',
      category: 'Laser & SMILE',
      author: 'Dr. Rajesh Varma',
      authorRole: 'Chief Refractive & LASIK Specialist',
      publishedDate: 'Aug 15, 2026',
      readTime: '7 min read',
      hospitalBadge: 'Rainbow Laser Centre',
      imageAsset: 'assets/images/blog_smile_lasik.jpg',
      doctorAsset: 'assets/images/doctor_rajesh_varma.jpg',
      categoryColor: Color(0xFF0284C7),
      iconData: Icons.auto_fix_high_rounded,
      keyTakeaways: [
        'Contoura Vision delivers 22,000-point personalized topography.',
        'SMILE Pro is 100% flapless with a 2mm micro-incision.',
        'Corneal thickness & biomechanics dictate procedure suitability.',
      ],
    ),
    BlogArticle(
      id: 'blog_5',
      title: 'Micro-Incision Cataract Surgery (MICS): Same-Day Recovery Guide',
      summary:
          'Everything you need to know about 1.8mm cold phacoemulsification, multifocal toric IOLs, and returning to daily routine in 24 hours.',
      fullContent:
          'Modern cataract surgery has transformed from a hospitalization procedure into a painless 10-minute micro-incision procedure. Using 1.8mm sub-2mm incisions and ultrasonic cold phacoemulsification, the cloudy natural lens is dissolved and replaced with a premium foldable Intraocular Lens (IOL).\n\nWith multifocal and extended depth of focus (EDOF) IOLs, patients achieve clear vision at distance, intermediate (computer), and near (reading) without spectacles.',
      category: 'Cataract & Retina',
      author: 'Dr. Ananya Iyer',
      authorRole: 'Senior Cataract & IOL Surgeon',
      publishedDate: 'Aug 10, 2026',
      readTime: '5 min read',
      hospitalBadge: 'Rainbow Cataract Centre',
      imageAsset: 'assets/images/blog_cataract_senior.jpg',
      doctorAsset: 'assets/images/doctor_ananya_iyer.jpg',
      categoryColor: Color(0xFFE11D48),
      iconData: Icons.visibility_rounded,
      keyTakeaways: [
        '1.8mm micro-incision requires no stitches or bandages.',
        'Premium Trifocal & EDOF IOLs eliminate reading glasses.',
        'Normal screen & walking activities resume next morning.',
      ],
    ),
    BlogArticle(
      id: 'blog_6',
      title: 'Silent Vision Thief: Why Early Glaucoma Screening Saves Sight',
      summary:
          'Glaucoma progresses without pain or noticeable vision changes until severe optic nerve damage occurs. Learn why annual tonometry is essential.',
      fullContent:
          'Glaucoma is often called the "silent thief of sight" because peripheral vision loss occurs so gradually that patients rarely notice until significant irreversible optic nerve fibers have been compromised.\n\nRoutine eye exams at Rainbow Eye Hospital include non-contact tonometry, gonioscopy, central corneal pachymetry, and optical coherence tomography (OCT RNFL) to catch pressure spikes and nerve thinning years before visual field defects manifest.',
      category: 'Cataract & Retina',
      author: 'Dr. Suresh Nair',
      authorRole: 'Glaucoma & Anterior Segment Specialist',
      publishedDate: 'Aug 05, 2026',
      readTime: '5 min read',
      hospitalBadge: 'Rainbow Glaucoma Clinic',
      imageAsset: 'assets/images/service_glaucoma.jpg',
      doctorAsset: 'assets/images/doctor_suresh_nair.jpg',
      categoryColor: Color(0xFFD97706),
      iconData: Icons.shield_outlined,
      keyTakeaways: [
        'Damage to the optic nerve from pressure is permanent.',
        'OCT imaging detects nerve fiber loss 5+ years before symptoms.',
        'Targeted SLT laser therapy and drops effectively control IOP.',
      ],
    ),
  ];

  void _openArticleModal(BlogArticle article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BlogArticleReaderModal(article: article),
    );
  }

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
                _buildHeroHeader(isMobile, isTablet),

                SizedBox(height: isMobile ? 24 : 36),

                // ── 2. Articles Responsive Grid ──
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.horizontalPadding(context),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1320),
                    child: _buildArticlesGrid(screenWidth, isMobile, isTablet),
                  ),
                ),

                const SizedBox(height: 48),

                // ── 3. Consultation CTA Banner ──
                _buildBottomBanner(context, isMobile),

                const SizedBox(height: 48),
              ],
            ),
          ),

          // ── 5. Sticky Floating WhatsApp Button ──
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
            iconSize: isMobile ? 26 : 30,
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          const SizedBox(width: 10),
          Container(
            height: 18,
            width: 1.5,
            color: const Color(0xFFE2E8F0),
          ),
          const SizedBox(width: 10),
          Text(
            'Clinical Knowledge Base',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      actions: [
        if (!isMobile)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () => showBookingDialog(context),
              icon: const FaIcon(FontAwesomeIcons.calendarCheck, size: 13, color: Colors.white),
              label: const Text('Book Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeroHeader(bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: isMobile ? 36 : 56,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF22D3EE).withValues(alpha: 0.4),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(FontAwesomeIcons.bookOpenReader, size: 12, color: Color(0xFF22D3EE)),
                    SizedBox(width: 8),
                    Text(
                      'AIIMS-TRAINED SURGICAL INSIGHTS',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: Color(0xFF22D3EE),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Evidence-Based Eye Care & Clinical Research',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 24 : 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.25,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Explore clinical insights, preventative guidelines, surgical innovations, and patient recovery advice curated directly by our senior ophthalmology faculty.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 13 : 15,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF94A3B8),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticlesGrid(double screenWidth, bool isMobile, bool isTablet) {
    final articles = _allArticles;
    final int crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = (constraints.maxWidth - ((crossAxisCount - 1) * 20)) / crossAxisCount;

        return Wrap(
          spacing: 20,
          runSpacing: 24,
          children: articles.map((article) {
            return SizedBox(
              width: itemWidth,
              child: _BlogCard(
                article: article,
                onTap: () => _openArticleModal(article),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildBottomBanner(BuildContext context, bool isMobile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(isMobile ? 24 : 36),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Need Personalized Eye Diagnostics?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 20 : 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Consult our AIIMS-trained ophthalmology team for custom vision evaluations and advanced surgery consultations.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 12.5 : 14,
              color: const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => showBookingDialog(context),
            icon: const FaIcon(FontAwesomeIcons.calendarCheck, size: 14, color: Colors.white),
            label: const Text('Book Eye Consultation Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class _BlogCard extends StatefulWidget {
  final BlogArticle article;
  final VoidCallback onTap;

  const _BlogCard({
    required this.article,
    required this.onTap,
  });

  @override
  State<_BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<_BlogCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.article;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : const Color(0xFFE2E8F0),
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Header
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        a.imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFF0F172A),
                          child: const Center(
                            child: Icon(Icons.broken_image_rounded, color: Colors.white54),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: a.categoryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            a.category,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            a.readTime,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        a.summary,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: const Color(0xFF64748B),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 12),

                      // Author Footer
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: AssetImage(a.doctorAsset),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  a.author,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  a.authorRole,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10.5,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Full Reader Modal for Blog Articles
class _BlogArticleReaderModal extends StatelessWidget {
  final BlogArticle article;

  const _BlogArticleReaderModal({required this.article});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.90),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Modal Top Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: article.categoryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    article.category,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: article.categoryColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 18 : 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage(article.doctorAsset),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.author,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            '${article.authorRole} • ${article.publishedDate} • ${article.readTime}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      article.imageAsset,
                      width: double.infinity,
                      height: isMobile ? 200 : 320,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Key Takeaways Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.lightbulb_rounded, color: Color(0xFFD97706), size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Key Clinical Takeaways',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...article.keyTakeaways.map(
                          (t) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 14),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    t,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12.5,
                                      color: Color(0xFF334155),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Full Content
                  Text(
                    article.fullContent,
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      color: const Color(0xFF334155),
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        showBookingDialog(context, initialTreatment: article.category);
                      },
                      icon: const FaIcon(FontAwesomeIcons.calendarCheck, size: 14, color: Colors.white),
                      label: const Text('Book Consultation with Doctor'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
