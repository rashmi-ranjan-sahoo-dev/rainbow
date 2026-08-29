import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_helper.dart';
import '../../shared/widgets/eye_animation_loader.dart';
import '../../shared/widgets/floating_whatsapp_button.dart';
import '../../shared/widgets/scroll_aware_header.dart';
import '../../shared/widgets/scroll_reveal.dart';
import '../../shared/widgets/smooth_scroll_wrapper.dart';
import 'widgets/top_utility_bar.dart';
import 'widgets/header/header_widget.dart';
import 'widgets/header/mobile_drawer.dart';
import 'widgets/hero/hero_slider.dart';
import 'widgets/trust_stats/trust_stats_bar.dart';
import 'widgets/about/about_section.dart';
import 'widgets/gallery/gallery_section.dart';
import 'widgets/services/services_section.dart';
import 'widgets/doctors/doctors_section.dart';
import 'widgets/marquee/clinical_features_marquee.dart';
import 'widgets/testimonials/testimonials_section.dart';
import 'widgets/blogs/blogs_section.dart';
import 'widgets/contact/contact_section.dart';

/// Main home screen that assembles all sections top-to-bottom:
/// 1. Eye Animation Splash Loader on initial launch
/// 2. Top Utility Bar (official Visakhapatnam address & phone numbers)
/// 3. Dynamic Header (Floating Card on Hero -> Hidden Downwards -> Attached Sticky on Scroll Up)
/// 4. Hero Slider (infinite carousel with floating micro-animations)
/// 5. Trust Stats Bar (numerical ticker with hover cards)
/// 6. Services & Clinical Specialities Overview
/// 7. Doctors & Medical Specialists
/// 8. Clinical Features Infinite Marquee Ribbon
/// 9. About Us & Why Choose Rainbow Section
/// 8. Doctors & Medical Specialists
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  bool _isLoading = true;
  Timer? _initTimer;

  @override
  void initState() {
    super.initState();

    // Initial eye loader reveal animation running constantly for 5.0 seconds
    _initTimer = Timer(const Duration(milliseconds: 5000), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  void dispose() {
    _initTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final headerHeight = isMobile ? 54.0 : 58.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      endDrawer: const MobileDrawer(),
      body: SmoothScrollWrapper(
        controller: _scrollController,
        child: Stack(
          children: [
            // ── 1. Main Page Content (Fades in after Eye Loader) ──
            AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: _isLoading ? 0.0 : 1.0,
              child: Stack(
                children: [
                  // ── Scrollable Page Content ──
                  CustomScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.normal,
                    ),
                    slivers: [
                      // Top Utility Bar placed inside scroll flow so it scrolls off naturally
                      if (!isMobile)
                        const SliverToBoxAdapter(
                          child: TopUtilityBar(),
                        ),

                      // ── Section 3: Hero Slider (Smooth Fade Up Reveal) ──
                      const SliverToBoxAdapter(
                        child: ScrollReveal(
                          duration: Duration(milliseconds: 900),
                          slideOffset: 0.08,
                          child: HeroSlider(),
                        ),
                      ),

                      // ── Section 4: Trust Stats Bar (Delayed Smooth Fade Up) ──
                      const SliverToBoxAdapter(
                        child: ScrollReveal(
                          duration: Duration(milliseconds: 900),
                          delay: Duration(milliseconds: 120),
                          slideOffset: 0.08,
                          child: TrustStatsBar(),
                        ),
                      ),

                      // ── Section 5: Services & Clinical Specialities Overview ──
                      const SliverToBoxAdapter(
                        child: ServicesSection(),
                      ),

                      // ── Section 6: Doctors & Medical Specialists ──
                      const SliverToBoxAdapter(
                        child: DoctorsSection(),
                      ),

                      // ── Section 7: Clinical Features Infinite Marquee Ribbon ──
                      const SliverToBoxAdapter(
                        child: ClinicalFeaturesMarquee(),
                      ),

                      // ── Section 8: About Us & Why Choose Rainbow Section ──
                      const SliverToBoxAdapter(
                        child: AboutSection(),
                      ),

                      // ── Section 9: Infrastructure & Campus Photo Gallery ──
                      const SliverToBoxAdapter(
                        child: GallerySection(),
                      ),

                      // ── Section 10: Verified Patient Testimonials & Google Reviews ──
                      const SliverToBoxAdapter(
                        child: TestimonialsSection(),
                      ),

                      // ── Section 10: Clinical Knowledge Base & Researched Blogs ──
                      const SliverToBoxAdapter(
                        child: BlogsSection(),
                      ),

                      // ── Section 11: Contact Us & Interactive Map Section ──
                      const SliverToBoxAdapter(
                        child: ContactSection(),
                      ),
                    ],
                  ),

                  // ── 2. Isolated Floating / Sticky Header Overlay ──
                  ScrollAwareHeader(
                    scrollController: _scrollController,
                    headerHeight: headerHeight,
                    builder: (context, state) {
                      return HeaderWidget(headerState: state);
                    },
                  ),

                  // ── 3. Sticky Floating WhatsApp Widget (Bottom-Right) ──
                  const FloatingWhatsAppButton(),
                ],
              ),
            ),

            // ── 4. Eye Animation Initial Loader (Blinks & Scans) ──
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: AppColors.background,
                  child: const EyeAnimationLoader(
                    size: 130,
                    loadingText: 'Calibrating Precision Vision...',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
