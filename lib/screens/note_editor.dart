import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotlighter1/model/note.dart';

class NoteEditor extends StatefulWidget {
  Note? note;
  static final String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  NoteEditor({
    this.editing = false,
    this.note,
    this.id,
  });
  final bool editing;
  String? id;
  @override
  _TaskEditorState createState() => _TaskEditorState();

  void addNote(String title, String text, bool pinned) {
    note = Note(userID: uid, title: title, text: text, pin: pinned);
    try {
      FirebaseFirestore.instance.collection('notes').add(note!.toMap());
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  void editNote(String title, String text, bool pinned) {
    if (note != null && id != null) {
      note!.title = title;
      note!.text = text;
      note!.pin = pinned;
      try {
        FirebaseFirestore.instance
            .collection('notes')
            .doc(id)
            .update(note!.toMap());
      } on FirebaseException catch (e) {
        print(e.message);
      }
    }
  }
}

class _TaskEditorState extends State<NoteEditor> {
  late TextEditingController _titleControler, _textControler;
  bool _pinned = false;

  @override
  void initState() {
    bool isNote = (widget.note != null);
    _titleControler =
        TextEditingController(text: (isNote) ? widget.note!.title : '');
    _textControler =
        TextEditingController(text: (isNote) ? widget.note!.text : '');
    _pinned = (isNote) ? widget.note!.pin : false;
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
        title: (!widget.editing) ? Text('Add Note') : null,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (widget.editing == true)
            IconButton(
                onPressed: () {
                  print('delete');
                },
                icon: Icon(Icons.delete_rounded)),
          IconButton(
            onPressed: () {
              if (widget.editing) {
                widget.editNote(
                    _titleControler.text, _textControler.text, _pinned);
              } else {
                widget.addNote(
                    _titleControler.text, _textControler.text, _pinned);
              }
              Navigator.pop(context);
            },
            icon: Icon(Icons.done_rounded),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _titleControler,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
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
                maxLines: 12,
                style: TextStyle(
                  fontSize: 18,
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
                  style: TextStyle(fontSize: 20),
                ),
                Switch(
                    value: _pinned,
                    onChanged: (bool value) {
                      setState(() {
                        _pinned = value;
                      });
                      print(_pinned);
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
