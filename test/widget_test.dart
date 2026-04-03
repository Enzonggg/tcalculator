import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_300/main.dart';

void main() {
  testWidgets('Tip Time shows header and inputs', (WidgetTester tester) async {
    await tester.pumpWidget(const TipTimeApp());

    expect(find.text('Tip Time'), findsOneWidget);
    expect(find.text('Calculate tip'), findsOneWidget);
    expect(find.text('Bill amount'), findsOneWidget);
    expect(find.text('Round up tip?'), findsOneWidget);
  });
}
