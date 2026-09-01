import 'package:flutter/material.dart';

/// Centralized coordinator for silky-smooth section navigation across desktop header,
/// mobile drawer, hero buttons, and footer links.
class SectionNavigator {
  SectionNavigator._();

  static final GlobalKey homeKey = GlobalKey();
  static final GlobalKey heroKey = GlobalKey();
  static final GlobalKey statsKey = GlobalKey();
  static final GlobalKey aboutKey = GlobalKey();
  static final GlobalKey servicesKey = GlobalKey();
  static final GlobalKey doctorsKey = GlobalKey();
  static final GlobalKey testimonialsKey = GlobalKey();
  static final GlobalKey galleryKey = GlobalKey();
  static final GlobalKey blogsKey = GlobalKey();
  static final GlobalKey contactKey = GlobalKey();

  /// Smoothly scrolls to the target section associated with the [GlobalKey].
  static void scrollTo(GlobalKey key, {ScrollController? scrollController}) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeInOutCubic,
        alignment: 0.04, // Position slightly below header
      );
    } else if (scrollController != null && key == heroKey) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  /// Navigates to the home page if not already there, then scrolls to [key].
  static void navigateTo(BuildContext context, GlobalKey key) {
    if (key.currentContext != null) {
      scrollTo(key);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 300), () {
          scrollTo(key);
        });
      });
    }
  }

  /// Smoothly scrolls to the very top of the page.
  static void scrollToTop(ScrollController scrollController) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeInOutCubic,
      );
    }
  }
}
