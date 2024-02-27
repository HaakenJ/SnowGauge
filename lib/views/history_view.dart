import 'package:flutter/material.dart';

class HistoryView extends StatelessWidget {
  final List<String> data;
  // create a list of the historical records for the current user
  // from the userProvider watch a stream of the records
  // when state is updated use list tiles to display the records

  const HistoryView({super.key,  this.data = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(data[index]),
          );
        },
      ),
    );
  }
}
