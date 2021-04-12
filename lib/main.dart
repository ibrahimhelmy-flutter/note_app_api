import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:note_app_api/service/notes_services.dart';
import 'package:note_app_api/views/note_delete_dialog.dart';
import 'package:note_app_api/views/note_list.dart';
import 'package:note_app_api/views/note_modify.dart';



void setupLocator(){
  GetIt.I.registerLazySingleton(() => NotesService());
}
void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
     // home:NoteList(),
      initialRoute: NoteList.id,
      routes: {
        NoteList.id:(context)=>NoteList(),
        NoteModify.id:(context)=>NoteModify(),
        NoteDelete.id:(context)=>NoteDelete(),
      },
    );
  }
}

