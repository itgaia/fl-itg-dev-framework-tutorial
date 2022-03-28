import 'package:dev_framework_tutorial/src/app/app.dart';
import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/features/home/home_page.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/links_helper.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/links_page.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/notes_helper.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/notes_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../common/test_helper.dart';

void main() {
  setUp(() async {
    await initializeAppForTesting();
  });

  group('Home page widget tests', () {
    test('correct route name', () {
      expect(HomePage.routeName, '/');
    });

    testWidgets('page class', (widgetTester) async {
      await widgetTester.testWidgetPageClass<HomePage>();
    });

    testWidgets('page title', (widgetTester) async {
      await widgetTester.testWidgetPageTitle(appTitleFull);
    });

    testWidgets('welcome messages', (widgetTester) async {
      await widgetTester.testWidgetText(textHomePageWelcomeMessage1, keyTextHomePageWelcomeMessage1);
      // await widgetTester.testWidgetText(textHomePageWelcomeMessage2, keyTextHomePageWelcomeMessage2);
    });

    testWidgets('Links button', (widgetTester) async {
      await widgetTester.pumpWidget(const App());
      await widgetTester.pumpAndSettle();
      await widgetTester.pump();
      await widgetTester.testNavigateToPage<LinksPage>(keyButtonLinksPage);
      await widgetTester.pumpAndSettle();
      await widgetTester.pump();
    });

    // TODO: the second check for button fails... why?
    testWidgets('Notes button', (widgetTester) async {
      await widgetTester.pumpWidget(const App());
      await widgetTester.pumpAndSettle();
      await widgetTester.pump();
      await widgetTester.testNavigateToPage<NotesPage>(keyButtonNotesPage);
      await widgetTester.pumpAndSettle();
      await widgetTester.pump();
    }, skip: true);

    testWidgets("dark theme", (WidgetTester widgetTester) async {
      await widgetTester.testWidgetTheme(brightness: Brightness.dark);
    }, skip: true);

    testWidgets("light theme", (WidgetTester widgetTester) async {
      await widgetTester.testWidgetTheme(brightness: Brightness.light);
    }, skip: true);
  });
}