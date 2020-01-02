class Note {
  final int id;
  final String noteTitle;
  final String noteContent;
  final String timeNoteMade;
  final String dateNoteMade;
  final String dayNoteMade;

  Note({this.id, this.noteTitle, this.noteContent, this.timeNoteMade, this.dateNoteMade, this.dayNoteMade});

  Map<String, dynamic> toMap() => {
    "id": id,
    "noteTitle": noteTitle,
    "noteContent": noteContent,
    "timeNoteMade": timeNoteMade,
    "dateNoteMade": dateNoteMade,
    "dayNoteMade": dayNoteMade,
  };

  factory Note.fromMap(Map<String, dynamic> json) => new Note(
    id: json["id"],
    noteTitle: json["noteTitle"],
    noteContent: json["noteContent"],
    timeNoteMade: json["timeNoteMade"],
    dateNoteMade: json["dateNoteMade"],
    dayNoteMade: json["dayNoteMade"],
  );

  @override
  String toString() {
    return "Note{id: $id, noteTitle: $noteTitle, noteContent: $noteContent, timeNoteMade: $timeNoteMade, dateNoteMade: $dateNoteMade, dayNoteMade: $dayNoteMade}";
  }
}

