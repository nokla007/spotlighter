class Note {
  final String userID, title, text;
  bool pin = false;
  Note(
      {required this.userID,
      required this.title,
      required this.text,
      pin = false});

  factory Note.fromMap(Map data) {
    return Note(
      userID: data['userID'] ?? '',
      title: data['title'] ?? '',
      text: data['text'] ?? '',
      pin: data['pin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID' : userID,
      'title' : title,
      'text' : text,
      'pin' : pin,
    };
  }
}
