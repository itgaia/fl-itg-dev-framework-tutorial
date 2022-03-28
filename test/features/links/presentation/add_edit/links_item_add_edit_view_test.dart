import 'package:dev_framework_tutorial/src/features/links/domain/links_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/common/itg_localization.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_model.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/add_edit/bloc/links_item_add_edit_bloc.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/add_edit/links_item_add_edit_page.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/add_edit/links_item_add_edit_view.dart';
import 'package:dev_framework_tutorial/src/features/settings/settings_service.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../../common/app_test_helper.dart';
import '../../../../common/test_helper.dart';
import '../../links_test_helper.dart';

void main() {
  final LinksModel linksItem = linksTestData().first;
  late MockNavigator mockNavigator;
  late LinksItemAddEditBloc mockLinksItemAddEditBloc;

  setUpAll(() {
  });

  setUp(() async {
    mockNavigator = MockNavigator();
    when(() => mockNavigator.push(any())).thenAnswer((_) async => null);

    mockLinksItemAddEditBloc = MockLinksItemAddEditBloc();
    when(() => mockLinksItemAddEditBloc.state).thenReturn(
      sampleLinksItemAddEditState(initialData: linksItem)
    );

    itgLogVerbose('Links Item Add/Edit View test - SetUp - Start...');
    await initializeAppForTesting();
    itgLogVerbose('links_item_add_edit_view_test - set appMainPage....');
    sl<SettingsService>().appMainPage = MockNavigatorProvider(
      navigator: mockNavigator,
      child: BlocProvider.value(
        value: mockLinksItemAddEditBloc,
        child: const LinksItemAddEditView(title: textSampleContent),
      ),
    );
  });

  group('Links Item Add/Edit view tests', () {
    testWidgets('LNIAEV page class', (widgetTester) async {
      await widgetTester.testWidgetPageClass<LinksItemAddEditView>();
    });

    testWidgets('LNIAEV show view widgets', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();
      // await widgetTester.pumpAndSettle();
      expect(find.byKey(const Key('$keyLinksWidgetItemAddEditBase-col1-description')), findsOneWidget);
      expect(find.byKey(const Key('$keyLinksWidgetItemAddEditBase-col1-notes')), findsOneWidget);

      expect(find.byType(Form), findsNothing);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byKey(const Key('$keyLinksWidgetItemAddEditBase-form')), findsNothing);
      expect(find.byKey(const Key('$keyLinksWidgetItemAddEditBase-form-submit')), findsNothing);
    });
  });

  group('LinksItemAddEditView - title', () {
    testWidgets('renders AppBar with title text for new items when a new item is being created', (tester) async {
      Widget buildSubject() {
        return BlocProvider.value(
          value: mockLinksItemAddEditBloc,
          child: const LinksItemAddEditPage(action: ItemAddEditAction.add),
        );
      }

      when(() => mockLinksItemAddEditBloc.state).thenReturn(const LinksItemAddEditState());
      await tester.pumpApp(buildSubject());

      expect(find.byType(AppBar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text(ItgLocalization.tr(appTitleLinksItemAddPage)),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders AppBar with title text for editing items when an existing item is being edited', (tester) async {
      Widget buildSubject() {
        return BlocProvider.value(
          value: mockLinksItemAddEditBloc,
          child: const LinksItemAddEditPage(action: ItemAddEditAction.edit),
        );
      }

      when(() => mockLinksItemAddEditBloc.state).thenReturn(
        const LinksItemAddEditState(
          initialData: sampleLinksItemInitialData,
        ),
      );
      await tester.pumpApp(buildSubject());

      expect(find.byType(AppBar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text(ItgLocalization.tr(appTitleLinksItemEditPage)),
        ),
        findsOneWidget,
      );
    });
  });

  group('LinksItemAddEditView - fields', () {
    Widget buildSubject() {
      return MockNavigatorProvider(
        navigator: mockNavigator,
        child: BlocProvider.value(
          value: mockLinksItemAddEditBloc,
          child: const LinksItemAddEditView(title: textSampleContent),
        ),
      );
    }

    //** fields start **//
    group('LNIAEV description form field', () {
      testWidgets('LNIAEV Description is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byKey(const Key('$keyLinksWidgetItemAddEditBase-col1-description')), findsOneWidget);
      });

      testWidgets('LNIAEV description is disabled when loading', (tester) async {
        when(() => mockLinksItemAddEditBloc.state).thenReturn(
          const LinksItemAddEditState(status: LinksItemAddEditStatus.submitting),
        );
        await tester.pumpApp(buildSubject());

        final textField = tester.widget<TextFormField>(find.byKey(const Key('$keyLinksWidgetItemAddEditBase-col1-description')));
        expect(textField.enabled, false);
      });

      testWidgets(
        'adds LinksItemAddEditDescriptionChangedEvent '
        'to LinksItemAddEditBloc '
        'when a new value is entered',
        (tester) async {
          await tester.pumpApp(buildSubject());
          await tester.enterText(
            find.byKey(const Key('$keyLinksWidgetItemAddEditBase-col1-description')),
            'new description',
          );

          verify(() => mockLinksItemAddEditBloc
              .add(const LinksItemAddEditDescriptionChangedEvent('new description')))
              .called(1);
        },
      );
    });

    group('LNIAEV notes form field', () {
      testWidgets('LNIAEV Notes is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byKey(const Key('$keyLinksWidgetItemAddEditBase-col1-notes')), findsOneWidget);
      });

      testWidgets('LNIAEV notes is disabled when loading', (tester) async {
        when(() => mockLinksItemAddEditBloc.state).thenReturn(
          const LinksItemAddEditState(status: LinksItemAddEditStatus.submitting),
        );
        await tester.pumpApp(buildSubject());

        final textField = tester.widget<TextFormField>(find.byKey(const Key('$keyLinksWidgetItemAddEditBase-col1-notes')));
        expect(textField.enabled, false);
      });

      testWidgets(
        'adds LinksItemAddEditNotesChangedEvent '
        'to LinksItemAddEditBloc '
        'when a new value is entered',
        (tester) async {
          await tester.pumpApp(buildSubject());
          await tester.enterText(
            find.byKey(const Key('$keyLinksWidgetItemAddEditBase-col1-notes')),
            'new notes',
          );

          verify(() => mockLinksItemAddEditBloc
              .add(const LinksItemAddEditNotesChangedEvent('new notes')))
              .called(1);
        },
      );
    });
    //** fields end **//

    group('LNIAEV save fab', () {
      testWidgets('LNIAEV save fab is rendered', (tester) async {
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
        'adds LinksItemAddEditSubmittedEvent '
        'to LinksItemAddEditBloc '
        'when tapped',
        (tester) async {
          await tester.pumpApp(buildSubject());
          await tester.tap(find.byType(FloatingActionButton));

          verify(() => mockLinksItemAddEditBloc
              .add(const LinksItemAddEditSubmittedEvent()))
              .called(1);
        },
      );
    });
  });

  // group('', () {
  //   testWidgets('adds LinksItemAddEditSubmittedEvent '
  //         'to LinksItemAddEditBloc '
  //         'when tapped',
  //         (tester) async {
  //       await tester.pumpApp(buildSubject());
  //       await tester.tap(find.byType(FloatingActionButton));
  //
  //       verify(() => mockLinksItemAddEditBloc
  //           .add(const LinksItemAddEditSubmittedEvent()))
  //           .called(1);
  //     },
  //   );
  // });
}