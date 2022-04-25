import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:file_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('home test', () {
    testWidgets('initial categories are shown', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      expect(find.text('video'), findsOneWidget);
      expect(find.text('audio'), findsOneWidget);
      expect(find.text('image'), findsOneWidget);
    });

    testWidgets('tap on category and move to the category list',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      expect(find.text('video'), findsOneWidget);

      await tester.tap(find.text('video'));

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('listing_title_video')), findsOneWidget);
    });
  });
}
