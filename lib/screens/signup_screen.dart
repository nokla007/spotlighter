import 'package:flutter/material.dart';
import 'package:spotlighter1/constants.dart';
import 'package:spotlighter1/screens/home_screen.dart';
import 'package:spotlighter1/screens/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'signupScreen';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var _emailController,
      _passwordController,
      _cpasswordController,
      _usernameController;
  String _username = '',
      _email = '',
      _password = '',
      _cpassword = '',
      _errorText = '';

  void initState() {
    _email = _password = _cpassword = _username = _errorText = '';
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _cpasswordController = TextEditingController();
    _usernameController = TextEditingController();
    super.initState();
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _cpasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
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
                  onChanged: (value) {
                    _email = value;
                  },
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
                  height: kFormFieldSpacing,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: _cpasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    _cpassword = value;
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
                ElevatedButton(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  onPressed: () {
                    print('$_email = $_password');
                    _clearTextField();
                    if (_password == _cpassword) {
                      Navigator.pushNamed(context, HomeScreen.id);
                    } else {
                      setState(() {
                        _errorText = 'Password doesn\'t match';
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
                    Text('Already have an account?'),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              SignInScreen.id, (route) => false);
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
        ),
      ),
    );
  }

  void _clearTextField() {
    _emailController.clear();
    _passwordController.clear();
    _usernameController.clear();
    _cpasswordController.clear();
  }
}
