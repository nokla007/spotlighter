import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotlighter1/constants.dart';
import 'package:provider/provider.dart';
import 'package:spotlighter1/providers/auth_mode_provider.dart';
import 'package:spotlighter1/services/firebase_service.dart';

class SignUpPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cpasswordController = TextEditingController();

  SignUpPage({Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Sign Up',
              style: TextStyle(fontSize: 50),
            ),
            const SizedBox(
              height: 2 * kFormFieldSpacing,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(
              height: kFormFieldSpacing,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            const  SizedBox(
              height: kFormFieldSpacing,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: kFormFieldSpacing,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              controller: _cpasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
              ),
              obscureText: true,
            ),
            SizedBox(
              height: 2.5 * kFormFieldSpacing,
              child: Center(
                child: Text(
                  context.watch<AuthModeProvider>().errorText,
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
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              onPressed: () async {
                if (_passwordController.text == _cpasswordController.text) {
                  try {
                    await context.read<FirebaseService>().signUp(
                        email: _emailController.text,
                        password: _passwordController.text,
                        username: _usernameController.text);
                  } on FirebaseAuthException catch (e) {
                    String error =
                        context.read<FirebaseService>().showError(e.code);
                    context.read<AuthModeProvider>().setError(error);
                    print('error');
                  } on FirebaseException catch (e) {
                    String error =
                        context.read<FirebaseService>().showError(e.code);
                    context.read<AuthModeProvider>().setError(error);
                    print('error');
                  }
                } else {
                  context.read<AuthModeProvider>().setError("Password doesn't match");
                }
              },
            ),
            const SizedBox(
              height: kFormFieldSpacing,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                    onPressed: () {
                      context.read<AuthModeProvider>().toggleState();
                    },
                    child: const Text(
                      'Sign In!',
                      style: TextStyle(color: Colors.red),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
