import 'package:flutter/scheduler.dart';

class Note {
  final String userID, title;
  bool isDone = false, highPriority = false;
  Note({required this.userID, required this.title, highPriority = false, isDone = false});

  factory Note.fromMap(Map data) {
    return Note(
      userID: data['userID'] ?? '',
      title: data['title'] ?? '',
      highPriority: data['priority'] ?? false,
      isDone: data['isDone'] ?? false,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'title': title,
      'priority': highPriority,
      'isDone': isDone,
    };
  }
}
