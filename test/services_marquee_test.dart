import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rainbow/features/home/widgets/services/services_section.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });
  testWidgets('ServicesSection renders category filters, Book Appointment CTA and stepped rows',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      tester.view.physicalSize = const Size(1400, 1000);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ServicesSection(),
            ),
          ),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 1000));
      await tester.pump();

      // Verify Section Eyebrow and Headline
      expect(find.text('SPECIALIZED DEPARTMENTS'), findsOneWidget);
      expect(find.textContaining('Our specialized departments'), findsOneWidget);

      // Verify Category filter pills
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Cataract'), findsWidgets);
      expect(find.text('Laser & LASIK'), findsWidgets);

      // Verify "Book" CTA links
      expect(find.text('Book'), findsWidgets);

      // Test Category Filtering
      await tester.tap(find.text('Cataract').first);
      await Future.delayed(const Duration(milliseconds: 300));
      await tester.pump();
    });
  });
}
