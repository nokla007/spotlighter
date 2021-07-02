import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotlighter1/model/task.dart';
import 'package:spotlighter1/services/firebase_service.dart';

class TaskEditor extends StatefulWidget {
  TaskEditor({
    this.task,
    this.id,
  });
  final Task? task;
  final String? id;
  @override
  _TaskEditorState createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  late TextEditingController _titleControler;
  bool _priority = false;
  bool _editing = false;

  void initState() {
    _editing = (widget.task != null);
    _priority = (_editing) ? widget.task!.highPriority : false;
    _titleControler =
        TextEditingController(text: (_editing) ? widget.task!.title : '');
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
        title: (!_editing) ? Text('Add Task') : null,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (_editing == true)
            IconButton(
              onPressed: () {
                //delete task
                print('delete task');
              },
              icon: Icon(Icons.delete_rounded),
            ),
          IconButton(
            onPressed: () async {
              //ADD TASK
              if (_editing) {
                Task task = widget.task!;
                task.update(_titleControler.text, _priority);
                try {
                  context.read<FirebaseService>().editTask(task, widget.id);
                } on FirebaseException catch (e) {
                  print(e.message);
                }
              } else {
                Task newTask = Task(
                  userID: context.read<FirebaseService>().getUID,
                  title: _titleControler.text,
                  highPriority: _priority,
                );
                try {
                  context.read<FirebaseService>().createTask(newTask);
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
                  maxLines: 1,
                  maxLength: 50,
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
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'High Priority',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 60,
                    child: Switch(
                      value: _priority,
                      onChanged: (bool value) {
                        setState(() {
                          _priority = value;
                        });
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Text(
              //       'Schedule',
              //       style: TextStyle(fontSize: 20),
              //     ),
              //     SizedBox(
              //       width: 60,
              //       child: IconButton(
              //         iconSize: 28,
              //         onPressed: () {},
              //         icon: Icon(Icons.date_range_rounded),
              //       ),
              //     )
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
