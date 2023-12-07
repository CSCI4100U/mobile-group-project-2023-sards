import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanjou/screens/create_note.dart';

void main() {
  testWidgets('NoteForm has passed title and text', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const NoteForm(noteData: {"title": "testing","text": {"insert": "Sad"}},));

    // Create the Finders.
    final titleFinder = find.text('testing');
    final messageFinder = find.text('Sad');

    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });
}