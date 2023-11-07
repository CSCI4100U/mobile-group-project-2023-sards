import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

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


  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.noteData?['title'] ?? "");
    _textController = TextEditingController(text: widget.noteData?['text'] ?? "");
    _initSpeech();
  }

  void _initSpeech() async  {
    _speechToTextEnabled = await speechToText.initialize(); // init stt only once per app session
    setState(() {});
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
      if(image == null) return;
      return image.path;
    } on PlatformException catch(e) {
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

  final micOnSnackbar = const SnackBar(
    content: Text('Listening'),
    
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Note'),
        actions: [
          IconButton(
            onPressed: () {
              if(_speechToTextEnabled) {
                if(!isListening) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Row(
                            children: [
                              const Text('Listening'),
                              const SizedBox(width: 0.5),
                              JumpingDots(color: Colors.black38,
                              radius: 5,
                              numberOfDots: 3,
                              animationDuration: const Duration(milliseconds: 200),
                              )
                            ],
                          ),
                      backgroundColor: const Color.fromRGBO(249, 207, 88, 100)
                      )
                  );
                  speechToText.listen(
                    onResult: onSpeechResult
                  );
                }
                else {
                  speechToText.stop();
                  setState(() {
                    isListening = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stopped Listening')));
                }
              }
            },
            icon: const Icon(Icons.mic)
          ),
          IconButton(
            onPressed: () async {
             var imagePath = await pickImageFromGallery();
             String text = await FlutterTesseractOcr.extractText(imagePath);
              _textController.text += text;
            },
            icon: const Icon(Icons.document_scanner_outlined)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Text',
              ),
              keyboardType: TextInputType.multiline,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  ...widget.noteData ?? {}, // Append the prefilled data from the widget
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