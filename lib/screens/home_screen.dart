import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spotlighter1/constants.dart';
import 'package:spotlighter1/screens/note_editor.dart';
import 'package:spotlighter1/screens/notes_page.dart';
import 'package:spotlighter1/screens/task_editor.dart';
import 'package:spotlighter1/screens/tasks_page.dart';
import 'package:spotlighter1/screens/user_page.dart';
import 'package:spotlighter1/services/firebase_service.dart';

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

  void toggleIndex(int i) {
    if (_selectedIndex != i) {
      setState(() {
        _selectedIndex = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
        ),
        actions: [
          // TODO: Implement Search Functionality.
          IconButton(
            onPressed: () {
              print('search');
            },
            icon: Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      drawer: NavDrawer(
        index: _selectedIndex,
        toggleIndex: toggleIndex,
      ),
      body: getPage(_selectedIndex),
      bottomNavigationBar: BottomAppBar(
        elevation: 2,
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
          //selectedItemColor: Colors.black87,
          //unselectedItemColor: Colors.black45,
          onTap: (index) {
            if (index != _selectedIndex) {
              setState(() {
                _selectedIndex = index;
              });
            }
          },
        ),
      ),
      floatingActionButton: Fab(index: _selectedIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class NavDrawer extends StatelessWidget {
  final int index;
  final Function toggleIndex;

  const NavDrawer({Key? key, required this.index, required this.toggleIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 9,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Spotlighter',
                      style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      // style: GoogleFonts.montserrat(
                      //   fontSize: 40,
                      //   color: Theme.of(context).primaryColorDark,
                      // ),
                    ),
                  ),
                ),
              ),
              kDivider,
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor:
                    (index == 0) ? Theme.of(context).primaryColorLight : null,
                title: const Text(
                  'Notes',
                  style: TextStyle(fontSize: 18),
                ),
                leading: const Icon(Icons.note_alt_outlined),
                onTap: () {
                  Navigator.pop(context);
                  toggleIndex(0);
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor:
                    (index == 1) ? Theme.of(context).primaryColorLight : null,
                title: const Text(
                  'Tasks',
                  style: TextStyle(fontSize: 18),
                ),
                leading: const Icon(Icons.task_outlined),
                onTap: () {
                  //print('1');
                  Navigator.pop(context);
                  toggleIndex(1);
                },
              ),
              kDivider,
              Expanded(child: Container()),
              kDivider,
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => UserPage(),
                    ),
                  );
                },
                title: Text(
                  context.read<FirebaseService>().getName ?? 'User',
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  context.read<FirebaseService>().getEmail ?? 'Not Signed In',
                ),
                leading: const Icon(
                  Icons.person_outline,
                  size: 34,
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Sign out?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
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
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => NoteEditor(),
            ),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => TaskEditor(),
            ),
          );
        }
      },
    );
  }
}
