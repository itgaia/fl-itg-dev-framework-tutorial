import 'package:dev_framework_tutorial/src/features/notes/domain/notes_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/show/notes_item_screen.dart';
import 'package:dev_framework_tutorial/src/features/settings/settings_service.dart';

import '../../../../common/test_helper.dart';
import '../../notes_test_helper.dart';

void main() {
  setUp(() async {
    itgLogVerbose('Notes Item Page test - SetUp - Start...');
    await initializeAppForTesting();
    sl<SettingsService>().appMainPage = NotesItemScreen(data: notesTestData().first);
  });

  group('NotesItemScreen', () {
    testWidgets('CCIS page class', (widgetTester) async {
      await widgetTester.testWidgetPageClass<NotesItemScreen>();
    });

    testWidgets('CCIS render Note fields', (WidgetTester widgetTester) async {
      // List<NotesModel> data = notesTestData();
      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      expect(find.byKey(const Key('$keyNotesWidgetItemShowBase-col1-id')), findsOneWidget);
      expect(find.byKey(const Key('$keyNotesWidgetItemShowBase-col1-description')), findsOneWidget);
      expect(find.byKey(const Key('$keyNotesWidgetItemShowBase-col1-content')), findsOneWidget);
    });
  });
}