import 'package:http/http.dart' as http;
import 'package:kanjou/models/note.dart';
import 'dart:convert';

class NotesClassifier {
  static const url = '';
  static Future<void> classify(List<Note> notes) async {
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(notes.map((note) => note.toMap()).toList()));
    if(response.statusCode == 201){

    }
  }
}
