import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotlighter1/constants.dart';
import 'package:spotlighter1/screens/signin_screen.dart';
import 'package:spotlighter1/screens/signup_screen.dart';

class AuthScreen extends StatefulWidget {
  static const String id = 'signinScreen';

  AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String _errorText = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  int hasAccount = 1;

  void showerror(String e) {
    print(e);
    setState(() {
      _errorText = e;
    });
  }

  void toggleMode() {
    print('toggled!');
    setState(() {
      if (hasAccount == 0)
        hasAccount = 1;
      else
        hasAccount = 0;
    });
  }

  Widget showPage(int hasAccount) {
    if (hasAccount == 1)
      return SignInPage(
          auth: _auth,
          onError: showerror,
          togglePage: toggleMode,
          errorText: _errorText);
    else if (hasAccount == 0)
      return SignUpPage(
          auth: _auth,
          onError: showerror,
          togglePage: toggleMode,
          errorText: _errorText);
    else
      return Text('Something went wrong');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20),
      child: showPage(hasAccount),
    ));
  }
}

