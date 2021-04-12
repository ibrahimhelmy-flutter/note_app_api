import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:note_app_api/model/api_response.dart';
import 'package:note_app_api/model/note_for_listing.dart';
import 'package:note_app_api/model/note_insert.dart';
import 'package:note_app_api/service/notes_services.dart';

import 'note_modify.dart';
import 'note_delete_dialog.dart';

class NoteList extends StatefulWidget {
  static const String id = "/noteList";

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NotesService get service => GetIt.I<NotesService>();
  ApiResponse<List<NoteForListing>> _apiResponse;
  bool isLoading = false;

  String formateDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${DateFormat.jm().format(DateTime.now())}';
  }

  void _addNewTransaction(String title, String content, String id) async {
    bool isEdited = id != null ? true : false;
    print('----------- $title $content $id $isEdited');
    await managetNote(id, isEdited, title, content);
  }

  Future<void> managetNote(
      String id, bool isEdited, String title, String content) async {
    setState(() {
      isLoading = true;
    });
    var result = isEdited
        ? await service.updateNote(
            id, NoteManage(noteTitle: title, noteContent: content))
        : await service
            .crateNote(NoteManage(noteTitle: title, noteContent: content));

    await fetchData();
    setState(() {
      isLoading = false;
    });

    final DialogTitle = "Done";
    final text = result.error
        ? result.errorMessage ?? "something error happen"
        : isEdited
            ? "Edited success"
            : "your Note Created success";
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(DialogTitle),
        content: Text(text),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("ok"))
        ],
      ),
    );
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    _apiResponse = await service.getNotesList();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Note"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModelBottomsheet(context, null),
        child: Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (isLoading) return Center(child: CircularProgressIndicator());
          if (_apiResponse.error)
            return Center(
              child: Text(_apiResponse.errorMessage),
            );
          return ListView.separated(
              itemBuilder: (_, index) {
                return Dismissible(
                  key: ValueKey(_apiResponse.data[index].noteId),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                        context: context, builder: (_) => NoteDelete());

                    if (result) {
                      final deleteresult = await service
                          .deleteNote(_apiResponse.data[index].noteId);
                      var message;
                      if (deleteresult != null && deleteresult.data == true) {
                        message = "the note was delete Successful";
                      } else {
                        message =
                            deleteresult?.errorMessage ?? "An Error occured>>";
                      }
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text("Done"),
                                content: Text(message),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("ok"))
                                ],
                              ));
                      return deleteresult?.data??false;
                    }

                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 16),
                    child: Align(
                      child: Icon(Icons.delete),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: ListTile(
                    onTap: () => showModelBottomsheet(
                        context, _apiResponse.data[index].noteId),
                    title: Text(
                      _apiResponse.data[index].noteTitle,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    subtitle: Text(
                        "last edit on ${formateDateTime(_apiResponse.data[index].lastEditDatetime ?? _apiResponse.data[index].cratedDateTime)}"),
                  ),
                );
              },
              separatorBuilder: (_, __) => Divider(
                    color: Colors.green,
                    height: 1,
                  ),
              itemCount: _apiResponse.data.length);
        },
      ),
    );
  }

  void showModelBottomsheet(BuildContext context, String noteId) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return NoteModify(
            addTx: _addNewTransaction,
            noteId: noteId,
          );
        });
  }
}
