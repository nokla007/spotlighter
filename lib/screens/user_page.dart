import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotlighter1/services/firebase_service.dart';

class UserPage extends StatelessWidget {
  UserPage({
    Key? key,
  }) : super(key: key);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _cpassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = context.read<FirebaseService>().getName ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Management'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        try {
                          await context.read<FirebaseService>().signOut();
                          
                        } on FirebaseAuthException catch (e) {
                          print(e.message);
                        }
                      },
                      child: Text('Ok'),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(
              Icons.logout,
              //size: 28,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Change Username',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_nameController.text != '') {
                          try {
                            context
                                .read<FirebaseService>()
                                .updateUserName(_nameController.text);
                            Navigator.pop(context);
                          } on FirebaseAuthException catch (e) {
                            print(e.message);
                            showAlert(context, e.message);
                          }
                        } else {
                          showAlert(context, "Username is empty!");
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Username',
                    //textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_passController.text == _cpassController.text) {
                          try {
                            context
                                .read<FirebaseService>()
                                .updatePassword(_passController.text);
                            Navigator.pop(context);
                          } on FirebaseAuthException catch (e) {
                            print(e.message);
                            showAlert(context, e.message);
                          }
                        } else {
                          showAlert(context, "Password doesn't match!");
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'New Password',
                    //textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Confirm Password',
                    //textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _cpassController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showAlert(BuildContext context, String? error) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        error ?? 'error!',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Ok'),
        ),
      ],
    ),
  );
}
