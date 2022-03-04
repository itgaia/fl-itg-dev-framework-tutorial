import 'package:dev_framework_tutorial/src/app/app.dart';
import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/features/home/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    setUp(() async {
      await initializeApp(forTesting: true);
    });

    testWidgets('show home page', (WidgetTester widgetTester) async {
      await widgetTester.pumpWidget(const App());
      await widgetTester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text(appTitleFull), findsOneWidget);
      expect(find.text(textHomePageWelcomeMessage1), findsOneWidget);
      expect(find.text(textHomePageWelcomeMessage2), findsNothing);

      // wait a few seconds in order to see the page before the test complete and close the app
      await Future.delayed(const Duration(seconds: 5));
    });
  });
}
