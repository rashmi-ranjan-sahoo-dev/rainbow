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

  testWidgets('TestimonialsSection renders Google Trust Banner, Category Filter Pills, and Cards',
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

      // Verify Google Trust Ribbon Headline
      expect(find.textContaining('Verified Patient Reviews'), findsOneWidget);
      expect(find.text('Loved by Patients Across Andhra Pradesh'), findsOneWidget);

      // Verify Category Filter Pills
      expect(find.text('All'), findsOneWidget);
      expect(find.text('LASIK & SMILE'), findsOneWidget);
      expect(find.text('Cataract'), findsOneWidget);

      // Verify First Testimonial Card Content
      expect(find.text('Ravi Kumar S.'), findsOneWidget);
      expect(find.textContaining('Contoura Vision Topo-Guided LASIK'), findsOneWidget);

      // Verify Navigation Arrows are present
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
    });
  });
}
