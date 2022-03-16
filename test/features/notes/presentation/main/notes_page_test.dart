import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/notes_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';
import 'package:dev_framework_tutorial/src/core/usecase/usecase.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/notes_item_add_edit_page.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/bloc/notes_bloc.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/show/notes_item_show_page.dart';
import 'package:dev_framework_tutorial/src/features/settings/settings_service.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:http/http.dart' as http;
import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/get_notes_usecase.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/notes_page.dart';

import '../../../../common/app_test_helper.dart';
import '../../../../common/test_helper.dart';
import '../../notes_test_helper.dart';

void main() {
  final tData = notesTestData();
  late FakeNotesState fakeNotesState;
  late FakeNotesEvent fakeNotesEvent;

  setUpAll(() {
    fakeNotesState = FakeNotesState();
    fakeNotesEvent = FakeNotesEvent();
    registerFallbackValue(fakeNotesState);
    registerFallbackValue(fakeNotesEvent);
    registerFallbackValue(NoParams());
    sl.registerLazySingleton<http.Client>(() => MockHttpClient());
  });

  setUp(() async {
    itgLogVerbose('Notes Page test - SetUp - Start...');
    await initializeAppForTesting();
    if (sl.isRegistered<GetNotesUsecase>()) {
      sl.unregister<GetNotesUsecase>();
    }
    sl.registerLazySingleton<GetNotesUsecase>(() => MockGetNotesUsecase());
    sl<SettingsService>().appMainPage = const NotesPage();
    when(() => sl<GetNotesUsecase>()(any()))
      .thenAnswer((_) async => Right(tData));
  });

  group('Notes page tests', () {
    test('NTP correct route name', () {
      expect(NotesPage.routeName, '/notes');
    });

    testWidgets('NTP page class', (widgetTester) async {
      await widgetTester.testWidgetPageClass<NotesPage>();
    });

    testWidgets('NTP page title', (widgetTester) async {
      await widgetTester.testWidgetPageTitle(appTitleNotes);
    });

    testWidgets('NTP show floating actions', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();

      expect(find.byKey(const Key('$keyNotesWidgetListItemBase-floating-actions')), findsOneWidget);
      expect(find.byKey(Key('$keyNotesWidgetListItemBase-$keyFloatingActionRefresh')), findsOneWidget);
      expect(find.byKey(Key('$keyNotesWidgetListItemBase-$keyFloatingActionAdd')), findsOneWidget);
      expect(find.byKey(Key('$keyNotesWidgetListItemBase-$keyFloatingActionEdit')), findsNothing);
      expect(find.byKey(Key('$keyNotesWidgetListItemBase-$keyFloatingActionDuplicate')), findsNothing);
      expect(find.byKey(Key('$keyNotesWidgetListItemBase-$keyFloatingActionDelete')), findsNothing);
    });

    testWidgets('subscribes to items from usecase on initialization', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();
      verify(() => sl<GetNotesUsecase>().call(any())).called(1);
    });
  });

  group('Notes View tests', () {
    late MockNavigator mockNavigator;
    late NotesBloc mockNotesBloc;

    setUp(() {
      mockNavigator = MockNavigator();
      when(() => mockNavigator.push(any())).thenAnswer((_) async => null);

      mockNotesBloc = MockNotesBloc();
      when(() => mockNotesBloc.state).thenReturn(
        NotesState(
          status: NotesStatus.success,
          items: tData
        )
      );

      // usecase with empty data... is it needed?
    });

    Widget buildSubject() {
      return MockNavigatorProvider(
        navigator: mockNavigator,
        child: BlocProvider.value(
          value: mockNotesBloc,
          child: const NotesView()
        )
      );
    }

    testWidgets('renders AppBar with title text', (widgetTester) async {
      await widgetTester.pumpApp(buildSubject(),);

        expect(find.byType(AppBar), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text(appTitleNotes),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('renders error text when status changes to failure', (widgetTester) async {
        whenListen<NotesState>(
          mockNotesBloc,
          Stream.fromIterable([
            const NotesState(),
            const NotesState(
              status: NotesStatus.failure,
            ),
          ]),
        );

        await widgetTester.pumpApp(buildSubject(),);
        await widgetTester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(SnackBar),
            matching: find.text(textMessageToDisplayError(dataModelName: 'Notes', errorMessage: '')),
          ),
          findsOneWidget
        );
      },
    );

    group('NoteDeletionConfirmationSnackBar', () {
      setUp(() {
        when(() => mockNotesBloc.state)
          .thenReturn(NotesState(lastDeletedItem: tData.first));
        whenListen<NotesState>(
          mockNotesBloc,
          Stream.fromIterable([
            const NotesState(),
            NotesState(
              lastDeletedItem: tData.first,
            ),
          ]),
        );
      });

      testWidgets('snackbar is rendered when lastDeletedItem changes', (widgetTester) async {
        await widgetTester.pumpApp(buildSubject());
        await widgetTester.pumpAndSettle();
        await widgetTester.pumpAndSettle();
        await widgetTester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        final snackBar = widgetTester.widget<SnackBar>(find.byType(SnackBar));

        itgLogVerbose('snackBar.content: ${snackBar.content}');
        expect(
          snackBar.content,
          isA<Text>().having((text) => text.data, 'text', contains(tData.first.title)),
        );
      });

      testWidgets('is rendered when lastDeletedItem changes', (widgetTester) async {
        await widgetTester.pumpApp(buildSubject(),);
        await widgetTester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);

        final snackBar = widgetTester.widget<SnackBar>(find.byType(SnackBar));

        expect(
          snackBar.content,
          isA<Text>().having((text) => text.data, 'text', contains(tData.first.title)),
        );
      });

      testWidgets(
        'adds NotesSubscriptionRequestedEvent '
        'to NotesBloc '
        'when onUndo is called',
        (widgetTester) async {
          await widgetTester.pumpApp(
            buildSubject(),
            // todosRepository: todosRepository,
          );
          await widgetTester.pumpAndSettle();

          final snackBarAction = widgetTester.widget<SnackBarAction>(
            find.byType(SnackBarAction),
          );

          snackBarAction.onPressed();

          verify(() => mockNotesBloc.add(
            const NotesSubscriptionRequestedEvent(),
          )).called(1);
        }, skip: true);
    });

    group('when items is empty', () {
      setUp(() {
        when(() => mockNotesBloc.state)
          .thenReturn(const NotesState());
      });

      testWidgets('renders nothing when status is initial or error', (widgetTester) async {
          await widgetTester.pumpApp(buildSubject());

          expect(find.byType(ListView), findsNothing);
          expect(find.byType(CupertinoActivityIndicator), findsNothing);
        },
      );

      testWidgets('renders loading indicator when status is loading', (widgetTester) async {
          when(() => mockNotesBloc.state).thenReturn(
            const NotesState(status: NotesStatus.loading),
          );

          await widgetTester.pumpApp(buildSubject());

          expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
        },
      );

      testWidgets('renders items empty text when status is success', (widgetTester) async {
          when(() => mockNotesBloc.state).thenReturn(
            const NotesState(status: NotesStatus.success),
          );

          await widgetTester.pumpApp(buildSubject());

          expect(find.text(appTitleNotes), findsOneWidget);
        },
      );
    });
  });

  group('Notes Page list tests', () {
    testWidgets('NTP renders list widget', (widgetTester) async {
      widgetTester.testRenderWidget<NotesView>(keyItemsListWidget);
    });

    testWidgets('NTP render empty list', (widgetTester) async {
      arrangeReturnsNNotesAfterNSecondsWait(sl<GetNotesUsecase>(), count: 0);
      await widgetTester.pumpWidgetUnderTest();

      expect(find.byType(NotesView), findsOneWidget);
      expect(find.byKey(keyTextError), findsNothing);
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Notes')), findsNothing);
      expect(find.byType(CupertinoActivityIndicator), findsNothing);
      await widgetTester.pump();
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Notes')), findsNothing);
      await widgetTester.pumpAndSettle();
      expect(find.byType(CupertinoActivityIndicator), findsNothing);
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Notes')), findsOneWidget);
      expect(find.byKey(keyListWidgetItemsData), findsNothing);
      await widgetTester.pump();
      sl.unregister<GetNotesUsecase>();
      await widgetTester.pump();
    });

    testWidgets('NTP render list', (widgetTester) async {
      arrangeReturnsNNotesAfterNSecondsWait(sl<GetNotesUsecase>());
      await widgetTester.pumpWidgetUnderTest();

      expect(find.byType(NotesView), findsOneWidget);
      expect(find.byKey(keyTextError), findsNothing);
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Notes')), findsNothing);
      await widgetTester.pump();
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      await widgetTester.pump(const Duration(seconds: 2));
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Notes')), findsNothing);
      expect(find.byKey(keyItemsListWidget), findsOneWidget);
      await widgetTester.pump();
      sl.unregister<GetNotesUsecase>();
      await widgetTester.pump();
    });

    testWidgets('NTP render error', (widgetTester) async {
      // arrangeNotesUsecaseReturnException(sl<GetNotesUsecase>());
      when(() => sl<GetNotesUsecase>()(any()))
          .thenAnswer((_) async => const Left(ServerFailure(code: '111')));
      await widgetTester.pumpWidgetUnderTest();

      expect(find.byType(NotesView), findsOneWidget);
      expect(find.byKey(keyTextError), findsNothing);
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Notes')), findsNothing);
      await widgetTester.pump();
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Notes')), findsNothing);
      expect(find.byKey(keyListWidgetItemsData), findsNothing);
      expect(find.byKey(keyTextError), findsOneWidget);
      expect(find.text(
          // textMessageToDisplayError(dataModelName: 'Notes', errorMessage: const ServerFailure(description: 'Exception: $textSampleException').toString())),
          textMessageToDisplayError(dataModelName: 'Notes', errorMessage: '')),
          findsOneWidget
      );
      await widgetTester.pump();
      sl.unregister<GetNotesUsecase>();
      await widgetTester.pump();
    });
  });

  group('Notes Page actions', (){
    testWidgets('NTP - action - add', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();

      await widgetTester.tapOnWidget(Key('$keyNotesWidgetListItemBase-$keyFloatingActionAdd'));
      expect(find.byType(NotesItemAddEditPage), findsOneWidget);
      expect(find.text(textSampleContent), findsNothing);
    });

    testWidgets('NTP - action - refresh', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      itgLogVerbose('NTP - action - refresh - before press refresh');
      await widgetTester.tapOnWidget(Key('$keyNotesWidgetListItemBase-$keyFloatingActionRefresh'));
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpAndSettle();
      expect(find.byType(NotesPage), findsOneWidget);
      expect(find.byType(NotesItemAddEditPage), findsNothing);
      expect(find.text(textSampleContent), findsNothing);

      verify(() => sl<GetNotesUsecase>().call(any())).called(2);
    }, skip: false);
  });

  group('Notes List Item actions', (){
    testWidgets('NTLI - action - show', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      await widgetTester.tapOnWidget(Key('$keyNotesWidgetListItemBase-1-$keyActionShow'));
      expect(find.byType(NotesItemShowPage), findsOneWidget);
      expect(find.text(textSampleContent), findsNothing);
    });

    testWidgets('NTLI - action - edit', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      await widgetTester.tapOnWidget(const Key('$keyNotesWidgetListItemBase-1-action-edit'));
      expect(find.byType(NotesItemAddEditPage), findsOneWidget);
      expect(find.text(textSampleContent), findsNothing);
    });

    testWidgets('NTLI - action - duplicate', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      await widgetTester.tapOnWidget(const Key('$keyNotesWidgetListItemBase-1-action-duplicate'));
      expect(find.byType(NotesItemAddEditPage), findsOneWidget);
      expect(find.text(textSampleContent), findsNothing);
      expect(find.byKey(keyTextPageTitle), findsOneWidget);
      expect(find.text(appTitleNotesItemDuplicatePage), findsOneWidget);
      expect(find.byKey(const Key('$keyNotesWidgetItemAddEditBase-col1-description')), findsOneWidget);
      widgetTester.testClassAndContentForTextFormField(key: const Key('$keyNotesWidgetItemAddEditBase-col1-description'), text: textTitleSuffixDuplicate);
    });

    testWidgets('NTLI - action - delete', (widgetTester) async {
      arrangeNotesItemDeleteUsecaseReturnSuccess();

      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      await widgetTester.tapOnWidget(const Key('$keyNotesWidgetListItemBase-1-action-delete'));
      await widgetTester.tapOnWidgetByText('OK');

      expect(find.byKey(keyNotificationSuccess), findsOneWidget);
      expect(find.text('Note has been deleted'), findsOneWidget);
      expect(find.byKey(keyNotificationFailure), findsNothing);
      expect(find.byType(NotesItemShowPage), findsNothing);
      expect(find.byType(NotesPage), findsOneWidget);
    });
  });
}