class Task {
  final String userID;
  String title;
  bool isDone = false, highPriority = false;
  final DateTime createdTime;
  DateTime? scheduleTime;
  Task({
    DateTime? creationTime,
    required this.userID,
    required this.title,
    this.highPriority = false,
    this.isDone = false,
    this.scheduleTime,
  }) : createdTime = creationTime ?? DateTime.now();

  factory Task.fromMap(Map data) {
    return Task(
      userID: data['userID'] ?? '',
      title: data['title'] ?? '',
      highPriority: data['priority'] ?? false,
      isDone: data['isDone'] ?? false,
      creationTime: data['created'].toDate() ?? DateTime.now(),
      scheduleTime:
          (data['schedule'] != null) ? data['schedule'].toDate() : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'title': title,
      'priority': highPriority,
      'isDone': isDone,
      'created': createdTime,
      if (scheduleTime != null) 'schedule': scheduleTime,
    };
  }

  void update(
      {required String title, required bool priority, DateTime? schedule}) {
    this.title = title;
    this.highPriority = priority;
    this.scheduleTime = schedule;
  }

  void toggleDone(bool? done) {
    if (done != null) this.isDone = done;
  }
}
