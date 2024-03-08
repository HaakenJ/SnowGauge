
import 'package:SnowGauge/views/recording_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'loading_state_scaffold.dart';
import '../views/login_view.dart';

class SignedInDetector extends StatelessWidget {
  const SignedInDetector({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return const LoginView();
        }
        if(snapshot.connectionState == ConnectionState.active) {
          if(snapshot.data == null) {
            return const LoginView();
          }
          return const RecordActivityView();
        }
        return const LoadingState(child: CircularProgressIndicator());
      },
    );
  }
}
