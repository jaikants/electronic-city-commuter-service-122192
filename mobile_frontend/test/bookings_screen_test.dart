import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_frontend/main.dart';

void main() {
  testWidgets('BookingsTab (User) renders booking info', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BookingsTab(),
      ),
    );

    expect(find.byIcon(Icons.event_available), findsOneWidget);
    expect(find.textContaining('active and past bookings'), findsOneWidget);
    expect(find.textContaining('Book or cancel trips'), findsOneWidget);
  });

  testWidgets('ProviderBookingsTab (Provider) renders provider bookings info', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProviderBookingsTab(),
      ),
    );

    expect(find.byIcon(Icons.people_outline), findsOneWidget);
    expect(find.textContaining('your service'), findsOneWidget);
    expect(find.textContaining('Approve/cancel bookings'), findsOneWidget);
  });
}
