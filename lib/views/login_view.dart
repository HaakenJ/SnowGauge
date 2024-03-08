import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _firebaseErrorCode;

  _onSignUp() async {
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

  _onSignIn() {
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
            children: [
              TextField(
                controller: _emailController,
              ),
              TextField(
                controller: _passwordController,
              ),
              ElevatedButton(
                child: const Text('Sign up'),
                onPressed: _onSignUp,
              ),
              ElevatedButton(
                child: const Text('Sign in'),
                onPressed: _onSignIn,
              ),
              if(_firebaseErrorCode != null) Text(_firebaseErrorCode!)
            ]
        ),
      ),
    );
  }
}
