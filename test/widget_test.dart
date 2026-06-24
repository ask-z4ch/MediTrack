import 'package:flutter_test/flutter_test.dart';

import 'package:meditrack/app.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MediTrackApp());
    expect(find.text('MediTrack'), findsOneWidget);
  });
}
