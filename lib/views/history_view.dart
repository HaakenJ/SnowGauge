import 'package:SnowGauge/entities/recording_entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entities/user_entity.dart';
import '../view_models/recording_view_model.dart';
import '../view_models/user_view_model.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late User _currentUser;

  @override
  void initState() {
    _currentUser = Provider.of<UserViewModel>(context, listen: false).currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recordingProvider = Provider.of<RecordingViewModel>(context);
    final userProvider = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: ListView.builder(
        itemCount: recordingProvider.recordingHistory.length,
        itemBuilder: (context, index) {
          final record = recordingProvider.recordingHistory[index];
          return _buildRecordItem(record, userProvider.currentUserName);
        },
      ),
    );
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
