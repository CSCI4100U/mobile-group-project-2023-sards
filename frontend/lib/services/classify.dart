import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kanjou/models/note.dart';
import 'dart:convert';
import 'package:kanjou/providers/note_provider.dart';
import 'package:provider/provider.dart';

class NotesClassifier {
  static const url = '';
  static Future<void> classifyNotes(BuildContext context) async {
    final providerNotes = Provider.of<NotesProvider>(context, listen: false);
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            providerNotes.notes.map((note) => note.toMap()).toList()));
    if (response.statusCode == 201) {
      // TODO: alter tags and notes
      return;
    }

  }
}
