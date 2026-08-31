import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rainbow/features/home/widgets/testimonials/testimonials_section.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('TestimonialsSection renders Eyebrow, Main Title, Category Filter Pills, and Cards on Desktop',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TestimonialsSection(),
            ),
          ),
        ),
      );

      VisibilityDetectorController.instance.notifyNow();
      await Future.delayed(const Duration(milliseconds: 600));
      await tester.pump();

      // Verify Eyebrow & Headline
      expect(find.text('PATIENT STORIES & EXPERIENCES'), findsOneWidget);
      expect(find.text('Loved by Patients Across Andhra Pradesh'), findsOneWidget);

      // Verify Category Filter Pills
      expect(find.text('All'), findsOneWidget);
      expect(find.text('LASIK & SMILE'), findsWidgets);
      expect(find.text('Cataract'), findsWidgets);

      // Verify First Testimonial Card Content (Name, Stars, Feedback)
      expect(find.text('Ravi Kumar S.'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsWidgets);
      expect(find.textContaining('Dr. Rajesh Varma'), findsWidgets);

      // Verify Navigation Arrows are present
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
    });
  });

  testWidgets('TestimonialsSection renders correctly on Mobile (375px) without assertion error or cutoffs',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TestimonialsSection(),
            ),
          ),
        ),
      );

      VisibilityDetectorController.instance.notifyNow();
      await Future.delayed(const Duration(milliseconds: 600));
      await tester.pump();

      // Verify Eyebrow & Headline on mobile
      expect(find.text('PATIENT STORIES & EXPERIENCES'), findsOneWidget);
      expect(find.text('Loved by Patients Across Andhra Pradesh'), findsOneWidget);

      // Verify Card rendered with Name & Stars
      expect(find.text('Ravi Kumar S.'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsWidgets);

      // Verify tapping filter category works cleanly
      await tester.tap(find.text('Cataract'));
      await tester.pumpAndSettle();

      expect(find.text('Lakshmi Prasanna'), findsOneWidget);
    });
  });
}
