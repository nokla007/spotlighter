import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotlighter1/providers/auth_mode_provider.dart';
import 'package:spotlighter1/screens/authentication_screen.dart';
import 'package:spotlighter1/screens/home_screen.dart';
import 'package:spotlighter1/services/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseService>(
          create: (context) => FirebaseService(
              FirebaseAuth.instance, FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthModeProvider(true),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: AuthenticationWraper(),
      ),
    );
  }
}

// class EmptyPage extends StatelessWidget {
//   const EmptyPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text('Project Initialized'),
//       ),
//     );
//   }
// }

class AuthenticationWraper extends StatelessWidget {
  const AuthenticationWraper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: Provider.of<FirebaseService>(context).authState,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          print('logged in');
          return HomeScreen();
        } else {
          print('not logged in');
          return AuthScreen();
        }
      },
    );
  }
}
