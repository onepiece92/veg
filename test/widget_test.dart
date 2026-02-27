import 'package:flutter_test/flutter_test.dart';
import 'package:bakery_flutter/main.dart';

void main() {
  testWidgets('Bakery app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BakeryApp());
    expect(find.byType(BakeryApp), findsOneWidget);
  });
}
