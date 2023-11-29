import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kanjou/models/note.dart';

class FirestoreHelper {
  // final userCollection = FirebaseFirestore.instance.collection('notes');
  // get notesCollection = FirebaseFirestore.instance.collection('notes');
  User? get user => FirebaseAuth.instance.currentUser;
  CollectionReference get notesCollection =>
      FirebaseFirestore.instance.doc(user!.uid).collection('data');

  CollectionReference getNotesCollection() {
    User user = FirebaseAuth.instance.currentUser!;
    final userData = FirebaseFirestore.instance.collection('data');
    return userData.doc(user.uid).collection('notes');
  }

  Future<List<Note>> getAllNotesCloud() async {
    final notesCollection = await getNotesCollection().get();
    return notesCollection.docs
        .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> insertNoteCloud(Note note) async {
    Map<String, dynamic> data = note.toMap();
    return getNotesCollection()
        .add(data)
        .then((value) => debugPrint("Note Added $value"))
        .catchError((error) => debugPrint("Failed to add note: $error"));
  }

  Future<void> deleteNoteCloud(String referenceId) async {
    return getNotesCollection()
        .doc(referenceId)
        .delete()
        .then((value) => debugPrint("Note Deleted "))
        .catchError((error) => debugPrint("Failed to delete note: $error"));
  }

  Future updateNoteCloud(String referenceId, Note note) async {
    return getNotesCollection()
        .doc(referenceId)
        .update(note.toMap())
        .then((value) => debugPrint("Note Updated"))
        .catchError((error) => debugPrint("Failed to update note: $error"));
  }
}
