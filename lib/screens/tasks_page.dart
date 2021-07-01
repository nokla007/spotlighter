import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotlighter1/model/task.dart';
import 'package:spotlighter1/screens/task_editor.dart';
import 'package:spotlighter1/services/firebase_service.dart';

class TasksPage extends StatelessWidget {
  TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: context.read<FirebaseService>().taskstream,
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

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListView(
              children: snapshot.data!.docs.map(
                (DocumentSnapshot doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return TaskTile(
                    task: Task.fromMap(data),
                    id: doc.id,
                  );
                },
              ).toList(),
            ),
          );
        });
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({Key? key, required this.task, required this.id})
      : super(key: key);
  final Task task;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (value) {
            print(value);
            task.toggleDone(value);
            try {
              context.read<FirebaseService>().editTask(task, id);
            } on FirebaseException catch (e) {
              print(e.message);
            }
          },
        ),
        title: Text(
          task.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            fontSize: 18,
            decoration: (task.isDone) ? TextDecoration.lineThrough : null,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => TaskEditor(
                task: task,
                id: id,
              ),
            ),
          );
        },
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
