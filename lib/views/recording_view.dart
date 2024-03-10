import 'package:SnowGauge/view_models/recording_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordActivityView extends StatefulWidget {
  final FirebaseAuth auth;
  const RecordActivityView({super.key, required this.auth});

  @override
  _RecordActivityViewState createState() => _RecordActivityViewState();
}

class _RecordActivityViewState extends State<RecordActivityView> {


  @override
  Widget build(BuildContext context) {
    final recordingProvider = Provider.of<RecordingViewModel>(context);
    // final FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseAuth auth = widget.auth;


    if (auth.currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Record Activity'),
        ),
        body: const Center(
          child: Column(
            children: [
              Text('You must be signed in to use this feature')
            ],
          ),
        ),
      );
    } else {
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
                  recordingProvider.isRecording ? (recordingProvider
                      .isPaused
                      ? 'Paused'
                      : 'Recording...') : 'Not Recording',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                ElevatedButton( // play/pause button
                  onPressed: () async {
                    // Toggle recording status
                    if (!recordingProvider.isRecording) {
                      if (!recordingProvider.permissionGranted) {
                        await recordingProvider.requestPermission();
                      }

                      if (recordingProvider.permissionGranted) {
                        recordingProvider.startRecording();
                      }
                    } else {
                      // pause/resume recording as it is already recording
                      recordingProvider.togglePause();
                    }
                    setState(() {

                    });
                  },
                  child: Text(
                    recordingProvider.isRecording
                        ? (recordingProvider
                        .isPaused ? 'Resume' : 'Pause')
                        : 'Start Recording',
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Stop recording
                    setState(() {
                      recordingProvider.stopRecording();
                    });

                    // Show save or discard prompt
                    _showSaveDiscardPrompt(recordingProvider);
                  },
                  child: const Text('Stop Recording'),
                ),
                Expanded(
                    child: Consumer<RecordingViewModel>(
                        builder: (context, recordingProvider, _) {
                          return GridView.count(
                            primary: false,
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(20),
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[100],
                                child: Text(
                                  "Duration \n\n ${recordingProvider.record
                                      .duration}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[100],
                                child: Text(
                                  "Number of Runs \n\n ${recordingProvider
                                      .record
                                      .numberOfRuns}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[100],
                                child: Text(
                                  "Total Distance \n\n ${recordingProvider
                                      .record
                                      .totalDistance}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[100],
                                child: Text(
                                  "Total Descent \n\n ${recordingProvider.record
                                      .totalVertical}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[100],
                                child: Text(
                                  "Max speed \n\n ${recordingProvider.record
                                      .maxSpeed}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[100],
                                child: Text(
                                  "Average Speed \n\n ${recordingProvider.record
                                      .averageSpeed}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          );
                        })
                )
              ],
            ),
          )
      );
    }
  }

  // Function to show the save or discard prompt
  void _showSaveDiscardPrompt(RecordingViewModel model) {
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
                model.discardRecording();
                _showConfirmation('Recording Discarded!');
              },
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                // Handle save action
                Navigator.pop(context);
                model.saveRecording();
                // _saveRecordingData();
                // _navigateToHistoryPage();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
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
