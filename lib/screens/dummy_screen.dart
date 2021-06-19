import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spotlighter1/screens/signin_screen.dart';

class DummyPage extends StatefulWidget {
  static const id = 'dummypage';

  const DummyPage({Key? key}) : super(key: key);

  @override
  _DummyPageState createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance.collection('dummy');
  TextEditingController _controller = TextEditingController();
  String _txt = '';
  var _uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: StreamBuilder(
                  stream:
                      _db.where('uid', isEqualTo: _uid.toString()).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        child: Text('no data'),
                      );
                    }
                    List<Text> _textWidgets = [];
                    var _messages = snapshot.data.docs;
                    for (var _message in _messages) {
                      final _textWidget = Text(_message.get('text').toString());
                      _textWidgets.add(_textWidget);
                    }
                    return ListView(
                      children: _textWidgets,
                    );
                  },
                ),
              ),
            ),
            TextField(
              controller: _controller,
              onChanged: (value) {
                _txt = value;
              },
            ),
            ElevatedButton(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Send',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              onPressed: () async {
                _controller.clear();
                try {
                  _db.add({'text': _txt, 'uid': _uid});
                } on FirebaseAuthException catch (e) {
                  print(e.message);
                }
              },
            ),
            ElevatedButton(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Sign Out',
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
