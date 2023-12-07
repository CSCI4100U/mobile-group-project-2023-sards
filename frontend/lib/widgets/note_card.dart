import 'package:flutter/material.dart';
import 'package:kanjou/models/note.dart';
import 'package:kanjou/utilities/date_conversion.dart';
import 'package:kanjou/utilities/quill_document_conversion.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final bool? isSelected;
  const NoteCard({required this.note, this.isSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        //color: const Color.fromARGB(255, 23, 23, 23),
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      //color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(bottom: 4.0),child: Text(
                  note.tag != null ? note.tag! : "No tag",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    //color: Colors.white,
                    backgroundColor: Colors.yellow,
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    note.date != ""
                        ? convertStringToDate(note.date)
                        : "No date",
                    maxLines: 1,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 111, 111, 111),
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  deltaJsonToString(note.text),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          isSelected != null
              ? Positioned(
            top: 4.0,
            left: 4.0,
            child: Icon(
                isSelected! ? Icons.check_circle : Icons.circle_outlined,
                color: Colors.yellow),
          )
              : Container(),
        ]));
  }
}
