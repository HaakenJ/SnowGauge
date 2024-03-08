import 'package:SnowGauge/entities/user_entity.dart';
import 'package:SnowGauge/view_models/recording_view_model.dart';
import 'package:SnowGauge/view_models/user_view_model.dart';
import 'package:SnowGauge/views/recording_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

class MockRecordingViewModel extends Mock implements RecordingViewModel {}

class MockUserViewModel extends Mock implements UserViewModel {}

void main() {
  late MockRecordingViewModel mockRecordingViewModel;
  late MockUserViewModel mockUserViewModel;

  setUp(() {
    mockRecordingViewModel = MockRecordingViewModel();
    mockUserViewModel = MockUserViewModel();
  });

  Widget buildTestableWidget(Widget widget) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecordingViewModel>.value(
          value: mockRecordingViewModel,
        ),
        ChangeNotifierProvider<UserViewModel>(
          create: (_) => mockUserViewModel,
        ),
      ],
      child: MaterialApp(home: widget),
    );
  }

  testWidgets('RecordActivityView UI Test', (WidgetTester tester) async {
    when(mockUserViewModel.currentUser).thenReturn(User(0, 'Bob', 'bob@bob.com', '123456'));
    // Build our widget and trigger a frame.
    await tester.pumpWidget(buildTestableWidget(RecordActivityView()));

    // Verify that our Text widgets are displaying the correct text.
    expect(find.text('Not Recording'), findsOneWidget);
    expect(find.text('Start Recording'), findsOneWidget);

    // Simulate tapping on the start recording button
    await tester.tap(find.text('Start Recording'));
    verify(mockRecordingViewModel.requestPermission());
    verify(mockRecordingViewModel.startRecording());

    // Simulate tapping on the stop recording button
    await tester.tap(find.text('Stop Recording'));
    verify(mockRecordingViewModel.stopRecording());
    verify(mockRecordingViewModel.discardRecording());

    // Simulate tapping on the save recording button
    await tester.tap(find.text('Save'));
    verify(mockRecordingViewModel.saveRecording());

    // Verify that the save or discard prompt is shown
    expect(find.text('Save Recording?'), findsOneWidget);
    expect(find.text('Do you want to save or discard the recording?'), findsOneWidget);
  });
}
