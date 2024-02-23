import 'dart:math';

import 'package:SnowGauge/dao/recording_dao.dart';
import 'package:SnowGauge/utilities/id_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

import '../entities/recording_entity.dart';
import '../entities/user_entity.dart';


/*
  Class to contain logic for interacting with the recording dao
 */
class RecordingViewModel extends ChangeNotifier {
  bool isRecording = false;

  // ELEVATION VARIABLES
  bool _isGoingDown = false;
  int _downStartTime = 0;
  double currentElevation = 0.0;
  // the number of milliseconds between descent and ascent before logging a run
  final int _runTimeInterval = 60000;
  double maximumElevation = 0.0;
  double minimumElevation = 100000.00;

  // SPEED/DISTANCE VARIABLES
  double maxSpeed = 0.0;
  Position? previousPosition;

  // TIME VARIABLES
  int totalTime = 0;

  bool permissionGranted = false;
  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;
  late Position _currentPosition;
  late Recording record;
  late RecordingDao recordingDao;
  int userId;

  RecordingViewModel(this.userId) {
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
    recordingDao = GetIt.instance.get<RecordingDao>();
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
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );

    // set the date of the recording
    record.recordingDate = DateTime.now();

    _geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      _currentPosition = position;
      _updateElevation(position);
      _updateSpeed(position);
    });
  }

  void stopRecording() {
    isRecording = false;
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
  }

  void _updateSpeed(Position pos) {
    double speed = pos.speed ?? 0; // speed is in meters per second

    // update max speed
    if (speed > maxSpeed) {
      maxSpeed = speed;
      record.maxSpeed = maxSpeed;
    }

    // update total distance and time
    if (previousPosition != null) {
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

    // update average speed
    record.averageSpeed = record.duration > 0 ? record.totalDistance / record.duration : 0.0;
  }

  void saveRecord() {

  }
}