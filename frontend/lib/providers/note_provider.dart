// import 'dart:io' show Platform;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kanjou/models/note.dart';
import 'package:kanjou/services/connectivity.dart';
import 'package:kanjou/services/database_helper.dart';
import 'package:kanjou/services/firestore_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

// This is the endpoint for the categorization service
const endpoint = "http://192.168.2.16:8080/api/categorize_note";

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

  Future<String> classifyNote(String title, String text) async {
    if (!hasConnection) {
      return "";
    }

    Map<String, dynamic> jsonData = {'note': "$title: $text"};
    var jsonBody = json.encode(jsonData);
    try {
      Response response = await post(Uri.parse(endpoint),
          headers: {"Content-Type": "application/json"}, body: jsonBody);
      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        var categoryJson = jsonDecode(response.body);
        print("Response: $categoryJson[\"category\"].toString()");
        return categoryJson["category"].toString();
      }
    } catch (e) {
      print("Error: $e");
    }
    return "";
  }

  void connectionChanged(dynamic hasConnection) {
    print("hasConnection: $hasConnection");
    // Update the notes which have the tag as a empty string and call notifyListeners()
    if (hasConnection) {
      notes.forEach((note) async {
        print('hasConnection: ${note.tag}');
        if (note.tag == '') {
          note.tag = await classifyNote(note.title,
              note.text); // This is a blocking call, so we need to make it async
          await localDb.updateNote(
              note); // This is a blocking call, so we need to make it async
        }
      });
      notifyListeners();
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
      'tag': await classifyNote(dataMap['title'], dataMap['text']),

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
