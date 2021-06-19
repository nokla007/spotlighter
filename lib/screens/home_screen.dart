import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'homeScreen';
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Home'),
    );
  }
}
