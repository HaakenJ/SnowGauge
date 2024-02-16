import 'package:flutter/material.dart';

class UserAccountPage extends StatelessWidget {
  const UserAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Account'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add our user account  here
            Text(
              'User Account Content',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
