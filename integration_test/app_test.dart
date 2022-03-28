import 'package:dev_framework_tutorial/src/features/links/data/links_model.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/links_helper.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/add_edit/links_item_add_edit_page.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/add_edit/links_item_add_edit_view.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/links_page.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/show/links_item_show_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:dev_framework_tutorial/src/common/etc/itg_text.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/app/app.dart';
import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/features/home/home_page.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/notes_helper.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/notes_item_add_edit_page.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/notes_item_add_edit_view.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/notes_page.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/show/notes_item_show_page.dart';

import '../test/common/test_helper.dart';

const useDelays = false;
const msgBaseSourceClass = 'app_test';
String msgBaseSourceMethod = '';
void msgLogInfo(String msg) => itgLogVerbose('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');
void msgLogPrint(String msg) => itgLogPrint('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');

const NotesModel dataNotes1 = NotesModel(
  description: 'My New Note',
  content: 'This is the content for my new note...',
);
const NotesModel dataNotes2 = NotesModel(
  description: 'My Edited New Note',
  content: 'This is the edited content for my new note...',
);
const NotesModel dataNotes3 = NotesModel(
  description: 'My Double Edited New Note',
  content: 'This is the double edited content for my new note...',
);
const LinksModel dataLinks1 = LinksModel(
  description: 'My New link',
  notes: 'This is the notes for my new link...',
);

// TODO: Refactor - The tests here are depended - The next needs the previous to have run successfully...
// TODO: Refactor - If the new data is outside of the visible area it must bu scrolled down in order for the tests to work...
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const sampleDescription = 'new description';

  group('end-to-end test', () {
    setUp(() async {
      await initializeAppForTesting();
    });

    testWidgets('show home page', (WidgetTester widgetTester) async {
      await widgetTester.pumpWidget(const App());
      await widgetTester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text(appTitleFull), findsOneWidget);
      expect(find.text(textHomePageWelcomeMessage1), findsOneWidget);
      expect(find.text(textHomePageWelcomeMessage2), findsNothing);
      expect(find.byKey(keyButtonNotesPage), findsOneWidget);
      expect(find.byKey(keyButtonLinksPage), findsOneWidget);

      if (useDelays) await Future.delayed(const Duration(seconds: 2));
    }, skip: false);

    testWidgets('add a new note', (WidgetTester widgetTester) async {
      msgBaseSourceMethod = 'add a new note';
      msgLogInfo('start........\n');

      await widgetTester.pumpWidget(const App());
      await widgetTester.pumpAndSettle();

      await widgetTester.testNavigateToPage<NotesPage>(keyButtonNotesPage);

      // await scrollToTheEndOfList(widgetTester);
      expect(find.text(sampleDescription), findsNothing);

      msgLogInfo('add a new item...');
      await widgetTester.testNavigateToPage<NotesItemAddEditPage>(Key('$keyNotesWidgetListItemBase-$keyFloatingActionAdd'));
      await widgetTester.enterText(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-description')), dataNotes1.description);
      await widgetTester.enterText(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-content')), dataNotes1.content);
      await widgetTester.testNavigateToPage<NotesPage>(keyButtonSaveItemAddEditPage);
      msgLogInfo('saved the new item...');

      // await widgetTester.pageBack();
      await widgetTester.pumpAndSettle();
      expect(find.byType(NotesItemShowPage), findsNothing);
      expect(find.byType(NotesItemAddEditPage), findsNothing);
      expect(find.byType(NotesItemAddEditView), findsNothing);
      expect(find.byType(NotesPage), findsOneWidget);

      expect(find.byType(LinksItemShowPage), findsNothing);
      expect(find.byType(LinksItemAddEditPage), findsNothing);
      expect(find.byType(LinksItemAddEditView), findsNothing);
      expect(find.byType(LinksPage), findsNothing);

      // await scrollToTheEndOfList(widgetTester);

      expect(find.text(dataNotes1.description), findsOneWidget);

      msgLogInfo('end........\n');
    }, skip: false);

    testWidgets('add a new link', (WidgetTester widgetTester) async {
      msgBaseSourceMethod = 'add a new link';
      msgLogInfo('start........\n');

      await widgetTester.pumpWidget(const App());
      await widgetTester.pumpAndSettle();

      await widgetTester.testNavigateToPage<LinksPage>(keyButtonLinksPage);

      // await scrollToTheEndOfList(widgetTester);
      expect(find.text(sampleDescription), findsNothing);
      expect(find.text(dataNotes1.description), findsNothing);

      msgLogInfo('add a new item...');
      await widgetTester.testNavigateToPage<LinksItemAddEditPage>(Key('$keyLinksWidgetListItemBase-$keyFloatingActionAdd'));
      await widgetTester.enterText(find.byKey(const Key('$keyLinksWidgetItemAddEditBase-col1-description')), dataLinks1.description);
      await widgetTester.enterText(find.byKey(const Key('$keyLinksWidgetItemAddEditBase-col1-notes')), dataLinks1.notes);
      await widgetTester.testNavigateToPage<LinksPage>(keyButtonSaveItemAddEditPage);
      msgLogInfo('saved the new item...');

      // await widgetTester.pageBack();
      await widgetTester.pumpAndSettle();
      expect(find.byType(LinksItemShowPage), findsNothing);
      expect(find.byType(LinksItemAddEditPage), findsNothing);
      expect(find.byType(LinksItemAddEditView), findsNothing);
      expect(find.byType(LinksPage), findsOneWidget);

      expect(find.byType(NotesItemShowPage), findsNothing);
      expect(find.byType(NotesItemAddEditPage), findsNothing);
      expect(find.byType(NotesItemAddEditView), findsNothing);
      expect(find.byType(NotesPage), findsNothing);

      // await scrollToTheEndOfList(widgetTester);

      expect(find.text(dataLinks1.description), findsOneWidget);

      msgLogInfo('end........\n');
    }, skip: false);

    testWidgets('show and edit the new note', (WidgetTester widgetTester) async {
      msgBaseSourceMethod = 'show and edit the new note';
      msgLogInfo('start........\n');

      await widgetTester.pumpWidget(const App());

      await widgetTester.testNavigateToPage<NotesPage>(keyButtonNotesPage);
      msgLogInfo('------>>> items list page........\n');
      expect(find.byKey(keyTextError), findsNothing);

      msgLogInfo('------>>> before enter item show page........\n');
      await widgetTester.testNavigateToPageByText<NotesItemShowPage>(dataNotes1.description);

      msgLogInfo('------>>> item show page........\n');
      expect(find.byType(NotesItemShowPage), findsOneWidget);
      expect(find.byKey(const Key('$keyNotesWidgetItemShowBase-col1-id')), findsOneWidget);
      final itemId = widgetTester.widget<ItgTextWithLabel>(find.byKey(const Key('$keyNotesWidgetItemShowBase-col1-id'))).text;
      // final itemId = widgetTester.widget<Text>(find.byKey(const Key('$keyNotesWidgetItemShowBase-col1-id'))).data;
      msgLogInfo('>>>>>>> itemId: $itemId');

      msgLogInfo('------>>> before enter item edit page........\n');
      await widgetTester.testNavigateToPage<NotesItemAddEditPage>(Key('$keyNotesWidgetItemShowBase-$keyFloatingActionEdit'));
      msgLogInfo('------>>> item edit page........\n');
      expect(find.byType(NotesItemAddEditPage), findsOneWidget);
      expect(find.byType(NotesItemAddEditView), findsOneWidget);
      expect(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-description')), findsOneWidget);
      expect(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-content')), findsOneWidget);

      msgLogInfo('------>>> before enter field values in edit page........\n  data.description: ${dataNotes2.description}\n');
      await widgetTester.tapOnWidget(const Key('$keyNotesWidgetItemAddEditBase-col1-description'));
      await widgetTester.enterText(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-description')), dataNotes2.description);
      await widgetTester.tapOnWidget(const Key('$keyNotesWidgetItemAddEditBase-col1-content'));
      await widgetTester.enterText(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-content')), dataNotes2.content);
      msgLogInfo('------>>> before save item in edit page........\n');
      if (useDelays) await Future.delayed(const Duration(seconds: 2));
      await widgetTester.tapOnWidget(keyButtonSaveItemAddEditPage);

      msgLogInfo('------>>> item show page (returned)........\n');
      if (useDelays) await Future.delayed(const Duration(seconds: 2));
      expect(find.byKey(keyNotificationFailure), findsNothing);
      expect(find.byKey(keyNotificationSuccess), findsOneWidget);
      expect(find.byType(NotesItemShowPage), findsOneWidget);
      expect(find.text(dataNotes1.description), findsNothing);
      expect(find.text(dataNotes1.content), findsNothing);
      await widgetTester.testWidgetText(dataNotes2.description, const Key('$keyNotesWidgetItemShowBase-col1-description'));
      await widgetTester.testWidgetText(dataNotes2.content, const Key('$keyNotesWidgetItemShowBase-col1-content'));

      if (useDelays) await Future.delayed(const Duration(seconds: 2));
      msgLogInfo('------>>> before return back to items list page........\n');
      await widgetTester.tap(find.byTooltip('Close'));
      await widgetTester.pumpAndSettle();
      msgLogInfo('------>>> items list page (returned)........\n');
      expect(find.byType(NotesItemShowPage), findsNothing);
      expect(find.byType(NotesPage), findsOneWidget);
      // await scrollToTheEndOfList(widgetTester);
      msgLogInfo('------>>> items list page - scrolled to the end........\n');

      if (useDelays) await Future.delayed(const Duration(seconds: 2));
      expect(find.text(dataNotes1.description), findsNothing);
      expect(find.text(dataNotes1.content), findsNothing);
      await widgetTester.testWidgetText(dataNotes2.description, Key('$keyNotesWidgetListItemBase-$itemId-title'));
      await widgetTester.testWidgetText(dataNotes2.content, Key('$keyNotesWidgetListItemBase-$itemId-content'));

      msgLogInfo('------>>> before enter item edit page (2nd time)........\n');
      await widgetTester.testNavigateToPage<NotesItemAddEditPage>(Key('$keyNotesWidgetListItemBase-$itemId-action-edit'));
      msgLogInfo('------>>> item edit page........\n');
      expect(find.byType(NotesItemAddEditPage), findsOneWidget);
      expect(find.byType(NotesItemAddEditView), findsOneWidget);
      expect(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-description')), findsOneWidget);
      expect(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-content')), findsOneWidget);

      msgLogInfo('------>>> before enter field values in edit page (2nd time)........\n  data.description: ${dataNotes3.description}\n');
      await widgetTester.tapOnWidget(const Key('$keyNotesWidgetItemAddEditBase-col1-description'));
      await widgetTester.enterText(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-description')), dataNotes3.description);
      await widgetTester.tapOnWidget(const Key('$keyNotesWidgetItemAddEditBase-col1-content'));
      await widgetTester.enterText(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-content')), dataNotes3.content);
      msgLogInfo('------>>> before save item in edit page (2nd time)........\n');
      if (useDelays) await Future.delayed(const Duration(seconds: 2));
      await widgetTester.tapOnWidget(keyButtonSaveItemAddEditPage);

      msgLogInfo('------>>> items list page (returned 2nd time)........\n');
      expect(find.byType(NotesItemShowPage), findsNothing);
      expect(find.byType(NotesPage), findsOneWidget);
      // await scrollToTheEndOfList(widgetTester);
      msgLogInfo('------>>> items list page - scrolled to the end........\n');

      if (useDelays) await Future.delayed(const Duration(seconds: 2));
      expect(find.text(dataNotes1.description), findsNothing);
      expect(find.text(dataNotes1.content), findsNothing);
      expect(find.text(dataNotes2.description), findsNothing);
      expect(find.text(dataNotes2.content), findsNothing);
      await widgetTester.testWidgetText(dataNotes3.description, Key('$keyNotesWidgetListItemBase-$itemId-title'));
      await widgetTester.testWidgetText(dataNotes3.content, Key('$keyNotesWidgetListItemBase-$itemId-content'));

      msgLogInfo('end........\n');
    }, skip: false);

    testWidgets('show and delete the new note', (WidgetTester widgetTester) async {
      msgBaseSourceMethod = 'show and delete the new note';
      msgLogInfo('start........\n');

      await widgetTester.pumpWidget(const App());
      await widgetTester.pumpAndSettle();

      await widgetTester.testNavigateToPage<NotesPage>(keyButtonNotesPage);
      await widgetTester.pumpAndSettle();
      expect(find.byKey(keyTextError), findsNothing);
      // await scrollToTheEndOfList(widgetTester);

      await widgetTester.testNavigateToPageByText<NotesItemShowPage>(dataNotes3.description);
      expect(find.byType(NotesItemShowPage), findsOneWidget);
      await widgetTester.tapOnWidget(Key('$keyNotesWidgetItemShowBase-$keyFloatingActionDelete'));
      await widgetTester.tapOnWidgetByText('OK', waitToSettle: true);
      if (useDelays) await Future.delayed(const Duration(seconds: 2));

      expect(find.byKey(keyNotificationSuccess), findsOneWidget);
      expect(find.byKey(keyNotificationFailure), findsNothing);
      expect(find.byType(NotesItemShowPage), findsNothing);
      expect(find.byType(NotesPage), findsOneWidget);
      if (useDelays) await Future.delayed(const Duration(seconds: 2));

      // await scrollToTheEndOfList(widgetTester);
      expect(find.text(dataNotes3.description), findsNothing);
      expect(find.text(dataNotes3.content), findsNothing);
      if (useDelays) await Future.delayed(const Duration(seconds: 2));

      msgLogInfo('end........\n');
    }, skip: false);

    testWidgets('delete the first note', (WidgetTester widgetTester) async {
      final data = itemsNotesSample().first;

      msgBaseSourceMethod = 'delete the first note';
      msgLogInfo('start........\n');

      await widgetTester.pumpWidget(const App());
      await widgetTester.pumpAndSettle();

      await widgetTester.testNavigateToPage<NotesPage>(keyButtonNotesPage);
      await widgetTester.pumpAndSettle();
      expect(find.byKey(keyTextError), findsNothing);
      // await scrollToTheEndOfList(widgetTester);

      await widgetTester.testWidgetText(data.description, Key('$keyNotesWidgetListItemBase-${data.id}-title'));
      await widgetTester.testWidgetText(data.content, Key('$keyNotesWidgetListItemBase-${data.id}-content'));

      await widgetTester.tapOnWidget(Key('$keyNotesWidgetListItemBase-${data.id}-action-delete'));
      await widgetTester.tapOnWidgetByText('OK', waitToSettle: true);
      if (useDelays) await Future.delayed(const Duration(seconds: 2));

      expect(find.byKey(keyNotificationSuccess), findsOneWidget);
      expect(find.byKey(keyNotificationFailure), findsNothing);
      expect(find.byType(NotesItemShowPage), findsNothing);
      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(NotesPage), findsOneWidget);

      // await scrollToTheEndOfList(widgetTester);
      expect(find.text(data.description), findsNothing);
      expect(find.text(data.content), findsNothing);
      if (useDelays) await Future.delayed(const Duration(seconds: 2));

      msgLogInfo('end........\n');
    }, skip: false);
  });
}
