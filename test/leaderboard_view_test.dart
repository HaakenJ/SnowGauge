//
// In the first test, we ensure that the LeaderboardView renders correctly by checking for the app bar title, menu button, and floating action button.
// In the second test, we simulate tapping the menu button and verify that the menu options appear in the modal bottom sheet.
// In the third test, we simulate tapping the "View History" option and verify that the app navigates to the history page correctly.




import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:SnowGauge/views/history_view.dart';
import 'package:SnowGauge/views/user_account_view.dart';
import 'package:SnowGauge/views/recording_view.dart';
import 'package:SnowGauge/views/leaderboard_view.dart';

// Mock NavigatorObserver class
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('LeaderboardView Widget Test', () {
    late MockNavigatorObserver mockNavigatorObserver;

    setUp(() {
      mockNavigatorObserver = MockNavigatorObserver();
    });

    testWidgets('LeaderboardView renders correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: const LeaderboardView(),
        routes: {
          '/record_activity': (_) => RecordActivityView(),
          '/history': (_) => HistoryView(),
          '/user_account': (_) => UserAccountView(),
        },
        navigatorObservers: [mockNavigatorObserver],
      ));

      // Verify that the app bar title is 'Leaderboard'
      expect(find.text('Leaderboard'), findsOneWidget);

      // Verify that the menu button is present
      expect(find.byIcon(Icons.menu), findsOneWidget);

      // Verify that the floating action button is present
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('LeaderboardView opens menu correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: LeaderboardView(),
        routes: {
          '/record_activity': (_) => RecordActivityView(),
          '/history': (_) => HistoryView(),
          '/user_account': (_) => UserAccountView(),
        },
        navigatorObservers: [mockNavigatorObserver],
      ));

      // Tap the menu button
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Verify that the history option is present in the bottom sheet
      expect(find.text('View History'), findsOneWidget);

      // Verify that the user account option is present in the bottom sheet
      expect(find.text('User Account'), findsOneWidget);
    });

    testWidgets('LeaderboardView navigates to history page correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: LeaderboardView(),
        routes: {
          '/record_activity': (_) => RecordActivityView(),
          '/history': (_) => HistoryView(),
          '/user_account': (_) => UserAccountView(),
        },
        navigatorObservers: [mockNavigatorObserver],
      ));

      // Tap the menu button
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Tap the 'View History' option in the bottom sheet
      await tester.tap(find.text('View History'));
      await tester.pumpAndSettle();

      // Verify that the app navigated to the history page
      verify(mockNavigatorObserver.didPush(any as dynamic, any)).called(1);

      expect(find.byType(HistoryView), findsOneWidget);
    });
    testWidgets('LeaderboardView navigates to user account page correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: LeaderboardView(),
        routes: {
          '/record_activity': (_) => RecordActivityView(),
          '/history': (_) => HistoryView(),
          '/user_account': (_) => UserAccountView(),
        },
        navigatorObservers: [mockNavigatorObserver],
      ));

      // Tap the menu button
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Tap the 'User Account' option in the bottom sheet
      await tester.tap(find.text('User Account'));
      await tester.pumpAndSettle();

      // Verify that the app navigated to the user account page
      verify(mockNavigatorObserver.didPush(any as dynamic, any)).called(1);

      expect(find.byType(UserAccountView), findsOneWidget);
    });



  });
}
