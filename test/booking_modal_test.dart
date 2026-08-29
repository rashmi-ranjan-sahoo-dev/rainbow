import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rainbow/features/home/widgets/booking/booking_modal.dart';
import 'package:rainbow/shared/widgets/floating_whatsapp_button.dart';

void main() {
  group('BookingModal & FloatingWhatsAppButton Tests', () {
    testWidgets('BookingModal renders all form fields and submit button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BookingModal(),
          ),
        ),
      );

      // Verify Modal Title
      expect(find.text('Book Eye Consultation'), findsOneWidget);

      // Verify Full Name field
      expect(find.text('Full Name *'), findsOneWidget);
      expect(find.text('Enter patient full name'), findsOneWidget);

      // Verify Mobile Number field
      expect(find.text('Mobile Number *'), findsOneWidget);

      // Verify Treatment / Concern field
      expect(find.text('Select Treatment / Concern'), findsOneWidget);

      // Verify Submit Button
      expect(find.text('Confirm Appointment Slot →'), findsOneWidget);
    });

    testWidgets('BookingModal shows validation error when submitted empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BookingModal(),
          ),
        ),
      );

      // Tap submit button without filling fields
      await tester.tap(find.text('Confirm Appointment Slot →'));
      await tester.pump();

      // Expect validation error text
      expect(find.text('Please enter your full name'), findsOneWidget);
    });

    testWidgets('FloatingWhatsAppButton renders properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                FloatingWhatsAppButton(),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(FloatingWhatsAppButton), findsOneWidget);
    });
  });
}
