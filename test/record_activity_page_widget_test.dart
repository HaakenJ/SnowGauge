import 'package:flutter_test/flutter_test.dart';
// import 'package:test/test.dart';
import 'package:SnowGauge/main.dart';

void main() {
  testWidgets('Test AppBar', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // check AppBar
    expect(find.text('Record Activity'), findsOneWidget);

    // check text widget describing inital state
    expect(find.text('Not Recording'), findsOneWidget);
    // check that start recording button is displayed
    expect(find.text('Start Recording'), findsOneWidget);

    // tap start recording button and rebuild
    await tester.tap(find.text('Start Recording'));
    await tester.pump();

    // check text widget displays new text
    expect(find.text('Recording...'), findsOneWidget);
    // check that button displays new text
    expect(find.text('Pause'), findsOneWidget);

    // tap pause recording button and rebuild
    await tester.tap(find.text('Pause'));
    await tester.pump();

    // check text widget displays new text
    expect(find.text('Paused'), findsOneWidget);
    // check that button displays new text
    expect(find.text('Resume'), findsOneWidget);

    // tap resume recording button and rebuild
    await tester.tap(find.text('Resume'));
    await tester.pump();

    // check text widget goes back to recording text
    expect(find.text('Recording...'), findsOneWidget);
    // check that button goes back to pause text
    expect(find.text('Pause'), findsOneWidget);

    // check that stop recording button is displayed
    expect(find.text('Stop Recording'), findsOneWidget);

    // tap the stop recording button
    await tester.tap(find.text('Stop Recording'));
    await tester.pump();

    // check that dialog with text widget pops up
    expect(find.text('Save Recording?'), findsOneWidget);
    // check that content of the dialog is displayed
    expect(find.text('Do you want to save or discard the recording?'), findsOneWidget);
    // check that discard button is displayed
    expect(find.text('Discard'), findsOneWidget);
    // check that save button is displayed
    expect(find.text('Save'), findsOneWidget);

    // tap the discard button
    await tester.tap(find.text('Discard'));
    await tester.pump();

    // check that the confirmation text dialog pops up
    expect(find.text('Confirmation'), findsOneWidget);
    // check that the description is displayed
    expect(find.text('Recording Discarded!'), findsOneWidget);
    // check that ok button is displayed
    expect(find.text('OK'), findsOneWidget);

    // tap the OK button
    await tester.tap(find.text('OK'));
    await tester.pump();

    // check that stop recording button is displayed
    expect(find.text('Stop Recording'), findsOneWidget);

    // check text widget describing inital state
    expect(find.text('Not Recording'), findsOneWidget);
    // check that start recording button is displayed
    expect(find.text('Start Recording'), findsOneWidget);

    // tap start recording button and rebuild
    await tester.tap(find.text('Start Recording'));
    await tester.pump();

    // check text widget displays new text
    expect(find.text('Recording...'), findsOneWidget);

    // tap the stop recording button
    await tester.tap(find.text('Stop Recording'));
    await tester.pump();

    // check that the save button is displayed
    expect(find.text('Save'), findsOneWidget);

    // tap the save button
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // check that the history page is displayed
    expect(find.text('History'), findsOneWidget);
  });
}