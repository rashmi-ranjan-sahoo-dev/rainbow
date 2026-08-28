import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rainbow/features/home/widgets/contact/contact_section.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('ContactSection renders contact cards, consultation form, map card, and footer',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ContactSection(),
            ),
          ),
        ),
      );

      VisibilityDetectorController.instance.notifyNow();
      await Future.delayed(const Duration(milliseconds: 600));
      await tester.pump();

      // Verify Section Header
      expect(find.text('GET IN TOUCH & VISIT US'), findsOneWidget);
      expect(find.textContaining('We Are Here For Your Vision Care'), findsOneWidget);

      // Verify Contact Info Cards
      expect(find.text('Hospital Location'), findsOneWidget);
      expect(find.text('Phone & Emergency'), findsOneWidget);
      expect(find.text('Official Email'), findsOneWidget);
      expect(find.text('Working Hours'), findsOneWidget);

      // Verify Consultation Form
      expect(find.text('Send Consultation Enquiry'), findsOneWidget);
      expect(find.text('Submit Enquiry & Request Call Back'), findsOneWidget);

      // Verify Map Card
      expect(find.text('Rainbow Eye Hospital'), findsWidgets);
      expect(find.text('Rainbow Eye Hospital Location'), findsOneWidget);
      expect(find.text('Directions ↗'), findsOneWidget);

      // Verify Footer
      expect(find.textContaining('Rainbow Eye Hospital © 2026 All Right Reserved'), findsOneWidget);
      expect(find.text('Contacts'), findsOneWidget);
      expect(find.text('Contact Lens'), findsWidgets);
    });
  });
}
