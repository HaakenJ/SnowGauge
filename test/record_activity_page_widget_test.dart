import 'package:flutter_test/flutter_test.dart';
// import 'package:test/test.dart';
import 'package:SnowGauge/record_activity_page.dart';
import 'package:SnowGauge/main.dart';

void main() {
  testWidgets('Test suite for record_activity_page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Record Activity'), findsOneWidget);
  });
}