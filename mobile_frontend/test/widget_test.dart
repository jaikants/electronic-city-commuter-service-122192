import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_frontend/main.dart';

void main() {
  testWidgets('ECCS App initializes and shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ECCSApp());

    expect(find.text('Sign In'), findsWidgets);
    expect(find.byIcon(Icons.email_outlined), findsOneWidget);
  });

  testWidgets('Toggle between login and signup modes', (WidgetTester tester) async {
    await tester.pumpWidget(const ECCSApp());

    expect(find.text('Sign In'), findsOneWidget);

    // Tap the "Don't have an account? Sign Up" button
    await tester.tap(find.text("Don't have an account? Sign Up"));
    await tester.pumpAndSettle();

    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });
}
