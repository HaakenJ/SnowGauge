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
  late final List<String> recordings;
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
        itemCount: recordings.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recordings[index]),
          );
        },
      ),
    );
  }
}
