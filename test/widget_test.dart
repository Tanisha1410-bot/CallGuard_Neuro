import 'package:flutter_test/flutter_test.dart';
import 'package:callguard/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CallGuardApp());

    // Verify that the app starts.
    expect(find.byType(CallGuardApp), findsOneWidget);
  });
}
