import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotlighter1/constants.dart';
import 'package:spotlighter1/model/task.dart';
import 'package:spotlighter1/services/firebase_service.dart';
import 'package:spotlighter1/widgets/task_tile.dart';

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

        List<TaskTile> tasks = snapshot.data!.docs.map(
          (DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return TaskTile(
              task: Task.fromMap(data),
              id: doc.id,
            );
          },
        ).toList();
        TaskList taskList = TaskList(tasks);

        List<TaskTile> highPriorityTasks = taskList.showTasks(true);
        List<TaskTile> otherTasks = taskList.showTasks(false);
        List<TaskTile> completedTasks = taskList.showCompleted();

        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: (tasks.isEmpty)
              ? Center(
                  child: Text('No task yet!'),
                )
              : CustomScrollView(
                  slivers: [
                    kSliverText(
                        (highPriorityTasks.isNotEmpty) ? 'High Priority' : ''),
                    SliverList(
                      delegate: SliverChildListDelegate(highPriorityTasks),
                    ),
                    kSliverText((highPriorityTasks.isNotEmpty) ? 'Others' : ''),
                    SliverList(
                      delegate: SliverChildListDelegate(otherTasks),
                    ),
                    kSliverText((completedTasks.isNotEmpty) ? 'Completed' : ''),
                    SliverList(
                      delegate: SliverChildListDelegate(completedTasks),
                    ),
                  ],
                ),
        );
      },
    );
  }
}


