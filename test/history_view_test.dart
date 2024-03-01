import 'package:SnowGauge/dao/recording_dao.dart';
import 'package:SnowGauge/dao/user_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:SnowGauge/views/history_view.dart';
import 'package:SnowGauge/view_models/recording_view_model.dart';
import 'package:SnowGauge/view_models/user_view_model.dart';
import 'package:SnowGauge/entities/recording_entity.dart';
import 'package:SnowGauge/entities/user_entity.dart';

class MockRecordingDao extends Mock implements RecordingDao {}
class MockUserDao extends Mock implements UserDao {}

void main() {
  group('HistoryView', () {
    late RecordingViewModel recordingViewModel;
    late UserViewModel userViewModel;

    setUp(() {
      final recordingDao = MockRecordingDao();
      final userDao = MockUserDao();
      GetIt.instance.registerSingleton<RecordingDao>(recordingDao);
      GetIt.instance.registerSingleton<UserDao>(userDao);
      recordingViewModel = RecordingViewModel(1234);
      userViewModel = UserViewModel();
    });

    testWidgets('should initialize current user', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: recordingViewModel),
            ChangeNotifierProvider.value(value: userViewModel),
          ],
          child: MaterialApp(
            home: HistoryView(),
          ),
        ),
      );

      expect(userViewModel.currentUser, isNotNull);
    });

    testWidgets('should build record items with correct information', (tester) async {
      final recording1 = Recording(
        12345,
        1234,
        DateTime.now(),
        5,
        30,
        20,
        500,
        100,
        2000,
        1500,
        123456,
      );

      final recording2 = Recording(
        123456,
        1234,
        DateTime.now(),
        53,
        31,
        22,
        530,
        110,
        2400,
        1500,
        123456,
      );

      recordingViewModel.recordingHistory = [recording1, recording2];
      userViewModel.currentUserName = 'Test User';

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: recordingViewModel),
            ChangeNotifierProvider.value(value: userViewModel),
          ],
          child: MaterialApp(
            home: HistoryView(),
          ),
        ),
      );

      expect(find.text('User: Test User'), findsNWidgets(2));
      expect(find.text('Recording Date: ${recording1.recordingDate}'), findsOneWidget);
      expect(find.text('Number of Runs: ${recording1.numberOfRuns}'), findsOneWidget);
      expect(find.text('Max Speed: ${recording1.maxSpeed}'), findsOneWidget);
      expect(find.text('Average Speed: ${recording1.averageSpeed}'), findsOneWidget);
      expect(find.text('Total Distance: ${recording1.totalDistance}'), findsOneWidget);
      expect(find.text('Total Vertical: ${recording1.totalVertical}'), findsOneWidget);
      expect(find.text('Max Elevation: ${recording1.maxElevation}'), findsOneWidget);
      expect(find.text('Min Elevation: ${recording1.minElevation}'), findsOneWidget);
      expect(find.text('Duration: ${recording1.duration}'), findsOneWidget);
      expect(find.text('Recording Date: ${recording2.recordingDate}'), findsOneWidget);
      expect(find.text('Number of Runs: ${recording2.numberOfRuns}'), findsOneWidget);
      expect(find.text('Max Speed: ${recording2.maxSpeed}'), findsOneWidget);
      expect(find.text('Average Speed: ${recording2.averageSpeed}'), findsOneWidget);
      expect(find.text('Total Distance: ${recording2.totalDistance}'), findsOneWidget);
      expect(find.text('Total Vertical: ${recording2.totalVertical}'), findsOneWidget);
      expect(find.text('Max Elevation: ${recording2.maxElevation}'), findsOneWidget);
      expect(find.text('Min Elevation: ${recording2.minElevation}'), findsOneWidget);
      expect(find.text('Duration: ${recording2.duration}'), findsOneWidget);
    });
  });
}
