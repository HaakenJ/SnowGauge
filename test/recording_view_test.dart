import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:SnowGauge/views/recording_view.dart';
import 'package:SnowGauge/view_models/recording_view_model.dart';
import 'package:SnowGauge/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class MockRecordingViewModel extends Mock implements RecordingViewModel {}

class MockUserViewModel extends Mock implements UserViewModel {}

void main() {
  group('RecordActivityView Widget Test', () {
    late MockRecordingViewModel mockRecordingViewModel;
    late MockUserViewModel mockUserViewModel;

    setUp(() {
      mockRecordingViewModel = MockRecordingViewModel();
      mockUserViewModel = MockUserViewModel();
    });

    testWidgets('RecordActivityView renders correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockRecordingViewModel,
            child: ChangeNotifierProvider.value(
              value: mockUserViewModel,
              child: RecordActivityView(),
            ),
          ),
        ),
      );

      // Verify that the app bar title is 'Record Activity'
      expect(find.text('Record Activity'), findsOneWidget);

      // Verify that the text widget displays the correct initial status
      expect(find.text('Not Recording'), findsOneWidget);

      // Verify that the start recording button is present
      expect(find.text('Start Recording'), findsOneWidget);

      // Verify that the stop recording button is present
      expect(find.text('Stop Recording'), findsOneWidget);
    });

    testWidgets('Start recording button starts recording', (WidgetTester tester) async {
      // Mock the necessary method calls
      when(mockRecordingViewModel.isRecording).thenReturn(false);
      when(mockRecordingViewModel.permissionGranted).thenReturn(true);

      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockRecordingViewModel,
            child: ChangeNotifierProvider.value(
              value: mockUserViewModel,
              child: RecordActivityView(),
            ),
          ),
        ),
      );

      // Tap the start recording button
      await tester.tap(find.text('Start Recording'));
      await tester.pump();

      // Verify that the recording has started
      verify(mockRecordingViewModel.startRecording(any as dynamic)).called(1);
    });


    testWidgets('Stop recording button stops recording and shows prompt', (WidgetTester tester) async {
      // Mock the necessary method calls
      when(mockRecordingViewModel.isRecording).thenReturn(true);

      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockRecordingViewModel,
            child: ChangeNotifierProvider.value(
              value: mockUserViewModel,
              child: RecordActivityView(),
            ),
          ),
        ),
      );

      // Tap the stop recording button
      await tester.tap(find.text('Stop Recording'));
      await tester.pump();

      // Verify that the recording has stopped
      verify(mockRecordingViewModel.stopRecording()).called(1);

      // Verify that the save/discard prompt is shown
      expect(find.text('Save Recording?'), findsOneWidget);
    });


  });
}


// create mock instances of RecordingViewModel and UserViewModel using Mockito.
// wrote separate test cases to verify the rendering of the widget, interaction with the start and stop recording buttons, and the display of the save/discard prompt.
// Inside each test case, mock the necessary method calls and interactions, such as startRecording, stopRecording, and permission checks.
