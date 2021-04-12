class Note{
  final String noteId;
  final String noteTitle;
  final String noteContent;
  final DateTime cratedDateTime;
  final DateTime lastEditDatetime;

  Note(
      {this.noteId,
        this.noteTitle,
        this.noteContent,
        this.cratedDateTime,
        this.lastEditDatetime});

  factory Note.fromjson(Map<String, dynamic> jsondata) {
    return Note(
        noteTitle: jsondata['noteTitle'],
        noteId: jsondata['noteID'],
        noteContent: jsondata['noteContent'],
        cratedDateTime: DateTime.parse(jsondata['createDateTime']),
        lastEditDatetime: jsondata['latestEditDateTime'] != null
            ? DateTime.parse(jsondata['latestEditDateTime'])
            : null);
  }



}