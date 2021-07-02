import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotlighter1/constants.dart';
import 'package:spotlighter1/providers/auth_mode_provider.dart';
import 'package:spotlighter1/services/firebase_service.dart';

class SignInPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Sign In',
              style: TextStyle(fontSize: 50),
            ),
            const SizedBox(
              height: 2 * kFormFieldSpacing,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(
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
                  'Sign In',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              onPressed: () async {
                try {
                  await context.read<FirebaseService>().signIn(
                      email: _emailController.text,
                      password: _passwordController.text);
                  context.read<AuthModeProvider>().clearError();
                } on FirebaseAuthException catch (e) {
                  //onError(e.message);
                  String error =
                      context.read<FirebaseService>().showError(e.code);
                  context.read<AuthModeProvider>().setError(error);
                  print('error');
                }
              },
            ),
            const SizedBox(
              height: kFormFieldSpacing,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?'),
                TextButton(
                    onPressed: () {
                      context.read<AuthModeProvider>().toggleState();
                    },
                    child: const Text(
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
}
