import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_frontend/main.dart';

void main() {
  testWidgets('ProfileTab (User) displays default user info', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileTab(isProvider: false),
      ),
    );

    expect(find.text('User Profile'), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('user@example.com'), findsOneWidget);
    expect(find.text('Subscription Status'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('ProfileTab (Provider) displays provider info', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileTab(isProvider: true),
      ),
    );

    expect(find.text('Transport Provider'), findsOneWidget);
    expect(find.text('Electronic City'), findsOneWidget);
    expect(find.text('Vehicles'), findsOneWidget);
    expect(find.byIcon(Icons.directions_bus), findsOneWidget);
    expect(find.text('Edit Profile'), findsOneWidget);
  });
}
