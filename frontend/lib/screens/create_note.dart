import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// TODO:
/// Implement text to speech
/// Cleanup UI

class NoteForm extends StatefulWidget {
  const NoteForm({Key? key, this.noteData}) : super(key: key);
  final Map<String, dynamic>? noteData;

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  late TextEditingController _titleController;
  late TextEditingController _textController;
  File? image;
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

  // Pick images from platform specific gallery
  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      return image.path;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  // Populate note content with speech
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

  // speak TTS
  Future _speak(String text) async {
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(0.5);
    // await flutterTts.setPitch(1);
    var result = await flutterTts.speak(text);
    await _stop();
  }

  // stop TTS
  Future _stop() async {
    var result = await flutterTts.stop();
  }

  /*
    * Listen to speech and append to text field
    * If speech to text is not enabled, enable it and recurse
    * If speech to text is enabled, listen to speech
  */
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
            backgroundColor: const Color.fromRGBO(249, 207, 88, 100)));
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Note'),
        actions: [
          IconButton(
              onPressed: () {
                listenToSpeech(context);
              },
              icon: const Icon(Icons.mic)),
          IconButton(
              onPressed: () async {
                var imagePath = await pickImageFromGallery();
                String text = await FlutterTesseractOcr.extractText(imagePath);
                _textController.text += text;
              },
              icon: const Icon(Icons.document_scanner_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              contextMenuBuilder: (context, editableTextState) {
                return AdaptiveTextSelectionToolbar.buttonItems(
                  anchors: editableTextState.contextMenuAnchors,
                  buttonItems: <ContextMenuButtonItem>[
                    ContextMenuButtonItem(
                        label: 'Text to Speech',
                        onPressed: () {
                          _speak(_textController.text);
                        }),
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
                            .selectAll(SelectionChangedCause.toolbar);
                      },
                      type: ContextMenuButtonType.selectAll,
                    ),
                  ],
                );
              },
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: _textController,
              contextMenuBuilder: (context, editableTextState) {
                return AdaptiveTextSelectionToolbar.buttonItems(
                  anchors: editableTextState.contextMenuAnchors,
                  buttonItems: <ContextMenuButtonItem>[
                    ContextMenuButtonItem(
                        label: 'Text to Speech',
                        onPressed: () {
                          _speak(_textController.text);
                        }),
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
                            .selectAll(SelectionChangedCause.toolbar);
                      },
                      type: ContextMenuButtonType.selectAll,
                    ),
                  ],
                );
              },
              decoration: const InputDecoration(
                labelText: 'Text',
              ),
              keyboardType: TextInputType.multiline,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  ...widget.noteData ??
                      {}, // Append the prefilled data from the widget
                  'title': _titleController.text,
                  'text': _textController.text,
                });
              },
              child: const Text('Add Note'),
            ),
          ],
        ),
      ),
    );
  }
}
