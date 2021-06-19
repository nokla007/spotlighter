import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotlighter1/constants.dart';
import 'package:spotlighter1/screens/home_screen.dart';
import 'package:spotlighter1/screens/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  static const String id = 'signinScreen';

  SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var _emailController, _passwordController;
  String _email = '', _password = '', _errorText = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _email = _password = _errorText = '';
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sign In',
              style: TextStyle(fontSize: 50),
            ),
            SizedBox(
              height: 2 * kFormFieldSpacing,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              onChanged: (value) {
                _email = value;
              },
            ),
            SizedBox(
              height: kFormFieldSpacing,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              onChanged: (value) {
                _password = value;
              },
            ),
            SizedBox(
              height: 2.5 * kFormFieldSpacing,
              child: Center(
                child: Text(
                  _errorText,
                  //textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            //Elevated Button
            ElevatedButton(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              onPressed: () async {
                print('$_email = $_password');
                _clearTextField();

                try {
                  await _auth.signInWithEmailAndPassword(
                      email: _email, password: _password);
                  Navigator.pushNamed(context, HomeScreen.id);
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    _errorText = e.message.toString();
                  });
                }
              },
            ),
            SizedBox(
              height: kFormFieldSpacing,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignUpScreen.id);
                    },
                    child: Text(
                      'Sign Up!',
                      style: TextStyle(color: Colors.red),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _clearTextField() {
    _emailController.clear();
    _passwordController.clear();
  }
}
