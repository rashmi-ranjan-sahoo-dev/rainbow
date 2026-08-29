import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rainbow/screens/blogs_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('BlogsScreen renders top navigation, hero banner, category filters, and articles',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: BlogsScreen(),
        ),
      );

      VisibilityDetectorController.instance.notifyNow();
      await Future.delayed(const Duration(milliseconds: 100));
      await tester.pump();

      // Verify AppBar
      expect(find.text('Clinical Knowledge Base'), findsOneWidget);

      // Verify Hero Banner
      expect(find.text('AIIMS-TRAINED SURGICAL INSIGHTS'), findsOneWidget);
      expect(find.text('Evidence-Based Eye Care & Clinical Research'), findsOneWidget);

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
