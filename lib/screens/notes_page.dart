import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotlighter1/model/note.dart';
import 'package:spotlighter1/screens/note_editor.dart';

class NotesPage extends StatelessWidget {
  NotesPage({Key? key})
      : _uid = FirebaseAuth.instance.currentUser!.uid.toString(),
        super(key: key);
  final _db = FirebaseFirestore.instance.collection('notes');
  String _uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.where('userID', isEqualTo: _uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Something went wrong');
        if (snapshot.connectionState == ConnectionState.waiting)
          return Text("Loading");
        if (!snapshot.hasData)
          return Center(
            child: Text('No data'),
          );
        return Padding(
          padding: EdgeInsets.all(4),
          child: GridView.count(
            crossAxisCount: 2,
            children: snapshot.data!.docs.map(
              (DocumentSnapshot doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return NoteGrid(
                    note: Note.fromMap(data),
                    id: doc.id,
                    onTapFunction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => NoteEditor(
                            editing: true,
                            id: doc.id,
                            note: Note.fromMap(data),
                          ),
                        ),
                      );
                    });
              },
            ).toList(),
          ),
        );
      },
    );
  }
}

class NoteGrid extends StatelessWidget {
  NoteGrid({required this.note, required this.id, required this.onTapFunction});
  final String id;
  final Note note;
  VoidCallback onTapFunction;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapFunction,
      child: Card(
        color: Colors.grey[200],
        margin: EdgeInsets.all(6),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (note.title != '')
                Text(
                  note.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  maxLines: 2,
                ),
              Flexible(
                child: Text(
                  note.text,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
