import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kanjou/models/note.dart';
import 'package:kanjou/screens/create_note.dart';
import 'package:kanjou/widgets/custom_drawer.dart';
import 'package:kanjou/screens/settings_page.dart';
import 'package:kanjou/providers/settings_provider.dart';
import 'package:kanjou/providers/note_provider.dart';
import 'package:provider/provider.dart';
import 'package:kanjou/services/sync.dart';
import 'package:kanjou/utilities/fuzzy_search.dart';
import 'package:kanjou/widgets/note_card.dart';

Transform makeBigger(IconButton icon) {
  return Transform.scale(
    scale: 1.5,
    child: icon,
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HashSet<int> selectedNoteIndexes = HashSet<int>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSelectMode = false;

  Widget _buildSearchField(NotesProvider notesProvider) {
    return SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
      return SearchBar(
        controller: controller,
        hintText: 'Search for a note',
        onTap: () {
          controller.openView();
        },
        onChanged: (String query) {
          controller.openView();
        },
        leading: const Icon(Icons.search),
        onSubmitted: (query) {},
      );
    }, suggestionsBuilder: (BuildContext context, SearchController controller) {
      // print(results.length);
      // Make a list based on the results list
      List<Note> results = fuzzySearch(controller.text, notesProvider);

      return List<Widget>.generate(results.length, (int index) {
        return ListTile(
            title: Text(results[index].title),
            subtitle: Text(results[index].text),
            onTap: () async {
              controller.closeView("");
              Map<String, dynamic>? noteMap = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoteForm(
                            noteData: results[index].toMap(),
                          )));
              if (noteMap != null) {
                await notesProvider.updateNote(noteMap, index).then((val) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Note successfully updated")));
                });
              }
            });
      });
    });
  }

  void toggleSelectMode({int? index}) {
    setState(() {
      if (_isSelectMode) {
        _isSelectMode = false;
        selectedNoteIndexes.clear();
        return;
      }
      _isSelectMode = true;
      if (index != null) {
        selectedNoteIndexes.add(index);
      }
    });
  }

  Widget _buildListOfNotes(NotesProvider notesProvider) {
    return MasonryGridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      mainAxisSpacing: 3,
      crossAxisSpacing: 4,
      itemCount: notesProvider.notes.length,
      itemBuilder: (context, index) {
        final note = notesProvider.notes[index];
        return GestureDetector(
          onTap: _isSelectMode
              ? () {
                  setState(() {
                    if (!selectedNoteIndexes.add(index)) {
                      selectedNoteIndexes.remove(index);
                    }
                  });
                }
              : () async {
                  Map<String, dynamic>? noteMap = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NoteForm(
                                // speechToText: _speechToText,
                                noteData: note.toMap(),
                              )));
                  if (noteMap != null) {
                    await notesProvider.updateNote(noteMap, index).then((val) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Note successfully updated")));
                    });
                  }
                },
          onLongPress: () {
            toggleSelectMode(index: index);
          },
          child: NoteCard(
            note: note,
            isSelected:
                !_isSelectMode ? null : selectedNoteIndexes.contains(index),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference notesCollection =
    // FirebaseFirestore.instance.collection('notes');
    final notesProvider = Provider.of<NotesProvider>(context);
    final providerSettings = Provider.of<SettingsProvider>(context);
    // These methods have to be inside the build method because they use context
    void addNote() {
      Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NoteForm()))
          .then((returnedMap) {
        // Check if the returned map has the title value or text value empty
        if (returnedMap != null &&
            returnedMap.isNotEmpty &&
            returnedMap['title'] != "" &&
            returnedMap['text'] != "") {
          notesProvider.insertNote(returnedMap);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Note successfully saved'),
                backgroundColor: Colors.yellow),
          );
          if (providerSettings.sync) {
            Sync.uploadToCloud(context);
          }
        } else {
          // Show a little notification on the bottom saying that the note was not added
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The note was not saved'),
              backgroundColor: Colors.yellow,
            ),
          );
        }
      });
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: makeBigger(IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
          color: Colors.yellow,
          tooltip: 'User Information',
        )),
        title: _buildSearchField(notesProvider),
        actions: <Widget>[
          const SizedBox(width: 2),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0),
            child: makeBigger(IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()));
              },
              icon: const Icon(Icons.settings),
              color: Colors.yellow,
              tooltip: 'Settings',
            )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: _buildListOfNotes(notesProvider)),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Transform.scale(
          scale: 1.2, // Increase the size
          child: FloatingActionButton(
            tooltip: 'Add a Note',
            onPressed: !_isSelectMode
                ? addNote
                : () async {
                    await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: const Text('Delete selected notes?'),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      (() async {
                                        List<Note> targets = selectedNoteIndexes.map((int i)=>notesProvider.notes[i]).toList();
                                        for (Note note in targets) {
                                          notesProvider.deleteNote(note);
                                        }
                                      })()
                                          .then((res) {
                                        toggleSelectMode();
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Text('Delete')),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'))
                              ],
                            ));
                  },
            backgroundColor: Colors.yellow,
            child: Icon(_isSelectMode ? Icons.delete : Icons.edit_note_sharp,
                color: const Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
