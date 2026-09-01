import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_colors.dart';
import 'features/home/home_screen.dart';
import 'screens/blogs_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/symptom_checker_screen.dart';
import 'screens/terms_and_conditions_screen.dart';

import 'dart:ui';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RainbowApp());
}

class RainbowApp extends StatelessWidget {
  const RainbowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rainbow Eye Hospital',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const SmoothMaterialScrollBehavior(),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/symptom-checker': (context) => const SymptomCheckerScreen(),
        '/blogs': (context) => const BlogsScreen(),
        '/terms': (context) => const TermsAndConditionsScreen(),
        '/terms-and-conditions': (context) => const TermsAndConditionsScreen(),
        '/privacy': (context) => const PrivacyPolicyScreen(),
        '/privacy-policy': (context) => const PrivacyPolicyScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/symptom-checker') {
          return MaterialPageRoute(
            builder: (_) => const SymptomCheckerScreen(),
            settings: settings,
          );
        }
        if (settings.name == '/blogs') {
          return MaterialPageRoute(
            builder: (_) => const BlogsScreen(),
            settings: settings,
          );
        }
        if (settings.name == '/terms' || settings.name == '/terms-and-conditions') {
          return MaterialPageRoute(
            builder: (_) => const TermsAndConditionsScreen(),
            settings: settings,
          );
        }
        if (settings.name == '/privacy' || settings.name == '/privacy-policy') {
          return MaterialPageRoute(
            builder: (_) => const PrivacyPolicyScreen(),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      },
    );
  }
}

/// Custom scroll behavior for fluid momentum-driven scrolling across all input types.
class SmoothMaterialScrollBehavior extends MaterialScrollBehavior {
  const SmoothMaterialScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      decelerationRate: ScrollDecelerationRate.normal,
    );
  }
}
