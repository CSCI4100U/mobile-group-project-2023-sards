import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kanjou/screens/create_note.dart';
import 'package:kanjou/screens/custom_drawer.dart';
import 'package:kanjou/screens/settings_page.dart';
import 'package:kanjou/screens/sign_in.dart';

import 'package:kanjou/utilities/note_provider.dart';
import 'package:provider/provider.dart';

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
  try {
    DateTime dateTime = DateTime.parse(date);
    return "${months[dateTime.month]} ${dateTime.day.toString().padLeft(2, '0')}, ${dateTime.year.toString()}";
  } catch (e) {
    return "No date";
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  // Map<int, bool> selectedNoteIndexes = {};
  HashSet selectedNoteIndexes = HashSet<int>();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Note> note = [];

  bool _searchBoolean = false;



  Widget _buildSearchField() {
    return TextField(
      decoration: const InputDecoration(
        hintText: "Search...",
      ),
      onSubmitted: (value) {
        // Handle search here
      },
    );
  }

  Widget _buildListOfNotes(NotesProvider providerNotes) {
    return MasonryGridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      mainAxisSpacing: 3,
      crossAxisSpacing: 4,
      itemCount: providerNotes.notes.length,
      itemBuilder: (context, index) {
        final note = providerNotes.notes[index];
        return GestureDetector(
          onTap: () async{
            Map<String,dynamic> noteMap = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NoteForm(
                          // speechToText: _speechToText,
                          noteData: note.toMap(),
                        )));
            if(noteMap != null){
              await providerNotes.updateNote(noteMap, index);
            }
          },
          onLongPress: () async{
            await providerNotes.deleteNote(
                index); // This is a temporary solution, will be changed later
          },
          child: Card(
              color: const Color.fromARGB(255, 23, 23, 23),
              child: Padding(
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
                        note.date != ""
                            ? convertStringToDate(note.date)
                            : "No date",
                        maxLines: 1,
                        style: const TextStyle(
                          color: const Color.fromARGB(255, 111, 111, 111),
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
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference notesCollection =
    // FirebaseFirestore.instance.collection('notes');
    final providerNotes = Provider.of<NotesProvider>(context);

    // These methods have to be inside the build method because they use context
    addNote() async {
      Map<String, dynamic> data = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoteForm()));

      if (data != null) {
        providerNotes.insertNote(data);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: _searchBoolean ? _buildSearchField() : null,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                _searchBoolean = !_searchBoolean;
              });
            },
            icon: Icon(_searchBoolean ? Icons.clear : Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: _buildListOfNotes(providerNotes)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Notes!',
        onPressed: addNote,
        child: const Icon(Icons.edit_note_sharp),
      ),
      drawer: CustomDrawer(),
    );
  }
}
