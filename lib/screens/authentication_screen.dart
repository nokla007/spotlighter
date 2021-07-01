import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotlighter1/providers/auth_mode_provider.dart';
import 'package:spotlighter1/screens/signin_screen.dart';
import 'package:spotlighter1/screens/signup_screen.dart';

class AuthScreen extends StatefulWidget {
  static const String id = 'signinScreen';

  AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  Widget showPage(bool hasAccount) {
    if (hasAccount)
      return SignInPage();
    else
      return SignUpPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20),
      child: showPage(context.watch<AuthModeProvider>().hasAccount),
    ));
  }
}

