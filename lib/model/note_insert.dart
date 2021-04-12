import 'package:flutter/cupertino.dart';

class NoteManage{
 final  String noteTitle;
  final String noteContent;

  NoteManage({@required this.noteTitle,@required  this.noteContent});

 Map<String ,dynamic> toJson() {

  return{
   'noteTitle':noteTitle,
   "noteContent":noteContent
  };
 }





}