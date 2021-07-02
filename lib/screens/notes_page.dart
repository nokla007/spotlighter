import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotlighter1/constants.dart';
import 'package:spotlighter1/model/note.dart';
import 'package:spotlighter1/services/firebase_service.dart';
import 'package:spotlighter1/widgets/note_grid.dart';

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

        List<NoteGrid> notes = snapshot.data!.docs.map(
          (DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return NoteGrid(
              note: Note.fromMap(data),
              id: doc.id,
            );
          },
        ).toList();
        NoteList noteList = NoteList(notes);

        List<NoteGrid> pinnedNotes = noteList.showNotes(true);
        List<NoteGrid> otherNotes = noteList.showNotes(false);

        return Padding(
          padding: EdgeInsets.all(4),
          child: (notes.isEmpty)
              ? Center(
                  child: Text('No notes yet!'),
                )
              : CustomScrollView(
                  slivers: [
                    kSliverText((pinnedNotes.isNotEmpty) ? 'Pinned' : ''),
                    SliverGrid.count(
                      crossAxisCount: 2,
                      children: pinnedNotes,
                    ),
                    kSliverText((pinnedNotes.isNotEmpty) ? 'Others' : ''),
                    SliverGrid.count(
                      crossAxisCount: 2,
                      children: otherNotes,
                    ),
                  ],
                ),
        );
      },
    );
  }
}
