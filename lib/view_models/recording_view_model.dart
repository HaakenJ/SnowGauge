import 'package:SnowGauge/dao/recording_dao.dart';
import 'package:SnowGauge/utilities/id_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import '../entities/recording_entity.dart';

/*
  Class to contain logic for interacting with the recording dao
 */
class RecordingViewModel extends ChangeNotifier {
  bool isRecording = false;
  bool isPaused = false;

  // ELEVATION VARIABLES
  bool _isGoingDown = false;
  int _downStartTime = 0;
  double currentElevation = 0.0;
  final int _runTimeInterval = 60000; // the number of milliseconds between descent and ascent before logging a run
  double maximumElevation = 0.0;
  double minimumElevation = 100000.00;

  // SPEED/DISTANCE VARIABLES
  double maxSpeed = 0.0;
  Position? previousPosition;
  DateTime? previousTime;

  // TIME VARIABLES
  int totalTime = 0;

  // User's prior recordings
  List<Recording> recordingHistory = [];

  bool permissionGranted = false;
  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;
  late Position currentPosition;
  late Recording record;
  late RecordingDao _recordingDao;

  final FirebaseAuth auth = FirebaseAuth.instance;

  RecordingViewModel() {
    // final currentUser = auth.currentUser;
    // if (currentUser != null) {
    //   _userId = currentUser.uid;
    // }
    _recordingDao = GetIt.instance.get<RecordingDao>();
    initializeRecording();
    watchRecordings();
  }

  void initializeRecording() {
    String userId;
    if (auth.currentUser != null) {
      userId = auth.currentUser!.uid;
    } else {
      userId = IdGenerator.generateId().toString();
    }
    // initialize a new recording
    record = Recording(
        IdGenerator.generateId(),  // id
        userId,                    // userId
        DateTime.now(),            // recordingDate
        0,                         // numberOfRuns
        0.0,                       // maxSpeed
        0.0,                       // averageSpeed
        0.0,                       // totalDistance
        0.0,                       // totalVertical
        0,                         // maxElevation
        0,                         // minElevation
        0                          // duration
    );
    previousTime = DateTime.now();
    previousPosition = null;
  }

  Future<void> requestPermission() async {
    LocationPermission permission = await _geolocator.requestPermission();

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      permissionGranted = true;
    } else {
      permissionGranted = false;
    }
    notifyListeners();
  }

  void startRecording() {
    isRecording = true;
    initializeRecording();

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0, // number of meters the user must move to update location
    );

    // set the date of the recording
    record.recordingDate = DateTime.now();

    _geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      if (isRecording && !isPaused) {
        currentPosition = position;
        _updateElevation(position);
        _updateSpeed(position);
        print('Current info: number runs: ${record.numberOfRuns}\n'
            'max speed: ${record.maxSpeed}\n'
            'average speed: ${record.averageSpeed}\n'
            'total distance: ${record.totalDistance}\n'
            'total descent: ${record.totalVertical}\n'
            'total time: ${record.duration}');
      } else if (isRecording && isPaused) {
        previousTime = DateTime.now();
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void stopRecording() {
    isRecording = false;
    notifyListeners();
  }

  void togglePause() {
    if (isPaused) {
      isPaused = false;
    } else {
      isPaused = true;
    }
    notifyListeners();
  }

  void discardRecording() {
    initializeRecording();
    notifyListeners();
  }

  void saveRecording() {
    _recordingDao.insertRecording(record);
    print('Record saved: \n'
        'number runs: ${record.numberOfRuns}\n'
        'max speed: ${record.maxSpeed}\n'
        'average speed: ${record.averageSpeed}\n'
        'total distance: ${record.totalDistance}\n'
        'total descent: ${record.totalVertical}');
    initializeRecording();
    notifyListeners();
  }

  void _updateElevation(Position pos) {
    double newElevation = pos.altitude; // altitude is in meters

    if (newElevation < currentElevation) { // check if the user is going downhill
      if (!_isGoingDown) { // check if they were already going downhill,
        _isGoingDown = true; // flag that they are descending
        _downStartTime = DateTime.now().millisecondsSinceEpoch; // log the time they started the descent
      }
      record.totalVertical += currentElevation - newElevation; // update total elevation descended
    } else { // the user is ascending
      if (_isGoingDown) { // were they descending before this?
        int downDuration = DateTime.now().millisecondsSinceEpoch - _downStartTime; // how long they were descending before the ascent
        if (downDuration > _runTimeInterval) {
          record.numberOfRuns++; // user descended long enough to count as a run
        }
        _isGoingDown = false; // mark that the user is now ascending
      }
    }
    currentElevation = newElevation;

    // update max and min elevation
    if (currentElevation > maximumElevation) {
      maximumElevation = currentElevation;
      record.maxElevation = maximumElevation;
    }
    if (currentElevation < minimumElevation) {
      minimumElevation = currentElevation;
      record.minElevation = minimumElevation;
    }
    notifyListeners();
  }

  void _updateSpeed(Position pos) {
    double speed = pos.speed ?? 0; // speed is in meters per second

    // update max speed
    if (speed > maxSpeed) {
      maxSpeed = speed;
      record.maxSpeed = maxSpeed;
    }

    // update total distance and time
    if (previousPosition != null && previousTime != null) {
      double distance = Geolocator.distanceBetween(
          previousPosition!.latitude,
          previousPosition!.longitude,
          pos.latitude,
          pos.longitude
      );
      record.totalDistance += distance;
      record.duration += pos.timestamp.difference(previousPosition!.timestamp).inSeconds;
    }
    previousPosition = pos;
    previousTime = previousPosition!.timestamp;

    // update average speed
    record.averageSpeed = record.duration > 0 ? record.totalDistance / record.duration : 0.0;
    notifyListeners();
  }

  void watchRecordings() {
    if (auth.currentUser != null) {
      String userId = auth.currentUser!.uid;
      _recordingDao.watchRecordingById(userId).listen((recordings) {
        recordingHistory = recordings;
        notifyListeners();
      });
    }
  }

}