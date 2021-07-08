import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotlighter1/model/note.dart';
import 'package:provider/provider.dart';
import 'package:spotlighter1/services/firebase_service.dart';

class NoteEditor extends StatefulWidget {
  static final String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  NoteEditor({
    this.note,
    this.id,
  });
  final Note? note;
  final String? id;
  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late TextEditingController _titleControler, _textControler;
  bool _pinned = false;
  bool _editing = false;

  @override
  void initState() {
    _editing = (widget.note != null);
    _pinned = (_editing) ? widget.note!.pin : false;
    _titleControler =
        TextEditingController(text: (_editing) ? widget.note!.title : '');
    _textControler =
        TextEditingController(text: (_editing) ? widget.note!.text : '');
    super.initState();
  }

  @override
  void dispose() {
    _titleControler.dispose();
    _textControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (!_editing) ? Text('Add Note') : null,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (_editing)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete Note?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          if (_editing) {
                            try {
                              context
                                  .read<FirebaseService>()
                                  .deleteNote(widget.id);
                              Navigator.pop(context);
                            } on FirebaseAuthException catch (e) {
                              print(e.message);
                            }
                          }
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.delete_rounded),
            ),
          IconButton(
            onPressed: () async {
              if (_editing) {
                Note note = widget.note!;
                note.update(_titleControler.text.trim(), _textControler.text.trim(), _pinned);
                try {
                  context.read<FirebaseService>().editNote(note, widget.id);
                } on FirebaseException catch (e) {
                  print(e.message);
                }
              } else {
                Note newNote = Note(
                  userID: context.read<FirebaseService>().getUID,
                  title: _titleControler.text.trim(),
                  text: _textControler.text.trim(),
                  pin: _pinned,
                );
                try {
                  context.read<FirebaseService>().createNote(newNote);
                } on FirebaseException catch (e) {
                  print(e.message);
                }
              }
              Navigator.pop(context);
            },
            icon: Icon(Icons.done_rounded),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _titleControler,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 50,
                  style: TextStyle(
                    //fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _textControler,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 12,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Description',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Pin',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 60,
                    child: Switch(
                      value: _pinned,
                      onChanged: (bool value) {
                        setState(() {
                          _pinned = value;
                        });
                        print(_pinned);
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
