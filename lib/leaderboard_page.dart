import 'package:flutter/material.dart';
import 'history_page.dart';
import 'user_account_page.dart';
import 'record_activity_page.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        actions: [
          // Adding a menu button
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Opening a menu with options
              _showMenu(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add our leaderboard content
            Text(
              'Leaderboard Content',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the record activity page when the + button is pressed
          Navigator.pushNamed(context, '/record_activity');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Function to show the menu
  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.history),
                title: Text('View History'),
                onTap: () {
                  // Navigate to the history page
                  Navigator.pushNamed(context, '/history');
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('User Account'),
                onTap: () {
                  // Navigate to the user account page
                  Navigator.pushNamed(context, '/user_account');
                },
              ),
              // Add more menu options if we want to
            ],
          ),
        );
      },
    );
  }
}
