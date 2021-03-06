import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotlighter1/model/task.dart';
import 'package:spotlighter1/screens/task_editor.dart';
import 'package:spotlighter1/services/firebase_service.dart';

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
            //print(value);
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
            fontSize: 16,
            decoration: (task.isDone) ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: (task.scheduleTime == null)
            ? null
            : ShowSchedule(schedule: task.scheduleTime!),
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

class ShowSchedule extends StatelessWidget {
  const ShowSchedule({Key? key, required this.schedule}) : super(key: key);
  final DateTime schedule;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(
            Icons.access_time_outlined,
            color: Colors.orangeAccent,
            size: 16,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            schedule.toLocal().toIso8601String(),
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class TaskList {
  List<TaskTile> allTask;

  TaskList(this.allTask);

  List<TaskTile> showTasks(bool priority) {
    List<TaskTile> list = [];
    for (TaskTile tile in allTask) {
      if (tile.task.isDone == false && tile.task.highPriority == priority) {
        list.add(tile);
      }
    }
    return list;
  }

  List<TaskTile> showCompleted() {
    List<TaskTile> list = [];
    for (TaskTile tile in allTask) {
      if (tile.task.isDone == true) {
        list.add(tile);
      }
    }
    return list;
  }
}


//Text( task.scheduleTime!.toLocal().toIso8601String()),