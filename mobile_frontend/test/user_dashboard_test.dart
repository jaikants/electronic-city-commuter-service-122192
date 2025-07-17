import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_frontend/main.dart';

void main() {
  testWidgets('UserDashboard shows HomeTab by default and switches tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: UserDashboard(onLogout: () {}),
      ),
    );

    // Should show Home by default
    expect(find.text('Home'), findsOneWidget);
    expect(find.textContaining('Welcome to Electronic City Commuter Service!'), findsOneWidget);

    // Tap Schedule tab
    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();
    expect(find.text('Schedule'), findsWidgets);
    expect(find.byIcon(Icons.calendar_today), findsOneWidget);

    // Tap Bookings tab
    await tester.tap(find.text('Bookings'));
    await tester.pumpAndSettle();
    expect(find.text('Bookings'), findsWidgets);
    expect(find.byIcon(Icons.event_available), findsOneWidget);

    // Tap Subscriptions tab
    await tester.tap(find.text('Subscriptions'));
    await tester.pumpAndSettle();
    expect(find.text('Subscriptions'), findsOneWidget);
    expect(find.byIcon(Icons.subscriptions_outlined), findsWidgets);

    // Tap Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsWidgets);
    expect(find.text('User Profile'), findsOneWidget);
  });
}
