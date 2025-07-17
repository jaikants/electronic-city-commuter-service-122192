import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_frontend/main.dart';

void main() {
  testWidgets('SubscriptionsTab (User): shows subscription management info', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SubscriptionsTab(),
      ),
    );

    expect(find.byIcon(Icons.subscriptions_outlined), findsOneWidget);
    expect(find.textContaining('Manage monthly subscriptions'), findsOneWidget);
    expect(find.textContaining('Subscribe, renew, or cancel'), findsOneWidget);
  });

  testWidgets('ProviderSubscriptionsTab: shows provider subscription management info', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProviderSubscriptionsTab(),
      ),
    );

    expect(find.byIcon(Icons.assignment_turned_in_outlined), findsOneWidget);
    expect(find.textContaining('manage pricing and plans'), findsOneWidget);
    expect(find.textContaining('Overview of your service'), findsOneWidget);
  });
}
