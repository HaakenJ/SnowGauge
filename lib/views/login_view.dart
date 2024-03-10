import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _firebaseErrorCode;

  void _onSignUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      setState(() {
        _firebaseErrorCode = null;
      });
    } on FirebaseAuthException catch (ex) {
      print(ex.code);
      print(ex.message);
      setState(() {
        _firebaseErrorCode = ex.code;
      });
    }
  }

  void _onSignIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigate to the home screen or perform necessary actions upon successful sign-in
    } on FirebaseAuthException catch (ex) {
      print(ex.code);
      print(ex.message);
      setState(() {
        _firebaseErrorCode = ex.code;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _onSignUp,
              child: const Text('Sign up'),
            ),
            ElevatedButton(
              onPressed: _onSignIn,
              child: const Text('Sign in'),
            ),
            if (_firebaseErrorCode != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  _firebaseErrorCode!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


/*
The text input fields have been wrapped with TextFormField for better validation and styling options.
Added prefixIcon to the text input fields for a better visual representation.
Encapsulated UI elements within Padding and SizedBox widgets for better spacing and alignment.
Displayed error messages in red color if authentication fails.
Improved UI layout with CrossAxisAlignment.stretch for better utilization of screen space.
 */



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../auth_service.dart';
//
// class LoginView extends StatefulWidget {
//   const LoginView({super.key});
//
//   @override
//   _LoginViewState createState() => _LoginViewState();
// }
//
// class _LoginViewState extends State<LoginView> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   String? _firebaseErrorCode;
//
//   _onSignUp() async {
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );
//       setState(() {
//         _firebaseErrorCode = null;
//       });
//     } on FirebaseAuthException catch (ex) {
//       print(ex.code);
//       print(ex.message);
//       setState(() {
//         _firebaseErrorCode = ex.code;
//       });
//     }
//   }
//
//   _onSignIn() {
//     FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: _emailController.text,
//       password: _passwordController.text,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//         child: Column(
//             children: [
//               TextField(
//                 controller: _emailController,
//               ),
//               TextField(
//                 controller: _passwordController,
//               ),
//               ElevatedButton(
//                 child: const Text('Sign up'),
//                 onPressed: _onSignUp,
//               ),
//               ElevatedButton(
//                 child: const Text('Sign in'),
//                 onPressed: _onSignIn,
//               ),
//               if(_firebaseErrorCode != null) Text(_firebaseErrorCode!)
//             ]
//         ),
//       ),
//     );
//   }
// }
