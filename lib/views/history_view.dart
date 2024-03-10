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
          title: const Text('Record Activity'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You must be signed in to use this feature',
              style: TextStyle(fontSize: 18),
              )
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


  // Widget _buildRecordItem(Recording record, String userName) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Card(
  //       elevation: 4,
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'User: $userName',
  //               style: const TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 8),
  //             _buildRecordInfo('Recording Date', record.recordingDate as String),
  //             _buildRecordInfo('Number of Runs', record.numberOfRuns.toString()),
  //             _buildRecordInfo('Max Speed', '${record.maxSpeed} km/h'),
  //
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildRecordInfo(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       children: [
  //         Text(
  //           '$label: ',
  //           style: const TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         Text(value),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildRecordItem(Recording record, String userName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        // elevation: 4,
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
