import 'package:dev_framework_tutorial/src/features/notes/domain/notes_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/common/itg_localization.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/bloc/notes_item_add_edit_bloc.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/notes_item_add_edit_page.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/notes_item_add_edit_view.dart';
import 'package:dev_framework_tutorial/src/features/settings/settings_service.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../../common/app_test_helper.dart';
import '../../../../common/test_helper.dart';
import '../../notes_test_helper.dart';

void main() {
  final NotesModel notesItem = notesTestData().first;
  late MockNavigator mockNavigator;
  late NotesItemAddEditBloc mockNotesItemAddEditBloc;

  setUpAll(() {
  });

  setUp(() async {
    mockNavigator = MockNavigator();
    when(() => mockNavigator.push(any())).thenAnswer((_) async => null);

    mockNotesItemAddEditBloc = MockNotesItemAddEditBloc();
    when(() => mockNotesItemAddEditBloc.state).thenReturn(
      sampleNotesItemAddEditState(initialData: notesItem)
    );

    itgLogVerbose('Notes Item Add/Edit View test - SetUp - Start...');
    await initializeAppForTesting();
    itgLogVerbose('notes_item_add_edit_view_test - set appMainPage....');
    sl<SettingsService>().appMainPage = MockNavigatorProvider(
      navigator: mockNavigator,
      child: BlocProvider.value(
        value: mockNotesItemAddEditBloc,
        child: const NotesItemAddEditView(title: textSampleContent),
      ),
    );
  });

  group('Notes Item Add/Edit view tests', () {
    testWidgets('CCIAEV page class', (widgetTester) async {
      await widgetTester.testWidgetPageClass<NotesItemAddEditView>();
    });

    testWidgets('CCIAEV show view widgets', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();
      // await widgetTester.pumpAndSettle();
      expect(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-description')), findsOneWidget);
      expect(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-content')), findsOneWidget);

      expect(find.byType(Form), findsNothing);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-form')), findsNothing);
      expect(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-form-submit')), findsNothing);
    });
  });

  group('NotesItemAddEditView - title', () {
    testWidgets('renders AppBar with title text for new items when a new item is being created', (tester) async {
      Widget buildSubject() {
        return BlocProvider.value(
          value: mockNotesItemAddEditBloc,
          child: const NotesItemAddEditPage(action: ItemAddEditAction.add),
        );
      }

      when(() => mockNotesItemAddEditBloc.state).thenReturn(const NotesItemAddEditState());
      await tester.pumpApp(buildSubject());

      expect(find.byType(AppBar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text(ItgLocalization.tr(appTitleNotesItemAddPage)),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders AppBar with title text for editing items when an existing item is being edited', (tester) async {
      Widget buildSubject() {
        return BlocProvider.value(
          value: mockNotesItemAddEditBloc,
          child: const NotesItemAddEditPage(action: ItemAddEditAction.edit),
        );
      }

      when(() => mockNotesItemAddEditBloc.state).thenReturn(
        const NotesItemAddEditState(
          initialData: sampleNotesItemInitialData,
        ),
      );
      await tester.pumpApp(buildSubject());

      expect(find.byType(AppBar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text(ItgLocalization.tr(appTitleNotesItemEditPage)),
        ),
        findsOneWidget,
      );
    });
  });

  group('NotesItemAddEditView - fields', () {
    Widget buildSubject() {
      return MockNavigatorProvider(
        navigator: mockNavigator,
        child: BlocProvider.value(
          value: mockNotesItemAddEditBloc,
          child: const NotesItemAddEditView(title: textSampleContent),
        ),
      );
    }

    //** fields start **//
    group('CCIAEV code text form field', () {
      testWidgets('CCIAEV code is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-description')), findsOneWidget);
      });

      testWidgets('CCIAEV code is disabled when loading', (tester) async {
        when(() => mockNotesItemAddEditBloc.state).thenReturn(
          const NotesItemAddEditState(status: NotesItemAddEditStatus.submitting),
        );
        await tester.pumpApp(buildSubject());

        final textField = tester.widget<TextFormField>(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-description')));
        expect(textField.enabled, false);
      });

      testWidgets(
        'adds NotesItemAddEditDescriptionChangedEvent '
        'to NotesItemAddEditBloc '
        'when a new value is entered',
        (tester) async {
          await tester.pumpApp(buildSubject());
          await tester.enterText(
            find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-description')),
            'new code',
          );

          verify(() => mockNotesItemAddEditBloc
              .add(const NotesItemAddEditDescriptionChangedEvent('new code')))
              .called(1);
        },
      );
    });

    group('CCIAEV context text form field', () {
      testWidgets('CCIAEV context is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-content')), findsOneWidget);
      });

      testWidgets('CCIAEV context is disabled when loading', (tester) async {
        when(() => mockNotesItemAddEditBloc.state).thenReturn(
          const NotesItemAddEditState(status: NotesItemAddEditStatus.submitting),
        );
        await tester.pumpApp(buildSubject());

        final textField = tester.widget<TextFormField>(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-content')));
        expect(textField.enabled, false);
      });

      testWidgets(
        'adds NotesItemAddEditContentChangedEvent '
        'to NotesItemAddEditBloc '
        'when a new value is entered',
        (tester) async {
          await tester.pumpApp(buildSubject());
          await tester.enterText(
            find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-content')),
            'new-content',
          );

          verify(() => mockNotesItemAddEditBloc
              .add(const NotesItemAddEditContentChangedEvent('new-content')))
              .called(1);
        },
      );
    });
    //** fields end **//

    group('CCIAEV save fab', () {
      testWidgets('CCIAEV save fab is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.descendant(
            of: find.byType(FloatingActionButton),
            matching: find.byTooltip(ItgLocalization.tr('Save changes')),
          ),
          findsOneWidget,
        );
      });

      testWidgets(
        'adds NotesItemAddEditSubmittedEvent '
        'to NotesItemAddEditBloc '
        'when tapped',
        (tester) async {
          await tester.pumpApp(buildSubject());
          await tester.tap(find.byType(FloatingActionButton));

          verify(() => mockNotesItemAddEditBloc
              .add(const NotesItemAddEditSubmittedEvent()))
              .called(1);
        },
      );
    });
  });

  // group('', () {
  //   testWidgets('adds NotesItemAddEditSubmittedEvent '
  //         'to NotesItemAddEditBloc '
  //         'when tapped',
  //         (tester) async {
  //       await tester.pumpApp(buildSubject());
  //       await tester.tap(find.byType(FloatingActionButton));
  //
  //       verify(() => mockNotesItemAddEditBloc
  //           .add(const NotesItemAddEditSubmittedEvent()))
  //           .called(1);
  //     },
  //   );
  // });
}