import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class NoteForm extends StatefulWidget {
  const NoteForm({Key? key, this.noteData}) : super(key: key);
  final Map<String, dynamic>? noteData;

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  late TextEditingController _titleController;
  late TextEditingController _textController;
  bool isListening = false;
  bool _speechToTextEnabled = false;
  SpeechToText speechToText = SpeechToText();
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.noteData?['title'] ?? "");
    _textController =
        TextEditingController(text: widget.noteData?['text'] ?? "");
    _initTts();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      return image.path;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      isListening = true;
      _textController.text += result.recognizedWords;
    });
  }

  _initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.awaitSpeakCompletion(true);
    var engine = await flutterTts.getDefaultEngine;
    var voice = await flutterTts.getDefaultVoice;
  }

  Future _speak(String text) async {
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(0.5);
    var result = await flutterTts.speak(text);
    await _stop();
  }

  Future _stop() async {
    var result = await flutterTts.stop();
  }

  void listenToSpeech(BuildContext context) {
    if (_speechToTextEnabled) {
      if (!isListening) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                const Text('Listening'),
                const SizedBox(width: 0.5),
                JumpingDots(
                  color: Colors.black38,
                  radius: 5,
                  numberOfDots: 3,
                  animationDuration: const Duration(milliseconds: 200),
                )
              ],
            ),
            backgroundColor: const Color(0xFFFFEB3B)));
        speechToText.listen(onResult: onSpeechResult);
      } else {
        speechToText.stop();
        setState(() {
          isListening = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Stopped Listening')));
      }
    } else {
      speechToText.initialize().then((value) {
        if (value == true) {
          setState(() {
            _speechToTextEnabled = value;
          });
          listenToSpeech(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'Speech to text is not enabled on this device. Please try again later.')));
        }
      }, onError: (stackTrace) {
        debugPrint('Error initializing speech to text: $stackTrace');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Notes',
              style: TextStyle(color: Colors.yellow),
            ),
            iconTheme: const IconThemeData(color: Colors.yellow), // Set back arrow color
            actions: [
              IconButton(
                onPressed: () async {
                  var imagePath = await pickImageFromGallery();
                  String text = await FlutterTesseractOcr.extractText(imagePath);
                  _textController.text += text;
                },
                icon: const Icon(
                  Icons.document_scanner_outlined,
                  color: Colors.yellow,
                ),
              ),
              IconButton(
                onPressed: () {
                  listenToSpeech(context);
                },
                icon: const Icon(
                  Icons.mic,
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleController,
                    maxLines: 1,
                    minLines: 1,
                    contextMenuBuilder: (context, editableTextState) {
                      return AdaptiveTextSelectionToolbar.buttonItems(
                        anchors: editableTextState.contextMenuAnchors,
                        buttonItems: <ContextMenuButtonItem>[
                          ContextMenuButtonItem(
                            onPressed: () {
                              editableTextState
                                  .copySelection(SelectionChangedCause.toolbar);
                            },
                            type: ContextMenuButtonType.copy,
                          ),
                          ContextMenuButtonItem(
                              onPressed: () {
                                editableTextState
                                    .pasteText(SelectionChangedCause.toolbar);
                              },
                              type: ContextMenuButtonType.paste
                          ),
                          ContextMenuButtonItem(
                            onPressed: () {
                              editableTextState
                                  .selectAll(SelectionChangedCause.toolbar);
                            },
                            type: ContextMenuButtonType.selectAll,
                          ),
                          ContextMenuButtonItem(
                            label: 'Text to Speech',
                            onPressed: () {
                              _speak(_textController.text);
                            },
                          ),
                        ],
                      );
                    },
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(color: Colors.yellow),
                    ),
                  ),
                  const SizedBox(
                      height: 8), // Added spacing between title and text fields
                  TextField(
                    controller: _textController,
                    maxLines: 15,
                    minLines: 1,
                    contextMenuBuilder: (context, editableTextState) {
                      return AdaptiveTextSelectionToolbar.buttonItems(
                        anchors: editableTextState.contextMenuAnchors,
                        buttonItems: <ContextMenuButtonItem>[
                          ContextMenuButtonItem(
                            onPressed: () {
                              editableTextState
                                  .copySelection(SelectionChangedCause.toolbar);
                            },
                            type: ContextMenuButtonType.copy,
                          ),
                          ContextMenuButtonItem(
                              onPressed: () {
                                editableTextState
                                    .pasteText(SelectionChangedCause.toolbar);
                              },
                              type: ContextMenuButtonType.paste
                          ),
                          ContextMenuButtonItem(
                            onPressed: () {
                              editableTextState
                                  .selectAll(SelectionChangedCause.toolbar);
                            },
                            type: ContextMenuButtonType.selectAll,
                          ),
                          ContextMenuButtonItem(
                            label: 'Text to Speech',
                            onPressed: () {
                              _speak(_textController.text);
                            },
                          ),
                        ],
                      );
                    },
                    decoration: const InputDecoration(
                      labelText: 'Text',
                      labelStyle: TextStyle(color: Colors.yellow),
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context, {
                ...widget.noteData ?? {},
                'title': _titleController.text,
                'text': _textController.text,
              });
            },
            backgroundColor: Colors.yellow, // Set button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Set button border radius
            ),
            child: const Icon(Icons.save),
          ),
        ),
        onWillPop: () async {
          Navigator.pop(context, {
            ...widget.noteData ??
                {}, // Append the prefilled data from the widget
            'title': _titleController.text,
            'text': _textController.text,
          });
          return true;
        }
    );
  }
}
