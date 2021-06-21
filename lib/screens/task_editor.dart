import 'package:flutter/material.dart';

class TaskEditor extends StatefulWidget {
  TaskEditor({this.editing = false});
  final bool editing;
  @override
  _TaskEditorState createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
