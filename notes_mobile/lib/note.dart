class Note {
  final int id;
  final String noteTitle;
  final String noteContent;

  Note({this.id, this.noteTitle, this.noteContent});

  Map<String, dynamic> toMap() => {
    "id": id,
    "noteTitle": noteTitle,
    "noteContent": noteContent,
  };

  factory Note.fromMap(Map<String, dynamic> json) => new Note(
    id: json["id"],
    noteTitle: json["noteTitle"],
    noteContent: json["noteContent"],
  );

  @override
  String toString() {
    return "Note{id: $id, noteTitle: $noteTitle, noteContent: $noteContent}";
  }
}

