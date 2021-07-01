class Note {
  final String userID;
  String title, text;
  bool pin = false;
  final DateTime createdTime;
  Note({
    DateTime? creationTime,
    required this.userID,
    required this.title,
    required this.text,
    this.pin = false,
  }) : createdTime = creationTime ?? DateTime.now();

  factory Note.fromMap(Map data) {
    return Note(
      userID: data['userID'] ?? '',
      title: data['title'] ?? '',
      text: data['text'] ?? '',
      pin: data['pin'] ?? false,
      creationTime: data['created'].toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'title': title,
      'text': text,
      'pin': pin,
      'created': createdTime,
    };
  }

  void update(String title, String text, bool pin) {
    this.title = title;
    this.text = text;
    this.pin = pin;
  }
}
