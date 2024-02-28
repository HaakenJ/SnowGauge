// //  set up a mock for the Position class to simulate position data.
// //  mock the GeolocatorPlatform instance and set up a stream of mock positions.
// //  call the startRecording method of RecordingViewModel.
// // verify that isRecording is set to true and that the _updateElevation and _updateSpeed methods are called with the expected arguments.
// // in the end stop the recording.
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:SnowGauge/view_models/recording_view_model.dart';
// import 'package:geolocator/geolocator.dart';
//
// // Mock GeolocatorPlatform class for testing
// class MockGeolocatorPlatform extends Mock implements GeolocatorPlatform {}
//
// void main() {
//   group('RecordingViewModel Test', ()
//   {
//     late RecordingViewModel recordingViewModel;
//     late MockGeolocatorPlatform mockGeolocator;
//
//     setUp(() {
//       recordingViewModel = RecordingViewModel();
//       mockGeolocator = MockGeolocatorPlatform();
//       // Set mockGeolocator to the _geolocator field directly for testing
//       recordingViewModel._geolocator = mockGeolocator;
//     });
//
//     test('Test startRecording method', () async {
//       // Set up mock position data
//       final mockPosition = Position(
//         latitude: 0.0,
//         longitude: 0.0,
//         altitude: 100.0,
//         speed: 10.0,
//         accuracy: 0.0,
//         heading: 0.0,
//         speedAccuracy: 0.0,
//         timestamp: DateTime.now(),
//         altitudeAccuracy: 0.0,
//         headingAccuracy: 0.0,
//       );
//
//       // Set up stream of mock positions
//       final mockStream = Stream<Position>.fromIterable([mockPosition]);
//       when(mockGeolocator.getPositionStream(locationSettings: any)).thenAnswer((_) => mockStream);
//
//       // Call startRecording method
//       recordingViewModel.startRecording(1);
//
//       // Verify that isRecording is set to true
//       expect(recordingViewModel.isRecording, true);
//
//       // Delay to ensure method calls
//       await Future.delayed(Duration(seconds: 1));
//
//       // Verify that _updateElevation and _updateSpeed methods are called
//       expect(recordingViewModel.currentElevation, equals(100.0));
//       expect(recordingViewModel.maxSpeed, equals(10.0));
//
//       // Stop recording
//       recordingViewModel.stopRecording();
//     });
//   });
//
// }

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:SnowGauge/view_models/recording_view_model.dart';
import 'package:geolocator/geolocator.dart';

// Mock GeolocatorPlatform class for testing
class MockGeolocatorPlatform extends Mock implements GeolocatorPlatform {}

void main() {
  group('RecordingViewModel Test', () {
    late RecordingViewModel recordingViewModel;
    late MockGeolocatorPlatform mockGeolocator;

    setUp(() {
      mockGeolocator = MockGeolocatorPlatform();
      recordingViewModel = RecordingViewModel();
    });

    test('Test startRecording method', () async {
      // Set up mock position data
      final mockPosition = Position(
        latitude: 0.0,
        longitude: 0.0,
        altitude: 100.0,
        speed: 10.0,
        accuracy: 0.0,
        heading: 0.0,
        speedAccuracy: 0.0,
        timestamp: DateTime.now(),
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );

      // Set up stream of mock positions
      final mockStream = Stream<Position>.fromIterable([mockPosition]);
      when(mockGeolocator.getPositionStream(locationSettings: any)).thenAnswer((_) => mockStream);

      // Inject the mock geolocator
      recordingViewModel = RecordingViewModel();
      //recordingViewModel._geolocator = mockGeolocator;



      // Call startRecording method
      recordingViewModel.startRecording(1);

      // Verify that isRecording is set to true
      expect(recordingViewModel.isRecording, true);

      // Delay to ensure method calls
      await Future.delayed(Duration(seconds: 1));

      // Verify that _updateElevation and _updateSpeed methods are called
      expect(recordingViewModel.currentElevation, equals(100.0));
      expect(recordingViewModel.maxSpeed, equals(10.0));

      // Stop recording
      recordingViewModel.stopRecording();
    });


  });
}
