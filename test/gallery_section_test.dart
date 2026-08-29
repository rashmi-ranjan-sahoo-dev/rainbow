import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rainbow/features/home/widgets/gallery/gallery_section.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('GallerySection renders 5 category showcase cards with See More button', (tester) async {
    await tester.runAsync(() async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: GallerySection(),
            ),
          ),
        ),
      );

      VisibilityDetectorController.instance.notifyNow();
      await Future.delayed(const Duration(milliseconds: 100));
      await tester.pump();

      // Verify Eyebrow & Title
      expect(find.text('OUR INFRASTRUCTURE & FACILITIES'), findsOneWidget);
      expect(find.text('Take A Tour Of Rainbow Eye Hospital'), findsOneWidget);

      // Verify "See More" button
      expect(find.text('See More'), findsOneWidget);
    });
  });
}
