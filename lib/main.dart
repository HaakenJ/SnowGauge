import 'package:flutter/material.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'leaderboard_page.dart';
import 'history_page.dart';
import 'user_account_page.dart';
import 'record_activity_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snow Gauge App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Redirect to LoginPage initially
      home: const LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/leaderboard': (context) => LeaderboardPage(),
        '/history': (context) => HistoryPage(),
        '/user_account': (context) => const UserAccountPage(),
        '/record_activity': (context) => RecordActivityPage(),
      },
    );
  }
}
