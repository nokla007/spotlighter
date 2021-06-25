import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotlighter1/constants.dart';


class SignUpPage extends StatelessWidget {
  final Function onError;
  final Function togglePage;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cpasswordController = TextEditingController();
  final auth;
  final errorText;

  SignUpPage(
      {Key? key,
      required this.auth,
      required this.onError,
      required this.togglePage,
      required this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sign Up',
              style: TextStyle(fontSize: 50),
            ),
            SizedBox(
              height: 2 * kFormFieldSpacing,
            ),
            TextFormField(
              textAlign: TextAlign.center,
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(
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
            ),
            SizedBox(
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
                  errorText,
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
                  'Sign Up',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              onPressed: () async {
                if (_passwordController.text == _cpasswordController.text) {
                  try {
                    await auth
                        .createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text)
                        .then((value) async {
                      await FirebaseFirestore.instance
                          .collection('userData')
                          .doc(value.user!.uid)
                          .set({'userName': _usernameController.text});
                    }).catchError((e) {
                      onError(e.message);
                    });
                    //Navigator.pushNamed(context, DummyPage.id);
                  } on FirebaseAuthException catch (e) {
                    onError(e.message);
                  } on FirebaseException catch (e) {
                    onError(e.message);
                  }
                } else {
                  onError("Password doesn't match");
                }
              },
            ),
            SizedBox(
              height: kFormFieldSpacing,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'),
                TextButton(
                    onPressed: () {
                      togglePage();
                    },
                    child: Text(
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
