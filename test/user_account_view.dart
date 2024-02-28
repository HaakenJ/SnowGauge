// The widget is rendered using pumpWidget.
// The app bar title is verified using find.text.
// The user account content is verified using find.text

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SnowGauge/views//user_account_view.dart';

void main() {
  testWidgets('UserAccountView renders correctly', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: UserAccountView()));

    // Verify that the app bar title is 'User Account'
    expect(find.text('User Account'), findsOneWidget);

    // Verify that the user account content is displayed
    expect(find.text('User Account Content'), findsOneWidget);
  });
}
