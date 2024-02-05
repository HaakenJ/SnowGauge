import 'package:flutter/material.dart';
import 'history_page.dart'; // Import the history page

class RecordActivityPage extends StatefulWidget {
  const RecordActivityPage({super.key});

  @override
  _RecordActivityPageState createState() => _RecordActivityPageState();
}

class _RecordActivityPageState extends State<RecordActivityPage> {
  bool isRecording = false;
  bool isPaused = false;
  List<String> recordingData = []; // here I used simple data structure to store recording data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Activity'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add our record activity  here
            Text(
              isRecording ? (isPaused ? 'Paused' : 'Recording...') : 'Not Recording',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 10),
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
              child: Text('Stop Recording'),
            ),
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
          title: Text('Save Recording?'),
          content: Text('Do you want to save or discard the recording?'),
          actions: [
            TextButton(
              onPressed: () {
                // Handle discard action
                Navigator.pop(context);
                _showConfirmation('Recording Discarded!');
              },
              child: Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                // Handle save action
                Navigator.pop(context);
                _saveRecordingData();
                _navigateToHistoryPage();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
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
          title: Text('Confirmation'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                // Handling OK action and navigate to another page
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
