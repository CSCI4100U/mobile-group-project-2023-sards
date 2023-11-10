import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kanjou/screens/create_note.dart';
import 'package:kanjou/screens/custom_drawer.dart';
import 'package:kanjou/screens/settings_page.dart';
import 'package:kanjou/screens/sign_in.dart';

import 'package:kanjou/providers/note_provider.dart';
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

Transform makeBigger(IconButton icon) {
  return Transform.scale(
    scale: 1.5,
    child: icon,
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _searchBoolean = false;
  HashSet selectedNoteIndexes = HashSet<int>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

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
          onTap: () async {
            Map<String, dynamic>? noteMap = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NoteForm(
                          // speechToText: _speechToText,
                          noteData: note.toMap(),
                        )));
            if (noteMap != null) {
              await providerNotes.updateNote(noteMap, index);
            } else {
              // Show a popup saying that the note was not updated
            }
          },
          onLongPress: () async {
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
    addNote() {
      Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NoteForm()))
          .then((returnedMap) {
        // Check if the returned map has the title value or text value empty
        if (returnedMap != null &&
            returnedMap.isNotEmpty &&
            returnedMap['title'] != "" &&
            returnedMap['text'] != "") {
          providerNotes.insertNote(returnedMap);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Note successfully saved'),
            ),
          );
        } else {
          // Show a little notification on the bottom saying that the note was not added
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The note was not saved'),
            ),
          );
        }
      });
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: makeBigger(IconButton(icon: const Icon(Icons.menu),
          onPressed: (){scaffoldKey.currentState!.openDrawer();},
          tooltip: 'User Information',)),
        title: _searchBoolean ? _buildSearchField() : null,
        actions: <Widget>[
          makeBigger(IconButton(
            onPressed: () {
              setState(() {
                _searchBoolean = !_searchBoolean;
              });
            },
            icon: Icon(_searchBoolean ? Icons.clear : Icons.search),
            tooltip: 'Search for a note',
          )),
          const SizedBox(width: 12),
          makeBigger(IconButton(
            onPressed: () {
              Navigator.push(
                context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()));
              },
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          )),
          // Transform.scale(
          //   scale: 1.5,
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: const Icon(Icons.more_vert),
          //   ),
          // )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: _buildListOfNotes(providerNotes)),
        ],
      ),
      floatingActionButton: Transform.scale(
        scale: 1.2, // Increase the size
        child: FloatingActionButton(
          tooltip: 'Add a Note',
          onPressed: addNote,
          child: const Icon(Icons.edit_note_sharp),
        ),
      ),
      drawer: CustomDrawer(),
    );
  }
}
