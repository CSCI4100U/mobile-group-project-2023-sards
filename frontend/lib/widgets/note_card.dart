import 'package:flutter/material.dart';
import 'package:kanjou/models/note.dart';
import 'package:kanjou/utilities/date_conversion.dart';

class NoteCard extends StatelessWidget {
  Note note;
  NoteCard({required this.note, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: const Color.fromARGB(255, 23, 23, 23),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.tag != null ? note.tag! : "No tag",
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  note.title,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  note.date != "" ? convertStringToDate(note.date) : "No date",
                  maxLines: 1,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 111, 111, 111),
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                note.text,
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ));
  }
}
