import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rainbow/features/home/widgets/blogs/blogs_section.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('BlogsSection renders headline, category filter pills, and research articles',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BlogsSection(),
            ),
          ),
        ),
      );

      VisibilityDetectorController.instance.notifyNow();
      await Future.delayed(const Duration(milliseconds: 600));
      await tester.pump();

      // Verify Section Eyebrow and Headline
      expect(find.textContaining('RAINBOW CLINICAL KNOWLEDGE BASE'), findsOneWidget);
      expect(find.text('Latest Eye Care Insights & Research Guides'), findsOneWidget);

      // Verify Category Filter Pills
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Laser & SMILE'), findsWidgets);
      expect(find.text('Pediatric Care'), findsWidgets);

      // Verify Article titles from research
      expect(find.textContaining('Squint (Strabismus) Treatment'), findsWidgets);
      expect(find.textContaining('Blind Spot of the Eye'), findsWidgets);
      expect(find.textContaining('Digital Eye Strain'), findsWidgets);
    });
  });
}
