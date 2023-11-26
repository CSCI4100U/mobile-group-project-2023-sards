// import 'dart:io' show Platform;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kanjou/models/note.dart';
import 'package:kanjou/services/connectivity.dart';
import 'package:kanjou/services/database_helper.dart';
import 'package:kanjou/services/firestore_helper.dart';
import 'package:uuid/uuid.dart';

var url =
    "https://notesaimobile.azurewebsites.net/api/categorize_note"; // URL of the server

/*

The above endpoint was previously committed but reverted to localhost due to a server configuration issue on Azure.
The issue was pinpointed and resolved so the endpoint is changed and working.
Nothing else has changed in the codebase or on the backend.

Please check commit 8c8a993 and commit beef2fe

*/

class NotesProvider extends ChangeNotifier {
  final localDb = DatabaseHelper();
  final cloudDb = FirestoreHelper();
  List<Note> notes = [];
  var uuid = const Uuid();

  bool hasConnection = false;

  NotesProvider() {
    // Initialize the local DB
    localDb.init().then((_) async {
      await refresh();
    });

    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    connectionStatus.connectionChange.listen(connectionChanged);
  }

  Future<void> classifyNote(Note note, int i) async {
    String body = "${note.title}:${note.text}";
    Map<String, dynamic> jsonData = {'note': body};

    var jsonBody = json.encode(jsonData);
    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: jsonBody);
      if (response.statusCode == 200) {
        var categoryJson = jsonDecode(response.body);
        String category = categoryJson["category"][0].toString();
        Note newNote = Note.fromMap({...note.toMap(), 'tag': category});
        notes[i] = newNote;
        notifyListeners();
        await localDb.updateNote(newNote);
      } else {
        debugPrint(response.statusCode.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void connectionChanged(dynamic hasConnection) {
    print("hasConnection: $hasConnection");
    // Update the notes which have the tag as a empty string and call notifyListeners()
    if (hasConnection) {
      for (int i = 0; i < notes.length; i++) {
        if (notes[i].tag == null) {
          classifyNote(notes[i], i);
        }
      }
    }
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
      'tag': null,

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
    classifyNote(note, notes.length - 1);
  }

  Future<void> updateNote(Map<String, dynamic> noteMap, int i) async {
    Note note = Note.fromMap(noteMap);
    notes[i] = note;
    notifyListeners();
    await localDb.updateNote(note);
    classifyNote(note, i);
  }
}
