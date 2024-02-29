// mock GoRouter using GoRouter.create() to simulate routing.
// build the ScaffoldNavBar widget with a MaterialApp wrapper.
// verify that the bottom navigation bar is displayed.
// verify that all bottom navigation bar items are present.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('ScaffoldNavBar renders correctly', (WidgetTester tester) async {
    // Create an instance of GoRouter
    final goRouter = GoRouter(
      initialLocation: '/',
      routes: const [],
    );

    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp.router(
        routerDelegate: goRouter.routerDelegate,
        routeInformationParser: goRouter.routeInformationParser,
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
            body: child,
          );
        },
        title: 'Test App',
      ),
    );

    // Verify that the bottom navigation bar is displayed
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Verify that the bottom navigation bar items are present
    expect(find.byIcon(Icons.downhill_skiing_outlined), findsOneWidget);
    expect(find.byIcon(Icons.leaderboard_outlined), findsOneWidget);
    expect(find.byIcon(Icons.list_alt_outlined), findsOneWidget);
    expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
  });


}
