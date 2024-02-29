// The widget is rendered.
// Text is entered into the text fields.
// The registration service is mocked to simulate a successful registration.
// The register button is tapped.
// The registration service is verified to be called with the correct parameters.
// Navigation to the leaderboard page is verified.


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:SnowGauge/views/registration_view.dart';
import 'package:SnowGauge/services/registration_service.dart';
// Define a mock widget to represent LeaderboardPage
class MockLeaderboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MockRegistrationService extends Mock implements RegistrationService {}

void main() {
  group('RegistrationView Widget Test', () {
    late MockRegistrationService mockRegistrationService;

    setUp(() {
      mockRegistrationService = MockRegistrationService();
    });

    testWidgets('Register button calls registration service on tap', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(MaterialApp(home: RegistrationView()));

      // Find widgets
      final nameTextField = find.widgetWithText(TextField, 'Name');
      final emailTextField = find.widgetWithText(TextField, 'Email');
      final passwordTextField = find.widgetWithText(TextField, 'Password');
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');

      // Enter text into text fields
      await tester.enterText(nameTextField, 'John Doe');
      await tester.enterText(emailTextField, 'john@example.com');
      await tester.enterText(passwordTextField, 'password');

      // Mock registration service response
      when(mockRegistrationService.register(any as dynamic, any as dynamic, any as dynamic)).thenAnswer((_) async => true);

      // Tap the register button
      await tester.tap(registerButton);
      await tester.pump();

      // Verify that registration service is called with correct parameters
      verify(mockRegistrationService.register('John Doe', 'john@example.com', 'password')).called(1);

      // Verify navigation on successful registration
      expect(find.byType(MockLeaderboardPage), findsOneWidget);
    });
  });
}
