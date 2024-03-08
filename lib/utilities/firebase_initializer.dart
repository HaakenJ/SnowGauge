import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:SnowGauge/utilities/sign_in_detector.dart';

import '../firebase_options.dart';
import 'loading_state_scaffold.dart';

class FirebaseInitializer extends StatelessWidget {
  const FirebaseInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return const SignedInDetector();
        } else if(snapshot.hasError) {
          return const LoadingState(child: Text('Oh no! You can\'t connect to Firebase.'));
        }
        return const LoadingState(child: CircularProgressIndicator());
      },
    );
  }
}
