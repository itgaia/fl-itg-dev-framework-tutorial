import 'package:bloc_test/bloc_test.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/links_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_model.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/add_edit/bloc/links_item_add_edit_bloc.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/add_edit/links_item_add_edit_view.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/add_edit/links_item_add_edit_page.dart';
import 'package:dev_framework_tutorial/src/features/settings/settings_service.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../../common/app_test_helper.dart';
import '../../../../common/test_helper.dart';
import '../../links_test_helper.dart';

void main() {
  final LinksModel tItem = linksTestData().first;
  late MockNavigator mockNavigator;
  late LinksItemAddEditBloc mockLinksItemAddEditBloc;

  setUpAll(() {
    registerFallbackValue(FakeLinksItemAddEditState());
    registerFallbackValue(FakeLinksItemAddEditEvent());
  });

  setUp(() async {
    itgLogVerbose('Links Item Add/Edit Page test - SetUp - Start...');
    mockNavigator = MockNavigator();
    when(() => mockNavigator.push(any())).thenAnswer((_) async => null);

    mockLinksItemAddEditBloc = MockLinksItemAddEditBloc();
    when(() => mockLinksItemAddEditBloc.state).thenReturn(
      sampleLinksItemAddEditState(initialData: tItem)
    );

    await initializeAppForTesting();
    sl<SettingsService>().appMainPage = MockNavigatorProvider(
      navigator: mockNavigator,
      child: BlocProvider.value(
        value: mockLinksItemAddEditBloc,   // TODO: why is this not working?
        // value: sl<LinksItemAddEditBloc>(),
        child: const LinksItemAddEditPage(action: ItemAddEditAction.add),
      ),
    );

  });

  group('Links Item Add/Edit page tests', () {
    test('LNIAEP correct route name', () {
      expect(LinksItemAddEditPage.routeName, '/links_item_add_edit');
    });

    testWidgets('LNIAEP page class', (widgetTester) async {
      await widgetTester.testWidgetPageClass<LinksItemAddEditPage>();
      expect(find.byType(LinksItemAddEditView), findsOneWidget);
    });

    testWidgets('LNIAEP page title', (widgetTester) async {
      await widgetTester.testWidgetPageTitle(appTitleLinksItemAddPage);
    });

    testWidgets('LNIAEP do not show floating actions', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();

      expect(find.byKey(const Key('$keyLinksWidgetItemAddEditBase-floating-actions')), findsNothing);
      expect(find.byKey(Key('$keyLinksWidgetItemAddEditBase-$keyFloatingActionRefresh')), findsNothing);
      expect(find.byKey(Key('$keyLinksWidgetItemAddEditBase-$keyFloatingActionAdd')), findsNothing);
      expect(find.byKey(Key('$keyLinksWidgetItemAddEditBase-$keyFloatingActionEdit')), findsNothing);
      expect(find.byKey(Key('$keyLinksWidgetItemAddEditBase-$keyFloatingActionDuplicate')), findsNothing);
      expect(find.byKey(Key('$keyLinksWidgetItemAddEditBase-$keyFloatingActionDelete')), findsNothing);

      // TODO: How can I test for the correct tooltip?
      // expect(find.text('Refresh Links...'), findsOneWidget);
      // expect(find.text('Refresh Links'), findsOneWidget);
    });
  });

  group('LinksItemAddEditPage', () {
    Widget buildSubject() {
      return MockNavigatorProvider(
        navigator: mockNavigator,
        child: BlocProvider.value(
          value: mockLinksItemAddEditBloc,
          child: const LinksItemAddEditPage(action: ItemAddEditAction.add),
        ),
      );
    }

    group('LNIAEP route', () {
      testWidgets('LNIAEP renders page', (tester) async {
        await tester.pumpRoute(LinksItemAddEditPage.route(action: ItemAddEditAction.add));
        expect(find.byType(LinksItemAddEditPage), findsOneWidget);
      });

      testWidgets('LNIAEP supports providing initial data', (tester) async {
        await tester.pumpRoute(
          LinksItemAddEditPage.route(
            action: ItemAddEditAction.add,
            initialData: sampleLinksItemInitialData
          ),
        );
        expect(find.byType(LinksItemAddEditPage), findsOneWidget);
        expect(
          find.byWidgetPredicate((w) => w is EditableText && w.controller.text == sampleLinksItemInitialData.description),
          findsOneWidget,
        );
      });
    });

    testWidgets('LNIAEP renders view', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(LinksItemAddEditView), findsOneWidget);
    });

    testWidgets('LNIAEP pops when saved successfully', (tester) async {
      whenListen<LinksItemAddEditState>(
        mockLinksItemAddEditBloc,
        Stream.fromIterable(const [
          LinksItemAddEditState(),
          LinksItemAddEditState(
            status: LinksItemAddEditStatus.success,
          ),
        ]),
      );
      await tester.pumpApp(buildSubject());

      verify(() => mockNavigator.pop(any<dynamic>())).called(1);
    });
  });

  group('LNIAEP - edit item', () {
    Widget buildSubject() {
      return MockNavigatorProvider(
        navigator: mockNavigator,
        child: BlocProvider.value(
          value: mockLinksItemAddEditBloc,
          child: const LinksItemAddEditPage(action: ItemAddEditAction.edit),
        ),
      );
    }

    testWidgets('LNIAEP edit pops when saved', (tester) async {
      whenListen<LinksItemAddEditState>(
        mockLinksItemAddEditBloc,
        Stream.fromIterable(const [
          LinksItemAddEditState(),
          LinksItemAddEditState(
            status: LinksItemAddEditStatus.success,
          ),
        ]),
      );
      await tester.pumpApp(buildSubject());

      verify(() => mockNavigator.pop(any<dynamic>())).called(1);
    });

    //TODO: How can I correctly test the fiekds edit?
    testWidgets('LNIAEP edit fields', (widgetTester) async {
      // when(() => mockLinksItemAddEditBloc.add(LinksItemAddEditDescriptionChangedEvent(tItem.description)))
      //   .thenReturn({});
      // await widgetTester.pumpApp(buildSubject());
      //
      // expect(find.byType(LinksItemAddEditPage), findsOneWidget);
      // expect(find.byType(LinksItemAddEditView), findsOneWidget);
      //
      // expect(find.byKey(const Key('$keyLinksWidgetItemAddEditBase-col1-description')), findsOneWidget);
      // await widgetTester.enterText(find.byKey(const Key('$keyLinksWidgetItemAddEditBase-col1-description')), tItem.description);
      // await widgetTester.pumpAndSettle();
      //
      // verify(() => mockLinksItemAddEditBloc.add(LinksItemAddEditDescriptionChangedEvent(tItem.description))).called(1);
    }, skip: true);
  });
}