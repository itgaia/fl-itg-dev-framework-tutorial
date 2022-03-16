import 'package:bloc_test/bloc_test.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/notes_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/bloc/notes_item_add_edit_bloc.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/notes_item_add_edit_view.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/notes_item_add_edit_page.dart';
import 'package:dev_framework_tutorial/src/features/settings/settings_service.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../../common/app_test_helper.dart';
import '../../../../common/test_helper.dart';
import '../../notes_test_helper.dart';

void main() {
  final NotesModel tItem = notesTestData().first;
  late MockNavigator mockNavigator;
  late NotesItemAddEditBloc mockNotesItemAddEditBloc;

  setUpAll(() {
    registerFallbackValue(FakeNotesItemAddEditState());
    registerFallbackValue(FakeNotesItemAddEditEvent());
  });

  setUp(() async {
    itgLogVerbose('Notes Item Add/Edit Page test - SetUp - Start...');
    mockNavigator = MockNavigator();
    when(() => mockNavigator.push(any())).thenAnswer((_) async => null);

    mockNotesItemAddEditBloc = MockNotesItemAddEditBloc();
    when(() => mockNotesItemAddEditBloc.state).thenReturn(
      NotesItemAddEditState(
        initialData: tItem,
        description: tItem.description,
        content: tItem.content
      )
    );

    await initializeAppForTesting();
    sl<SettingsService>().appMainPage = MockNavigatorProvider(
      navigator: mockNavigator,
      child: BlocProvider.value(
        value: mockNotesItemAddEditBloc,   // TODO: why is this not working?
        // value: sl<NotesItemAddEditBloc>(),
        child: const NotesItemAddEditPage(action: ItemAddEditAction.add),
      ),
    );

  });

  group('Notes Item Add/Edit page tests', () {
    test('CCIAEP correct route name', () {
      expect(NotesItemAddEditPage.routeName, '/notes_item_add_edit');
    });

    testWidgets('CCIAEP page class', (widgetTester) async {
      await widgetTester.testWidgetPageClass<NotesItemAddEditPage>();
      expect(find.byType(NotesItemAddEditView), findsOneWidget);
    });

    testWidgets('CCIAEP page title', (widgetTester) async {
      await widgetTester.testWidgetPageTitle(appTitleNotesItemAddPage);
    });

    testWidgets('CCIAEP do not show floating actions', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();

      expect(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-floating-actions')), findsNothing);
      expect(find.byKey(Key('$keyNotesWidgetItemAddEditBase-$keyFloatingActionRefresh')), findsNothing);
      expect(find.byKey(Key('$keyNotesWidgetItemAddEditBase-$keyFloatingActionAdd')), findsNothing);
      expect(find.byKey(Key('$keyNotesWidgetItemAddEditBase-$keyFloatingActionEdit')), findsNothing);
      expect(find.byKey(Key('$keyNotesWidgetItemAddEditBase-$keyFloatingActionDuplicate')), findsNothing);
      expect(find.byKey(Key('$keyNotesWidgetItemAddEditBase-$keyFloatingActionDelete')), findsNothing);

      // TODO: How can I test for the correct tooltip?
      // expect(find.text('Refresh Notes...'), findsOneWidget);
      // expect(find.text('Refresh Notes'), findsOneWidget);
    });
  });

  group('NotesItemAddEditPage', () {
    Widget buildSubject() {
      return MockNavigatorProvider(
        navigator: mockNavigator,
        child: BlocProvider.value(
          value: mockNotesItemAddEditBloc,
          child: const NotesItemAddEditPage(action: ItemAddEditAction.add),
        ),
      );
    }

    group('CCIAEP route', () {
      testWidgets('CCIAEP renders page', (tester) async {
        await tester.pumpRoute(NotesItemAddEditPage.route(action: ItemAddEditAction.add));
        expect(find.byType(NotesItemAddEditPage), findsOneWidget);
      });

      testWidgets('CCIAEP supports providing initial data', (tester) async {
        await tester.pumpRoute(
          NotesItemAddEditPage.route(
            action: ItemAddEditAction.add,
            initialData: const NotesModel(
              id: 'initial-id',
              description: 'initial',
            ),
          ),
        );
        expect(find.byType(NotesItemAddEditPage), findsOneWidget);
        expect(
          find.byWidgetPredicate((w) => w is EditableText && w.controller.text == 'initial'),
          findsOneWidget,
        );
      });
    });

    testWidgets('CCIAEP renders view', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(NotesItemAddEditView), findsOneWidget);
    });

    testWidgets('CCIAEP pops when saved successfully', (tester) async {
      whenListen<NotesItemAddEditState>(
        mockNotesItemAddEditBloc,
        Stream.fromIterable(const [
          NotesItemAddEditState(),
          NotesItemAddEditState(
            status: NotesItemAddEditStatus.success,
          ),
        ]),
      );
      await tester.pumpApp(buildSubject());

      verify(() => mockNavigator.pop(any<dynamic>())).called(1);
    });
  });

  group('CCIAEP - edit item', () {
    Widget buildSubject() {
      return MockNavigatorProvider(
        navigator: mockNavigator,
        child: BlocProvider.value(
          value: mockNotesItemAddEditBloc,
          child: const NotesItemAddEditPage(action: ItemAddEditAction.edit),
        ),
      );
    }

    testWidgets('CCIAEP edit pops when saved', (tester) async {
      whenListen<NotesItemAddEditState>(
        mockNotesItemAddEditBloc,
        Stream.fromIterable(const [
          NotesItemAddEditState(),
          NotesItemAddEditState(
            status: NotesItemAddEditStatus.success,
          ),
        ]),
      );
      await tester.pumpApp(buildSubject());

      verify(() => mockNavigator.pop(any<dynamic>())).called(1);
    });

    //TODO: How can I correctly test the fiekds edit?
    testWidgets('CCIAEP edit fields', (widgetTester) async {
      // when(() => mockNotesItemAddEditBloc.add(NotesItemAddEditDescriptionChangedEvent(tItem.description)))
      //   .thenReturn({});
      // await widgetTester.pumpApp(buildSubject());
      //
      // expect(find.byType(NotesItemAddEditPage), findsOneWidget);
      // expect(find.byType(NotesItemAddEditView), findsOneWidget);
      //
      // expect(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-description')), findsOneWidget);
      // await widgetTester.enterText(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-description')), tItem.description);
      // await widgetTester.pumpAndSettle();
      //
      // verify(() => mockNotesItemAddEditBloc.add(NotesItemAddEditDescriptionChangedEvent(tItem.description))).called(1);
    }, skip: true);
  });
}