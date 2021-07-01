class Task {
  final String userID;
  String title;
  bool isDone = false, highPriority = false;
  final DateTime createdTime;
  Task({
    DateTime? creationTime,
    required this.userID,
    required this.title,
    this.highPriority = false,
    this.isDone = false,
  }) : createdTime = creationTime ?? DateTime.now();

  factory Task.fromMap(Map data) {
    return Task(
      userID: data['userID'] ?? '',
      title: data['title'] ?? '',
      highPriority: data['priority'] ?? false,
      isDone: data['isDone'] ?? false,
      creationTime: data['created'].toDate() ?? DateTime.now(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'title': title,
      'priority': highPriority,
      'isDone': isDone,
      'created': createdTime,
    };
  }

  void update(String title, bool highPriority) {
    this.title = title;
    this.highPriority = highPriority;
  }
}
