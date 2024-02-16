import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<String> data;

  const HistoryPage({super.key,  this.data = const []});

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
