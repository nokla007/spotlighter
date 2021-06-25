class Note {
  final String userID, title;
  bool isDone = false, highPriority = false;
    final DateTime createdTime;
  Note({
    DateTime? creationTime,
    required this.userID,
    required this.title,
    highPriority = false,
    isDone = false,
  }) : createdTime = creationTime ?? DateTime.now();

  factory Note.fromMap(Map data) {
    return Note(
      userID: data['userID'] ?? '',
      title: data['title'] ?? '',
      highPriority: data['priority'] ?? false,
      isDone: data['isDone'] ?? false,
      creationTime: data['created'],
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
}
