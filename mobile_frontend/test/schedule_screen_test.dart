import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_frontend/main.dart';

void main() {
  testWidgets('ScheduleTab contains calendar icon and info text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ScheduleTab(),
      ),
    );

    expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    expect(find.textContaining('Trip Schedule will be shown here'), findsOneWidget);
    expect(find.textContaining('Select a date'), findsOneWidget);
  });

  testWidgets('ProviderScheduleTab contains bus icon and provider info text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProviderScheduleTab(),
      ),
    );

    expect(find.byIcon(Icons.directions_bus), findsOneWidget);
    expect(find.textContaining('Manage vehicle'), findsOneWidget);
    expect(find.textContaining('track service usage'), findsOneWidget);
  });
}
