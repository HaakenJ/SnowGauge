import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SnowGauge/views/history_view.dart';

void main() {
  group('HistoryView Widget Test', () {
    testWidgets('HistoryView displays list of historical records correctly', (WidgetTester tester) async {
      // Prepare some sample data
      List<String> testData = ['Record 1', 'Record 2', 'Record 3'];

      // Build our widget and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: HistoryView(data: testData),
      ));

      // Verify that the app bar title is 'History'
      expect(find.text('History'), findsOneWidget);

      // Verify that the list view contains the correct number of items
      expect(find.byType(ListTile), findsNWidgets(testData.length));

      // Verify that the list view displays the correct data
      for (String record in testData) {
        expect(find.text(record), findsOneWidget);
      }
    });
  });
}


//  verify that the app bar title is 'History'.
// verify that the list view contains the correct number of items based on the sample data length.
//  verify that each item in the sample data is displayed in the list view.