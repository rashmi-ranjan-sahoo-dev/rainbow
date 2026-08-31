import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_colors.dart';
import 'features/home/home_screen.dart';
import 'screens/blogs_screen.dart';
import 'screens/symptom_checker_screen.dart';

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
