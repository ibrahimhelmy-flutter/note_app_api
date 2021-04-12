import 'dart:convert';

import 'package:note_app_api/model/api_response.dart';
import 'package:note_app_api/model/note.dart';
import 'package:note_app_api/model/note_for_listing.dart';
import 'package:http/http.dart' as http;
import 'package:note_app_api/model/note_insert.dart';

class NotesService {
  static const API = "https://tq-notes-api-jkrgrdggbq-el.a.run.app";
  static const header = {'apiKey': '088d5418-e23f-4e5e-ad81-605ba9925481',"Content-Type":'application/json'};


//  application/json

  Future<ApiResponse<List<NoteForListing>>> getNotesList() {
    return http.get(Uri.parse(API + '/notes'), headers: header).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body); //convert response to map
        final notes = <NoteForListing>[]; //prepare my list
        for (var item in jsonData) {
          notes.add(NoteForListing.fromjson(item));
        }
        return ApiResponse<List<NoteForListing>>(data: notes);
      }
      return ApiResponse<List<NoteForListing>>(error: true,errorMessage: "An Error occured");
    }).catchError((_)=>ApiResponse<List<NoteForListing>>(error: true,errorMessage: "An Error occured"));
  }


  Future<ApiResponse<Note>> getNote(String noteId) {
    return http.get(Uri.parse(API + '/notes/'+noteId), headers: header).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body); //convert response to map
        Note note=Note.fromjson(jsonData);
        return ApiResponse<Note>(data: note);
      }
      return ApiResponse<Note>(error: true,errorMessage:  "An Error occured");
    }).catchError((_)=>ApiResponse<Note>(error: true,errorMessage: "An Error occured"));
  }

    Future<ApiResponse<bool>> crateNote(NoteManage item) {
    return http.post(Uri.parse(API + '/notes'), headers: header,body: json.encode(item.toJson())).then((data) {
      if (data.statusCode == 201) {
        return ApiResponse<bool>(data: true);
      }
      return ApiResponse<bool>(error: true,errorMessage: "An Error occured");
    }).catchError((_)=>ApiResponse<bool>(error: true,errorMessage: "An Error occured"));
  }
  Future<ApiResponse<bool>> updateNote(String noteId,NoteManage item) {
    return http.put(Uri.parse(API + '/notes/'+noteId), headers: header,body: json.encode(item.toJson())).then((data) {
      if (data.statusCode == 204) {
        return ApiResponse<bool>(data: true);
      }
      return ApiResponse<bool>(error: true,errorMessage: "An Error occured");
    }).catchError((_)=>ApiResponse<bool>(error: true,errorMessage: "An Error occured"));
  }

 Future<ApiResponse<bool>> deleteNote(String noteId) {
    return http.delete(Uri.parse(API + '/notes/'+noteId), headers: header).then((data) {
      if (data.statusCode == 204) {
        return ApiResponse<bool>(data: true);
      }
      return ApiResponse<bool>(error: true,errorMessage: "An Error occured...");
    }).catchError((_)=>ApiResponse<bool>(error: true,errorMessage: "An Error occuredbbbb"));
  }


}
