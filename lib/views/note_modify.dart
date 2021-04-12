import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:note_app_api/model/note.dart';
import 'package:note_app_api/model/note_for_listing.dart';
import 'package:note_app_api/service/notes_services.dart';

class NoteModify extends StatefulWidget {
  static const String id = "/noteModify";
  final void Function(String, String, String) addTx;
  final String noteId;

  NoteModify({this.addTx, this.noteId});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  NotesService get noteForListing => GetIt.I<NotesService>();
  String errormessage;
  Note note;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    bool isEdited = widget.noteId != null ? true : false;
    isEdited ? getOldData() : null;
  }

  void getOldData() {
    setState(() {
      _isLoading = true;
    });
    noteForListing.getNote(widget.noteId).then((response) {
      setState(() {
        _isLoading = false;
      });
      if (response.error) {
        errormessage = response.errorMessage ?? "error accoured";
      }
      note = response.data;
      titleController.text = note.noteTitle;
      contentController.text = note.noteContent;
    });
  }

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  void onSubmit() {
    try {
      final enteredTitle = titleController.text;

      final enteredContent = contentController.text;
      if (enteredTitle.isEmpty) {
        return;
      }
      setState(() {
        widget.addTx(enteredTitle, enteredContent, widget.noteId);
      });
    } catch (e) {
      print(e);
    }

    titleController.clear();
    contentController.clear();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: _isLoading?Center(child: CircularProgressIndicator(),):Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                  controller: titleController,
                  onSubmitted: (_) => onSubmit(),
                  decoration: InputDecoration(
                      hintText: "Note Title",
                      contentPadding: EdgeInsets.only(
                          top: 0.0, bottom: 7.0, right: 10, left: 10),
                      hintStyle: new TextStyle(color: Colors.black26),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(80.0)),
                        borderSide:
                            const BorderSide(color: Colors.black45, width: 0.0),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Colors.black),
                      ))),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                      hintText: "Note Content",
                      contentPadding: EdgeInsets.only(
                          top: 0.0, bottom: 7.0, right: 10, left: 10),
                      hintStyle: new TextStyle(color: Colors.black26),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(80.0)),
                        borderSide:
                            const BorderSide(color: Colors.black26, width: 0.0),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Colors.black45),
                      ))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: onSubmit,
                  child: Text(
                    widget.noteId == null ? "Add Note" : "Edit Note",
                    style: TextStyle(color: Colors.black),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
