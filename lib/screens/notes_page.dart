import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotlighter1/model/note.dart';
import 'package:spotlighter1/screens/note_editor.dart';
import 'package:spotlighter1/services/firebase_service.dart';

class NotesPage extends StatelessWidget {
  NotesPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: context.read<FirebaseService>().notestream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: Text("Loading"));
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
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}

class NoteGrid extends StatelessWidget {
  NoteGrid({
    required this.note,
    required this.id,
  });
  final String id;
  final Note note;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => NoteEditor(
              id: id,
              note: note,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.grey[200],
        margin: EdgeInsets.all(6),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
