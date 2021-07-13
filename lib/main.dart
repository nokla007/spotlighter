import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        theme: themeData,
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

ThemeData themeData = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.indigo,
  primaryColor: Colors.indigo[300],
  accentColor: Colors.indigoAccent,
  primaryColorLight: Color(0xffaab6fe),
  primaryColorDark: Color(0xff49599a),
  scaffoldBackgroundColor: Colors.grey[200],
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //backgroundColor: Color(0xff49599a),
    backgroundColor: Colors.white,
    elevation: 2,
    selectedItemColor: Colors.indigoAccent,
    unselectedItemColor: Colors.grey,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    contentPadding: EdgeInsets.all(10),
    fillColor: Colors.white,
    filled: true,
    focusColor: Colors.indigo[200],
  ),
  visualDensity: VisualDensity.comfortable,
  textTheme: GoogleFonts.notoSansTextTheme(),
  appBarTheme: AppBarTheme(
    textTheme: GoogleFonts.notoSansTextTheme().copyWith(
        // ignore: deprecated_member_use
        title: TextStyle(
      fontSize: 20,
      // fontWeight: FontWeight.w500,
      //color: Colors.white,
    )),
  ),
);
