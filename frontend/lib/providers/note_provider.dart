// import 'dart:io' show Platform;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kanjou/models/note.dart';
import 'package:kanjou/services/database_helper.dart';
import 'package:kanjou/services/firestore_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

var url = "https://notesaimobile.azurewebsites.net/api/categorize_note"; // URL of the server
Future<String> classifyNote(String body) async {
  Map<String, dynamic> jsonData = {
    'note': '$body'
  };

  var jsonBody = json.encode(jsonData);
  try{
    var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"}, 
      body: jsonBody
      );

      if(response.statusCode == 200) {
        var categoryJson = jsonDecode(response.body);
        return categoryJson["category"].toString();

      }
      else{
        print("here");
        print(response.statusCode.toString());
        return response.statusCode.toString();
      }
  } catch(e) {
    print("or here");
    return e.toString();
  }
 
}

class NotesProvider extends ChangeNotifier {
  final localDb = DatabaseHelper();
  final cloudDb = FirestoreHelper();
  List<Note> notes = [];
  var uuid = const Uuid();

  NotesProvider() {
    // // This is needed for inintializing the DB on Windows/Mac/Linux
    // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    //   sqfliteFfiInit();
    // }

    // // This is needed for inintializing the DB on Web

    // databaseFactory = databaseFactoryFfi;

    // Initialize the local DB
    localDb.init().then((_) async {
      await refresh();
    });
  }

  Future<void> refresh() async {
    notes = await localDb.getAllNotes();
    notifyListeners();
  }

  Future<void> deleteNote(int i) async {
    Note note = notes[i];
    notes.removeAt(i);
    notifyListeners();
    await localDb.deleteNote(note);
  }

  Future<void> insertNote(Map<String, dynamic> dataMap) async {
    Note note = Note.fromMap({
      ...dataMap,
      'date': DateTime.now().toString(),
      'id': uuid.v4(),
      'tag': await classifyNote(dataMap['text']),

      // 'color': dataMap['color'],
      // 'isImportant': dataMap['isImportant'],
      // 'isArchived': dataMap['isArchived'],
      // 'isDeleted': dataMap['isDeleted'],
      // 'isSynced': dataMap['isSynced'],
      // 'reference': dataMap['reference'],
    });
    notes.add(note);
    notifyListeners();
    await localDb.insertNote(note);
  }

  Future<void> updateNote(Map<String, dynamic> noteMap, int i) async {
    Note note = Note.fromMap(noteMap);
    notes[i] = note;
    notifyListeners();
    await localDb.updateNote(note);
  }
}
