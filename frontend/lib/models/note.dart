import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanjou/services/database_helper.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Note {
  String title;
  String text; // Change this to raw bytes
  String id;
  String date;
  // final DocumentReference reference;

  Note(
      {required this.title,
      required this.text,
      required this.id,
      required this.date});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'text': text, 'date': date};
  }

  Note.fromMap(Map<String, dynamic> noteMap)
      : id = noteMap['id'],
        title = noteMap['title'],
        text = noteMap['text'],
        date = noteMap['date'];
}
