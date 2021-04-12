class NoteForListing {
  final String noteId;
  final String noteTitle;
  final DateTime cratedDateTime;
  final DateTime lastEditDatetime;

  NoteForListing(
      {this.noteId,
      this.noteTitle,
      this.cratedDateTime,
      this.lastEditDatetime});

  factory NoteForListing.fromjson(Map<String, dynamic> jsondata) {
    return NoteForListing(
        noteTitle: jsondata['noteTitle'],
        noteId: jsondata['noteID'],
        cratedDateTime: DateTime.parse(jsondata['createDateTime']),
        lastEditDatetime: jsondata['latestEditDateTime'] != null
            ? DateTime.parse(jsondata['latestEditDateTime'])
            : null);
  }
}
