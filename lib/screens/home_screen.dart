import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotlighter1/screens/signin_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'homeScreen';
  HomeScreen({Key? key}) : super(key: key);

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('home sweat home'),
            ElevatedButton(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              onPressed: () async {
                try {
                  await _auth.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      SignInScreen.id, (route) => false);
                } on FirebaseAuthException catch (e) {
                  print(e.message);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
