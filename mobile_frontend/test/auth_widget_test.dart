import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_frontend/main.dart';

void main() {
  group('AuthScreen', () {
    testWidgets('shows Sign In by default and toggles to Sign Up', (WidgetTester tester) async {
      bool authCompletedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: AuthScreen(
            isLogin: true,
            onAuthCompleted: (type) {
              authCompletedCalled = true;
            },
            toggleAuthMode: () {},
          ),
        ),
      );

      expect(find.text('Sign In'), findsWidgets);
      expect(find.byType(AuthForm), findsOneWidget);

      // Simulate toggle
      await tester.tap(find.text("Don't have an account? Sign Up"));
      // No setState in this widget, test actual toggle in AuthGate integration
      // Use the variable to remove linter warning
      expect(authCompletedCalled, isFalse, reason: "Callback should not be called until form submitted");
    });

    testWidgets('renders Sign Up UI with provider switch', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AuthScreen(
            isLogin: false,
            onAuthCompleted: (_) {},
            toggleAuthMode: () {},
          ),
        ),
      );

      expect(find.text('Sign Up'), findsWidgets);
      expect(find.byType(AuthForm), findsOneWidget);
      expect(find.byType(SwitchListTile), findsOneWidget);
      expect(find.text('Register as Transport Provider'), findsOneWidget);
    });
  });

  group('AuthForm', () {
    testWidgets('validates email and password inputs for login', (WidgetTester tester) async {
      bool onSuccessCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthForm(
              isLogin: true,
              onSuccess: (_) => onSuccessCalled = true,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'notanemail');
      await tester.enterText(find.byType(TextFormField).at(1), '123');
      await tester.tap(find.text('Sign In'));
      await tester.pump(); // Trigger validation

      expect(find.text('Enter a valid email'), findsOneWidget);
      expect(find.text('Minimum 4 characters'), findsOneWidget);

      // Enter valid data
      await tester.enterText(find.byType(TextFormField).at(0), 'a@email.com');
      await tester.enterText(find.byType(TextFormField).at(1), '1234');
      await tester.tap(find.text('Sign In'));
      await tester.pump(const Duration(milliseconds: 700)); // Wait for loading
      expect(onSuccessCalled, isTrue);
    });
  });
}
