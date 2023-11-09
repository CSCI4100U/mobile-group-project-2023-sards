// import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:kanjou/models/note.dart';
import 'package:kanjou/services/database_helper.dart';
import 'package:kanjou/services/firestore_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

class NotesProvider extends ChangeNotifier {
  final localDb = DatabaseHelper();
  final cloudDb = FirestoreHelper();
  List<Note> _notes = [];
  List<Note> get notes => [..._notes];
  var uuid = const Uuid();

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

  Future<void> _init() async {
    _notes = await localDb.getAllNotes();
    notifyListeners();
  }

  Future<void> deleteNote(int i) async {
    Note note = _notes[i];
    _notes.removeAt(i);
    notifyListeners();
    await localDb.deleteNote(note);
  }

  Future<void> insertNote(Map<String, dynamic> dataMap) async {
    Note note = Note.fromMap({
      ...dataMap,
      'date': DateTime.now().toString(),
      'id': uuid.v4(),

      // 'color': dataMap['color'],
      // 'isImportant': dataMap['isImportant'],
      // 'isArchived': dataMap['isArchived'],
      // 'isDeleted': dataMap['isDeleted'],
      // 'isSynced': dataMap['isSynced'],
      // 'reference': dataMap['reference'],
    });
    _notes.add(note);
    notifyListeners();
    await localDb.insertNote(note);
  }

  Future<void> updateNote(Map<String, dynamic> noteMap, int i) async {
    Note note = Note.fromMap(noteMap);
    _notes[i] = note;
    notifyListeners();
    await localDb.updateNote(note);
  }
}
