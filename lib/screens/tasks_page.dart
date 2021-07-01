import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      TaskTile(title: 'Task 1'),
      TaskTile(title: 'Task 1'),
      TaskTile(title: 'Task 1'),
      TaskTile(title: 'Task 1'),
      TaskTile(title: 'Task 1'),
      TaskTile(title: 'Task 1'),
      TaskTile(title: 'Task 1'),
      TaskTile(title: 'Task 1'),
    ]);
  }
}

class TaskTile extends StatefulWidget {
  String title = '';
  bool value = false;

  TaskTile({Key? key, required this.title}) : super(key: key);
  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: widget.value,
          onChanged: (val) {
            if (val != null)
              setState(() {
                widget.value = val;
              });
          },
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 18,
            decoration: (widget.value) ? TextDecoration.lineThrough : null,
          ),
        ),
        onTap: () {
          print('task tapped');
        },
      ),
    );
  }
}
