import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotlighter1/screens/note_editor.dart';
import 'package:spotlighter1/screens/notes_page.dart';
import 'package:spotlighter1/screens/tasks_page.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'homeScreen';
  HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    'Notes',
    'Tasks',
  ];

  Widget getPage(int index) {
    if (index == 0)
      return NotesPage();
    else if (index == 1)
      return TasksPage();
    else
      return Text('Something went wrong');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     SignInScreen.id, (route) => false);
              } on FirebaseAuthException catch (e) {
                print(e.message);
              }
            },
            icon: Icon(Icons.logout_rounded),
          )
        ],
      ),
      // body: _page[_selectedIndex],
      body: getPage(_selectedIndex),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.note_alt_outlined,
              ),
              label: 'Notes',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.task_alt_outlined), label: 'Tasks'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.black45,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      floatingActionButton: Fab(index: _selectedIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class Fab extends StatelessWidget {
  const Fab({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        print('add pressed');
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => NoteEditor(),
            ),
          );
        }
      },
    );
  }
}
