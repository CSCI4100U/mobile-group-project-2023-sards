import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteForm extends StatefulWidget {
  const NoteForm({Key? key, this.noteData}) : super(key: key);
  final Map<String, dynamic>? noteData;

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  late TextEditingController _titleController;
  late TextEditingController _textController;
  final QuillController _quillController = QuillController.basic();
  bool isListening = false;
  bool _speechToTextEnabled = false;
  SpeechToText speechToText = SpeechToText();
  FlutterTts flutterTts = FlutterTts();
  //late TextStyle _textStyle;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.noteData?['title'] ?? "");
    _textController =
        TextEditingController(text: widget.noteData?['text'] ?? "");
    _initTts();
    //_textStyle = TextStyle(); // Initialize with default style
  }

  void applyFormatting({bool bold = false, bool italic = false}) {
    final currentSelection = _textController.selection;
    final currentText = _textController.text;
    final selectedText = currentSelection.textInside(currentText);

    final formattedText = bold
        ? selectedText
        : italic
            ? '*$selectedText*'
            : selectedText;

    final newText = currentText.replaceRange(
      currentSelection.start,
      currentSelection.end,
      formattedText,
    );

    setState(() {
      _textController.text = newText;
      _textController.selection = TextSelection.collapsed(
        offset: currentSelection.start + formattedText.length,
      );
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      return image.path;
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
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
                const Text(
                  'Listening',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(width: 0.5),
                JumpingDots(
                  color: Colors.black,
                  radius: 5,
                  numberOfDots: 3,
                  animationDuration: const Duration(milliseconds: 200),
                )
              ],
            ),
            backgroundColor: const Color(0xFFE7D434)));
        speechToText.listen(onResult: onSpeechResult);
      } else {
        speechToText.stop();
        setState(() {
          isListening = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Stopped Listening',
                style: TextStyle(color: Colors.black))));
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
                  'Speech to text is not enabled on this device. Please try again later.',
                  style: TextStyle(color: Colors.black))));
        }
      }, onError: (stackTrace) {
        debugPrint('Error initializing speech to text: $stackTrace');
      });
    }
  }

  Widget buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey[200], // Background color of the toolbar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.format_bold),
            onPressed: () {
              // Apply bold formatting to the selected text
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_italic),
            onPressed: () {
              // Apply italic formatting to the selected text
            },
          ),
          // Add more buttons for other formatting options as needed
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          final NavigatorState navigator = Navigator.of(context);
          bool? willPop = await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('Leave without saving changes?'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Yes')),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('No'))
                    ],
                  ));
          if (willPop ?? false) {
            navigator.pop();
          }
          // Navigator.pop(context, {
          //   ...widget.noteData ??
          //       {}, // Append the prefilled data from the widget
          //   'title': _titleController.text,
          //   'text': _textController.text,
          // });
          // return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: TextField(
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
                        type: ContextMenuButtonType.paste),
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
                  hintText: 'Write a title here...',
                  border: InputBorder.none),
            ),
            iconTheme: const IconThemeData(color: Color(0xFFE7D434)),
            actions: [
              IconButton(
                onPressed: () async {
                  var imagePath = await pickImageFromGallery();
                  String text =
                      await FlutterTesseractOcr.extractText(imagePath);
                  _textController.text += text;
                },
                icon: const Icon(
                  Icons.document_scanner_outlined,
                  color: Color(0xFFE7D434),
                ),
              ),
              IconButton(
                onPressed: () {
                  listenToSpeech(context);
                },
                icon: const Icon(
                  Icons.mic,
                  color: Color(0xFFE7D434),
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
                  QuillProvider(
                      configurations: QuillConfigurations(
                        controller: _quillController,
                        sharedConfigurations: const QuillSharedConfigurations(
                          locale: Locale('en'),
                        ),
                      ),
                      //buildToolbar(),
                      //SizedBox(height: 8),
                      child: Column(
                        children: [
                          const SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                QuillToolbar(),
                              ],
                            ),
                          ),
                          QuillEditor(
                            configurations: const QuillEditorConfigurations(
                              readOnly: false,
                              expands: false,
                              padding: EdgeInsets.all(8),
                              placeholder: 'Write your note here...',
                              autoFocus: false,
                            ),
                            focusNode: FocusNode(),
                            scrollController: ScrollController(),
                          ),
                          // TextField(
                          //   controller: _textController,
                          //   maxLines: 30,
                          //   minLines: 1,
                          //   contextMenuBuilder: (context, editableTextState) {
                          //     return AdaptiveTextSelectionToolbar.buttonItems(
                          //       anchors: editableTextState.contextMenuAnchors,
                          //       buttonItems: <ContextMenuButtonItem>[
                          //         ContextMenuButtonItem(
                          //           onPressed: () {
                          //             editableTextState
                          //                 .copySelection(SelectionChangedCause.toolbar);
                          //           },
                          //           type: ContextMenuButtonType.copy,
                          //         ),
                          //         ContextMenuButtonItem(
                          //             onPressed: () {
                          //               editableTextState
                          //                   .pasteText(SelectionChangedCause.toolbar);
                          //             },
                          //             type: ContextMenuButtonType.paste),
                          //         ContextMenuButtonItem(
                          //           onPressed: () {
                          //             editableTextState
                          //                 .selectAll(SelectionChangedCause.toolbar);
                          //           },
                          //           type: ContextMenuButtonType.selectAll,
                          //         ),
                          //         ContextMenuButtonItem(
                          //           label: 'Text to Speech',
                          //           onPressed: () {
                          //             _speak(_textController.text);
                          //           },
                          //         ),
                          //       ],
                          //     );
                          //   },
                          //   decoration: const InputDecoration(
                          //     hintText: 'Write your note here...',
                          //       border: InputBorder.none
                          //   ),
                          //   keyboardType: TextInputType.multiline,
                          // ),
                        ],
                      )),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Navigator.pop(context, {
                ...widget.noteData ?? {},
                'title': _titleController.text,
                'text': _textController.text,
              });
            },
            backgroundColor: Color(0xFFE7D434), // Set button color
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10), // Set button border radius
            ),
            child: const Icon(Icons.save),
          ),
        ));
  }
}
