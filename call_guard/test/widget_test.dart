import 'package:flutter_test/flutter_test.dart';
import 'package:call_guard/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CallGuardApp());

    // Verify that the navigation exists
    expect(find.byType(CallGuardApp), findsOneWidget);
  });
}
