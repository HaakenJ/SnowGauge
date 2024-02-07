import 'package:flutter/material.dart';
import 'history_page.dart'; // Import the history page
import 'package:geolocator/geolocator.dart';

class RecordActivityPage extends StatefulWidget {
  const RecordActivityPage({super.key});

  @override
  _RecordActivityPageState createState() => _RecordActivityPageState();
}

class _RecordActivityPageState extends State<RecordActivityPage> {
  bool isRecording = false;
  bool isPaused = false;
  List<String> recordingData = []; // here I used simple data structure to store recording data
  GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Activity'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Add our record activity  here
            Text(
              isRecording ? (isPaused ? 'Paused' : 'Recording...') : 'Not Recording',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Toggle recording status
                setState(() {
                  if (!isRecording) {
                    // Start recording
                    isRecording = true;
                    isPaused = false;
                  } else {
                    // Pause recording
                    isPaused = !isPaused;
                  }
                });
              },
              child: Text(
                isRecording ? (isPaused ? 'Resume' : 'Pause') : 'Start Recording',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Stop recording
                setState(() {
                  isRecording = false;
                  isPaused = false;
                });

                // Show save or discard prompt
                _showSaveDiscardPrompt();
              },
              child: const Text('Stop Recording'),
            ),
            // GridView.count(
            //   primary: false,
            //   crossAxisCount: 2,
            //   crossAxisSpacing: 5,
            //   mainAxisSpacing: 5,
            //   scrollDirection: Axis.vertical,
            //   shrinkWrap: true,
            //   padding: const EdgeInsets.all(20),
            //   children: <Widget>[
            //     Container(
            //       alignment: Alignment.center,
            //       padding: const EdgeInsets.all(8),
            //       color: Colors.teal[100],
            //       child: Text(
            //         "Altitude \n\n ${currentPosition?.altitude ?? 0.0}",
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //     Container(
            //       alignment: Alignment.center,
            //       padding: const EdgeInsets.all(8),
            //       color: Colors.teal[100],
            //       child: const Text("Number of Runs"),
            //     ),
            //     Container(
            //       alignment: Alignment.center,
            //       padding: const EdgeInsets.all(8),
            //       color: Colors.teal[100],
            //       child: Text(
            //         "Latitude \n\n ${currentPosition?.latitude ?? 0.0}",
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //     Container(
            //       alignment: Alignment.center,
            //       padding: const EdgeInsets.all(8),
            //       color: Colors.teal[100],
            //       child: Text(
            //         "Longitude \n\n ${currentPosition?.longitude ?? 0.0}",
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //     Container(
            //       alignment: Alignment.center,
            //       padding: const EdgeInsets.all(8),
            //       color: Colors.teal[100],
            //       child: Text(
            //         "Current Speed \n\n ${currentPosition?.speed ?? 0.0}",
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //     Container(
            //       alignment: Alignment.center,
            //       padding: const EdgeInsets.all(8),
            //       color: Colors.teal[100],
            //       child: const Text("Maximum Speed"),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  // Function to show the save or discard prompt
  void _showSaveDiscardPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Recording?'),
          content: const Text('Do you want to save or discard the recording?'),
          actions: [
            TextButton(
              onPressed: () {
                // Handle discard action
                Navigator.pop(context);
                _showConfirmation('Recording Discarded!');
              },
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                // Handle save action
                Navigator.pop(context);
                _saveRecordingData();
                _navigateToHistoryPage();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to get the current location data
  Future<void> _getLocation() async {
    LocationPermission permission = await geolocator.requestPermission();

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
        setState(() {
          currentPosition = position;
        });
      });
    }
  }

  // Function to save recording data
  void _saveRecordingData() {

    recordingData.add('Date: ${DateTime.now()}');
    // Add more data if needed
  }

  // Function to navigate to the history page
  void _navigateToHistoryPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryPage(data: recordingData),
      ),
    );
  }

  // Function to show the confirmation message
  void _showConfirmation(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                // Handling OK action and navigate to another page
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
