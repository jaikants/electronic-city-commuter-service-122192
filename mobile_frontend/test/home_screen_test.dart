import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_frontend/main.dart';

void main() {
  testWidgets('HomeTab renders welcome text and instructions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeTab(),
      ),
    );

    expect(find.text('Welcome to Electronic City Commuter Service!'), findsOneWidget);
    expect(find.textContaining('Browse schedule'), findsOneWidget);
    expect(find.byIcon(Icons.home_outlined), findsNothing, reason: 'Home icon is in the AppBar, not home body.');
  });
}
