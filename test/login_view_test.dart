import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/mockito.dart' as Mockito;
import 'package:SnowGauge/auth_service.dart';
import 'package:SnowGauge/views/login_view.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  group('LoginView Widget Test', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    testWidgets('Login button triggers login logic', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: const LoginView(),
        routes: {
          '/leaderboard': (_) => Container(), // Mocking the LeaderboardPage
          '/register': (_) => Container(),   // Mocking the registration page
        },
      ));

      // Fill in the email and password fields
      await tester.enterText(find.byKey(const ValueKey('email')), 'test@example.com');
      await tester.enterText(find.byKey(const ValueKey('password')), 'password');

      // Simulate tapping the login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verify that the login method of the AuthService is called with the correct parameters
      verify(mockAuthService.login('test@example.com', 'password')).called(1);
    });

    testWidgets('Navigation occurs on successful login', (WidgetTester tester) async {
      // Mock successful login response from AuthService
      when(mockAuthService.login(any as dynamic, any as dynamic)).thenAnswer((_) async => true);

      await tester.pumpWidget(MaterialApp(
        home: LoginView(),
        routes: {
          '/leaderboard': (_) => Container(), // Mocking the LeaderboardPage
          '/register': (_) => Container(),   // Mocking the registration page
        },
      ));

      // Simulate tapping the login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify that navigation occurs to the LeaderboardPage
      expect(find.byKey(const ValueKey('leaderboard_page')), findsOneWidget);
    });

    testWidgets('Error message shown on login failure', (WidgetTester tester) async {
      // Mock failed login response from AuthService
      when(mockAuthService.login(any as dynamic, any as dynamic)).thenAnswer((_) async => false);

      await tester.pumpWidget(MaterialApp(
        home: LoginView(),
        routes: {
          '/leaderboard': (_) => Container(), // Mocking the LeaderboardPage
          '/register': (_) => Container(),   // Mocking the registration page
        },
      ));

      // Simulate tapping the login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify that error message is displayed
      expect(find.text('Login failed. Please try again.'), findsOneWidget);
    });
  });
}
