import 'package:flutter_test/flutter_test.dart';
import 'package:quizzical_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const QuizzicalApp());
    expect(find.text('Quizzical'), findsOneWidget);
  });
}