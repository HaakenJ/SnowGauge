import 'package:SnowGauge/entities/recording_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/recording_view_model.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recordingProvider = Provider.of<RecordingViewModel>(context);
    final FirebaseAuth auth = FirebaseAuth.instance;
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
          title: const Text('History'),
        ),
        body: ListView.builder(
          itemCount: recordingProvider.recordingHistory.length,
          itemBuilder: (context, index) {
            final record = recordingProvider.recordingHistory[index];
            return _buildRecordItem(record, auth.currentUser!.email!);
          },
        ),
      );
    }
  }

  Widget _buildRecordItem(Recording record, String userName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        child: ListTile(
          title: Text('User: $userName'),
          tileColor: Colors.teal[100],
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recording Date: ${record.recordingDate}'),
              Text('Number of Runs: ${record.numberOfRuns}'),
              Text('Max Speed: ${record.maxSpeed}'),
              Text('Average Speed: ${record.averageSpeed}'),
              Text('Total Distance: ${record.totalDistance}'),
              Text('Total Vertical: ${record.totalVertical}'),
              Text('Max Elevation: ${record.maxElevation}'),
              Text('Min Elevation: ${record.minElevation}'),
              Text('Duration: ${record.duration}'),
            ],
          ),
        ),
      ),
    );
  }
}
