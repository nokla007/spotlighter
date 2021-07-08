import 'package:flutter/material.dart';
import 'package:spotlighter1/model/note.dart';
import 'package:spotlighter1/screens/note_editor.dart';

class NoteGrid extends StatelessWidget {
  NoteGrid({
    required this.note,
    required this.id,
  });
  final String id;
  final Note note;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(6),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
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
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (note.title != '')
                Text(
                  note.title,
                  // style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                  maxLines: 2,
                ),
              SizedBox(height: 6),
              Flexible(
                child: Text(
                  note.text,
                  // style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  style: Theme.of(context).textTheme.bodyText2,
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

class NoteList {
  List<NoteGrid> _allNotes;

  NoteList(this._allNotes);

  List<NoteGrid> showNotes(bool pinned) {
    List<NoteGrid> list = [];
    for (NoteGrid grid in _allNotes) {
      if (grid.note.pin == pinned) {
        list.add(grid);
      }
    }
    return list;
  }
}
