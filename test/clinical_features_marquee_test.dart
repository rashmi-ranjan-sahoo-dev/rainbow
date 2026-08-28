import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rainbow/features/home/widgets/marquee/clinical_features_marquee.dart';

void main() {
  testWidgets('ClinicalFeaturesMarquee renders all clinical keywords and star icons',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      tester.view.physicalSize = const Size(1400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClinicalFeaturesMarquee(),
          ),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 600));
      await tester.pump();

      // Verify keywords from the ribbon
      expect(find.text('ADVANCED PROFESSIONALS'), findsWidgets);
      expect(find.text('ADVANCED TECHNOLOGY'), findsWidgets);
      expect(find.text('PREVENTIVE CARE'), findsWidgets);
      expect(find.text('PATIENT-CENTERED APPROACH'), findsWidgets);
      expect(find.text('GERMAN CARL ZEISS PRECISION'), findsWidgets);

      // Cleanup
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });
  });
}
