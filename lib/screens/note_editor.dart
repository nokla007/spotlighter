import 'package:flutter/material.dart';

class NoteEditor extends StatefulWidget {
  NoteEditor({this.editing = false});
  final bool editing;
  @override
  _TaskEditorState createState() => _TaskEditorState();
}

class _TaskEditorState extends State<NoteEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}
