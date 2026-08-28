import 'package:flutter_test/flutter_test.dart';
import 'package:rainbow/main.dart';

void main() {
  testWidgets('RainbowApp renders home screen', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const RainbowApp());
      await Future.delayed(const Duration(milliseconds: 3200));
      await tester.pump();
      // Verify the header logo branding appears
      expect(find.text('RAINB'), findsWidgets);
    });
  });
}
