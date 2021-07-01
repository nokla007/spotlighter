import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotlighter1/constants.dart';
import 'package:spotlighter1/screens/note_editor.dart';
import 'package:spotlighter1/screens/notes_page.dart';
import 'package:spotlighter1/screens/task_editor.dart';
import 'package:spotlighter1/screens/tasks_page.dart';
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
    setState(() {
      _selectedIndex = i;
    });
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
            onPressed: () {
              print('search');
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      drawer: NavDrawer(
        index: _selectedIndex,
        toggleIndex: toggleIndex,
      ),
      body: getPage(_selectedIndex),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          backgroundColor: Colors.grey[100],
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Spotlighter',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              kDivider,
              ListTile(
                tileColor: (index == 0) ? Colors.black26 : null,
                title: const Text(
                  'Notes',
                  style: TextStyle(fontSize: 24),
                ),
                leading: const Icon(Icons.note_alt_outlined),
                onTap: () {
                  Navigator.pop(context);
                  toggleIndex(0);
                },
              ),
              ListTile(
                tileColor: (index == 1) ? Colors.black26 : null,
                title: const Text(
                  'Tasks',
                  style: TextStyle(fontSize: 24),
                ),
                leading: const Icon(Icons.task_outlined),
                onTap: () {
                  print('1');
                  Navigator.pop(context);
                  toggleIndex(1);
                },
              ),
              kDivider,
              Expanded(child: Container()),
              kDivider,
              ListTile(
                title: Text(
                  'User',
                  style: TextStyle(fontSize: 24),
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
