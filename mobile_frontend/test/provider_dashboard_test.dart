import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_frontend/main.dart';

void main() {
  testWidgets('ProviderDashboard shows ProviderHomeTab by default and switches tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProviderDashboard(onLogout: () {}),
      ),
    );

    // Should show Provider Dashboard by default
    expect(find.textContaining('Provider Dashboard'), findsOneWidget);

    // Tap Schedule tab
    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();
    expect(find.text('Schedule'), findsWidgets);
    expect(find.byIcon(Icons.directions_bus), findsOneWidget);

    // Tap Bookings tab
    await tester.tap(find.text('Bookings'));
    await tester.pumpAndSettle();
    expect(find.text('Bookings'), findsWidgets);
    expect(find.byIcon(Icons.people_outline), findsWidgets);

    // Tap My Service tab (label changes for provider)
    await tester.tap(find.text('My Service'));
    await tester.pumpAndSettle();
    expect(find.text('My Service'), findsWidgets);
    expect(find.text('Overview of your service subscriptions.'), findsOneWidget);

    // Tap Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Provider Profile'), findsWidgets);
    expect(find.byIcon(Icons.directions_bus), findsOneWidget);
  });
}
