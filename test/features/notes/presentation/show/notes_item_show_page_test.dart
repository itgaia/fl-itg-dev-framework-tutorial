import 'package:dev_framework_tutorial/src/features/notes/domain/notes_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/common/itg_localization.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/notes_item_add_edit_page.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/bloc/notes_bloc.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/notes_page.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/show/notes_item_show_page.dart';
import 'package:dev_framework_tutorial/src/features/settings/settings_service.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../../common/test_helper.dart';
import '../../notes_test_helper.dart';

const tagFull = 'Notes Item Show Page';
const tagShort = r'NISP';

void main() {
  final List<NotesModel> tItems = notesTestData();
  final NotesModel tData = tItems.first;
  late MockNotesBloc mockNotesBloc;
  late MockNavigator mockNavigator;

  setUp(() async {
    itgLogVerbose(r'Notes Item Show Page test - SetUp - Start...');

    mockNavigator = MockNavigator();
    // when(() => mockNavigator.push(any())).thenAnswer((_) async => null);

    mockNotesBloc = MockNotesBloc();
    when(() => mockNotesBloc.state).thenReturn(NotesState(
      status: NotesStatus.success,
      items: tItems
    ));

    await initializeAppForTesting();
    sl<SettingsService>().appMainPage = BlocProvider<NotesBloc>.value(
      value: mockNotesBloc,
      child: NotesItemShowPage(title: ItgLocalization.tr('NotesItem'), item: tData),
    );
  });

  group('Notes Item Show Page tests', (){
    test('NISP correct route name', () {
      expect(NotesItemShowPage.routeName, '/notes_item');
    });

    testWidgets('NISP page class', (widgetTester) async {
      await widgetTester.testWidgetPageClass<NotesItemShowPage>();
    });

    testWidgets('NISP page title', (widgetTester) async {
      await widgetTester.testWidgetPageTitle(appTitleNotesItem);
    });

    testWidgets('NISP show actions', (widgetTester) async {
      // TODO: check with allowXXXX set to false or true....
      // if (sl.isRegistered<NotesSupport>()) {
      //   sl.unregister<NotesSupport>();
      // }
      // sl.registerLazySingleton<NotesSupport>(() => mockNotesSupport);
      //
      // when(() => mockNotesSupport(any())).thenReturn(NotesSupport());
      // when(() => mockNotesSupport.allowRefresh).thenReturn(true);

      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      expect(find.byKey(const Key('$keyNotesWidgetItemShowBase-floating-actions')), findsOneWidget);
      expect(find.byKey(Key('$keyNotesWidgetItemShowBase-$keyFloatingActionRefresh')), findsOneWidget);
      expect(find.byKey(Key('$keyNotesWidgetItemShowBase-$keyFloatingActionEdit')), findsOneWidget);
      expect(find.byKey(Key('$keyNotesWidgetItemShowBase-$keyFloatingActionDuplicate')), findsOneWidget);
      expect(find.byKey(Key('$keyNotesWidgetItemShowBase-$keyFloatingActionAdd')), findsOneWidget);
      expect(find.byKey(Key('$keyNotesWidgetItemShowBase-$keyFloatingActionDelete')), findsOneWidget);
    });
  });

  group('Notes Item Show Page actions', (){
    testWidgets('NISP action edit', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      await widgetTester.tapOnWidget(Key('$keyNotesWidgetItemShowBase-$keyFloatingActionEdit'));
      expect(find.byType(NotesItemAddEditPage), findsOneWidget);
      expect(find.text(textSampleContent), findsNothing);
    });

    testWidgets('NISP action duplicate', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      await widgetTester.tapOnWidget(Key('$keyNotesWidgetItemShowBase-$keyFloatingActionDuplicate'));
      expect(find.byType(NotesItemAddEditPage), findsOneWidget);
      expect(find.text(textSampleContent), findsNothing);
      expect(find.byKey(keyTextPageTitle), findsOneWidget);
      expect(find.text(appTitleNotesItemDuplicatePage), findsOneWidget);
      expect(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-description')), findsOneWidget);
      widgetTester.testClassAndContentForTextFormField(key: const Key('$keyNotesWidgetItemAddEditBase-col1-description'), text: textTitleSuffixDuplicate);
    });

    group('Notes Item Show Page action delete', () {
      setUp(() {
        arrangeNotesItemDeleteUsecaseReturnSuccess();
      });

      testWidgets('NISP action delete', (widgetTester) async {
        await widgetTester.pumpWidgetUnderTest();
        await widgetTester.pumpAndSettle();

        await widgetTester.tapOnWidget(Key('$keyNotesWidgetItemShowBase-$keyFloatingActionDelete'));
        await widgetTester.tapOnWidgetByText('OK');
        // await widgetTester.pumpAndSettle();

        expect(find.byKey(keyNotificationSuccess), findsOneWidget);
        expect(find.text('Note has been deleted'), findsOneWidget);
        expect(find.byKey(keyNotificationFailure), findsNothing);
        expect(find.byType(NotesItemShowPage), findsOneWidget);
        expect(find.byType(NotesPage), findsNothing);
      });

      testWidgets('NISP pops when deleted successfully', (widgetTester) async {
        when(() => mockNavigator.push(any())).thenAnswer((_) async => null);
        // TODO: When I use the MockNavigatorProvider then the process does not
        //       continue after the confirm_dialog... Why?
        sl<SettingsService>().appMainPage = MockNavigatorProvider(
            navigator: mockNavigator,
            child: BlocProvider<NotesBloc>.value(
              value: mockNotesBloc,
              child: NotesItemShowPage(title: ItgLocalization.tr('NotesItem'), item: tData),
            )
        );

        await widgetTester.pumpWidgetUnderTest();
        await widgetTester.pumpAndSettle();

        await widgetTester.tapOnWidget(Key('$keyNotesWidgetItemShowBase-$keyFloatingActionDelete'));
        await widgetTester.tapOnWidgetByText('OK');
        await widgetTester.pumpAndSettle();
        await widgetTester.pumpAndSettle();
        await widgetTester.pumpAndSettle();

        verify(() => mockNavigator.pop(any<dynamic>())).called(1);
      }, skip: false);
    });

    testWidgets('NISP action refresh', (widgetTester) async {
      // if (sl.isRegistered<NotesSupport>()) {
      //   sl.unregister<NotesSupport>();
      // }
      // // sl.registerLazySingleton<NotesSupport>(() => mockNotesSupport);
      // sl.registerLazySingleton<NotesSupport>(() => MockNotesSupport());
      //
      // when(() => sl<NotesSupport>().actionItemRefresh(data: any(named: "data")))
      //   .thenAnswer((_) => Future.value(true));
      // when(() => sl<NotesSupport>().allowRefresh).thenReturn(true);

      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      await widgetTester.tapOnWidget(Key('$keyNotesWidgetItemShowBase-$keyFloatingActionRefresh'));
      expect(find.byType(NotesItemShowPage), findsOneWidget);
      expect(find.byType(NotesPage), findsNothing);
      expect(find.text(textSampleContent), findsNothing);

      // verify(() => sl<NotesSupport>().actionItemRefresh(data: any(named: "data"))).called(1);
      // verify(() => sl<NotesSupport>().allowRefresh).called(1);
    });
  });
}