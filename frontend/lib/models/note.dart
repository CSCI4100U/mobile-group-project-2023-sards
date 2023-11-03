import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanjou/services/database_helper.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const months = {
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'Aug',
  9: 'Sept',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec'
};

// This method converts a date time string to the format of Month Name dd, yyyy
String convertStringToDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  return "${months[dateTime.month]} ${dateTime.day.toString().padLeft(2, '0')}, ${dateTime.year.toString()}";
}

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
        date = convertStringToDate(noteMap['date']);
}
