import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotlighter1/model/note.dart';
import 'package:spotlighter1/services/firebase_service.dart';
import 'package:spotlighter1/widgets/note_grid.dart';
import 'package:spotlighter1/widgets/sliver_text.dart';

class NotesPage extends StatelessWidget {
  NotesPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool landscapeMode =
        MediaQuery.of(context).orientation == Orientation.landscape;
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

        List<NoteGrid> pinnedNotes = [];
        List<NoteGrid> otherNotes = [];
        final docs = snapshot.data!.docs;
        for (var doc in docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          final Note _note = Note.fromMap(data);
          final String _id = doc.id;
          if (_note.pin) {
            pinnedNotes.add(NoteGrid(note: _note, id: _id));
          } else {
            otherNotes.add(NoteGrid(note: _note, id: _id));
          }
        }

        // List<NoteGrid> notes = snapshot.data!.docs.map(
        //   (DocumentSnapshot doc) {
        //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        //     return NoteGrid(
        //       note: Note.fromMap(data),
        //       id: doc.id,
        //     );
        //   },
        // ).toList();

        final int crossAxixCount = (landscapeMode) ? 3 : 2;

        return Padding(
          padding: EdgeInsets.all(4),
          child: (pinnedNotes.isEmpty && otherNotes.isEmpty)
              ? Center(
                  child: Text('No notes yet!'),
                )
              : CustomScrollView(
                  slivers: [
                    SliverText((pinnedNotes.isNotEmpty) ? 'Pinned' : ''),
                    SliverGrid.count(
                      crossAxisCount: crossAxixCount,
                      children: pinnedNotes,
                    ),
                    SliverText((pinnedNotes.isNotEmpty) ? 'Others' : ''),
                    SliverGrid.count(
                      crossAxisCount: crossAxixCount,
                      children: otherNotes,
                    ),
                  ],
                ),
        );
      },
    );
  }
}
