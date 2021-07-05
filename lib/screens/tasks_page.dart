import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotlighter1/model/task.dart';
import 'package:spotlighter1/services/firebase_service.dart';
import 'package:spotlighter1/widgets/sliver_text.dart';
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

        final List<TaskTile> highPriorityTasks = [];
        final List<TaskTile> otherTasks = [];
        final List<TaskTile> completedTasks = [];
        final docs = snapshot.data!.docs;
        for (var doc in docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          final Task _task = Task.fromMap(data);
          final String _id = doc.id;
          if (_task.isDone) {
            completedTasks.add(TaskTile(task: _task, id: _id));
          } else if (_task.highPriority) {
            highPriorityTasks.add(TaskTile(task: _task, id: _id));
          } else {
            otherTasks.add(TaskTile(task: _task, id: _id));
          }
        }

        // List<TaskTile> tasks = snapshot.data!.docs.map(
        //   (DocumentSnapshot doc) {
        //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        //     return TaskTile(
        //       task: Task.fromMap(data),
        //       id: doc.id,
        //     );
        //   },
        // ).toList();


        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: (completedTasks.isEmpty &&
                  highPriorityTasks.isEmpty &&
                  otherTasks.isEmpty)
              ? Center(
                  child: Text('No task yet!'),
                )
              : CustomScrollView(
                  slivers: [
                    SliverText(
                        (highPriorityTasks.isNotEmpty) ? 'High Priority' : ''),
                    SliverList(
                      delegate: SliverChildListDelegate(highPriorityTasks),
                    ),
                    SliverText((highPriorityTasks.isNotEmpty) ? 'Others' : ''),
                    SliverList(
                      delegate: SliverChildListDelegate(otherTasks),
                    ),
                    //SliverText((completedTasks.isNotEmpty) ? 'Completed' : ''),
                    ComlpletedTile(completedTasks: completedTasks),
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

class ComlpletedTile extends StatelessWidget {
  const ComlpletedTile({
    Key? key,
    required this.completedTasks,
  }) : super(key: key);

  final List<TaskTile> completedTasks;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: (completedTasks.isEmpty)
          ? SizedBox(
              height: 5,
            )
          : SizedBox(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Divider(
                      thickness: 0.5,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Completed',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Clear completed tasks?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            for (TaskTile tt
                                                in completedTasks) {
                                              final _id = tt.id;
                                              context
                                                  .read<FirebaseService>()
                                                  .deleteTask(_id);
                                            }
                                          },
                                          child: Text('Ok'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            icon: Icon(Icons.close),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
