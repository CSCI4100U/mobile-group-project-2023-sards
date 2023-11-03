// import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kanjou/models/note.dart';
import 'package:kanjou/services/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:uuid/uuid.dart';

class NotesModel extends ChangeNotifier {
  final notesCollection = FirebaseFirestore.instance.collection('notes');
  var uuid = const Uuid();
  List<Note> notes = [];

  NotesModel() {
    // // This is needed for inintializing the DB on Windows/Mac/Linux
    // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    //   sqfliteFfiInit();
    // }

    // // This is needed for inintializing the DB on Web

    // databaseFactory = databaseFactoryFfi;

    // db = DatabaseHelper.init();

    getAllNotes();
  }

  Future getAllNotes() async {
    final db = await DatabaseHelper.init();
    final List<Map<String, dynamic>> maps = await db.query('notes');
    notes = List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
    notifyListeners();
  }

  Future<int> insertNote(Map<String, dynamic> dataMap) async {
    final db = await DatabaseHelper.init();
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
    notes.add(note);
    notifyListeners();
    print(note.toMap());
    return await db.insert('notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteNote(Note note) async {
    final db = await DatabaseHelper.init();
    notes.remove(note);
    notifyListeners();
    await db.delete('notes', where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> updateNote(Note note) async {
    final db = await DatabaseHelper.init();
    notes[notes.indexWhere((element) => element.id == note.id)] = note;
    notifyListeners();
    await db
        .update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<List<Note>> getAllNotesCloud() async {
    final QuerySnapshot snapshot = await notesCollection.get();
    return snapshot.docs
        .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> insertNoteCloud(Note note) async {
    return notesCollection
        .add(note.toMap())
        .then((value) => print("Note Added $value"))
        .catchError((error) => print("Failed to add note: $error"));
  }

  Future<void> deleteNoteCloud(String referenceId) async {
    // String toDelete = notesCollection.doc(note.reference.id).toString();
    // print(toDelete);

    return notesCollection
        .doc(referenceId)
        .delete()
        .then((value) => print("Note Deleted "))
        .catchError((error) => print("Failed to delete note: $error"));
  }

  Future updateNoteCloud(String referenceId, Note note) async {
    return notesCollection
        .doc(referenceId)
        .update(note.toMap())
        .then((value) => print("Note Updated"))
        .catchError((error) => print("Failed to update note: $error"));
  }
}
