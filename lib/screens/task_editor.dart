import 'package:flutter/material.dart';

class TaskEditor extends StatefulWidget {
  static const id = 'task_editor';
  TaskEditor({this.editing = false, this.title = '',});
  final bool editing;
  String title;
  @override
  _TaskEditorState createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  var _titleControler, _textControler;
  void initState() {
    _titleControler = TextEditingController(text: widget.title);
    super.initState();
  }

  @override
  void dispose() {
    _titleControler.dispose();
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
          IconButton(
            onPressed: () {
              //ADD TASK
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
                onChanged: (input) {
                  widget.title = input;
                },
              ),
            ),
      
          ],
        ),
      ),
    );
  }
}
