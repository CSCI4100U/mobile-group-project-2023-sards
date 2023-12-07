import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kanjou/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('visit screens', () {
    testWidgets('visit each screen',
            (tester) async {
          // Load app widget.
          await tester.pumpWidget(const MyApp());

          // Find button to create note
          final createNote = find.byTooltip('Add a Note');

          // Emulate a tap on the floating action button.
          await tester.tap(createNote);

          // Trigger a frame.
          await tester.pumpAndSettle();

          // Go back
          await tester.pageBack();

          await tester.pumpAndSettle();

          final exit = find.byKey(const Key("Yes"));

          await tester.tap(exit);

          await tester.pumpAndSettle();

          // Verify the counter increments by 1.
          expect(find.text('The note was not saved'), findsOneWidget);
        });
  });
}