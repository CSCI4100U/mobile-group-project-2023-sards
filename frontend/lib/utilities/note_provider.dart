// import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:kanjou/models/note.dart';
import 'package:kanjou/services/database_helper.dart';
import 'package:kanjou/services/firestore_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class NotesProvider extends ChangeNotifier {
  final localDb = DatabaseHelper();
  final cloudDb = FirestoreHelper();
  List<Note> _notes = [];
  List<Note> get notes => [..._notes];

  NotesProvider() {
    // // This is needed for inintializing the DB on Windows/Mac/Linux
    // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    //   sqfliteFfiInit();
    // }

    // // This is needed for inintializing the DB on Web

    // databaseFactory = databaseFactoryFfi;

    // db = DatabaseHelper.init();
    _init();
  }

  void _init() async {
    _notes = await localDb.getAllNotes();
    notifyListeners();
  }

  Future<void> deleteNote(int i) async{
    Note note = _notes[i];
    await localDb.deleteNote(note);
    _notes.removeAt(i);
    notifyListeners();
  }

  Future<void> insertNote(Map<String, dynamic> data) async{
    int id = await localDb.insertNote(data);
    data['id'] = id;
    _notes.add(Note.fromMap(data));
    notifyListeners();
  }

  Future<void> updateNote(Map<String,dynamic> noteMap, int i) async{
    Note note = Note.fromMap(noteMap);
    await localDb.updateNote(note);
    _notes[i] = note;
    notifyListeners();
  }
}
