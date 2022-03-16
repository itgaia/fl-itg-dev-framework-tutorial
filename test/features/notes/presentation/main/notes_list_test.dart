import 'package:bloc_test/bloc_test.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/notes_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:http/http.dart' as http;

import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/get_notes_usecase.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/bloc/notes_bloc.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/notes_page.dart';
import 'package:dev_framework_tutorial/src/features/settings/settings_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../common/app_test_helper.dart';
import '../../../../common/test_helper.dart';
import '../../notes_test_helper.dart';

void main() {
  final mockNotes = List.generate(
    5,
    (i) => NotesModel(id: i.toString(), description: 'note code $i', content: 'note notes $i'),
  );

  // late NotesBloc bloc;
  late MockNotesBloc mockNotesBloc;
  late MockGetNotesUsecase mockGetNotesUsecase;

  setUpAll(() async {
    itgLogVerbose('setUpAll - start....');
    registerFallbackValue(FakeNotesState());
    registerFallbackValue(FakeNotesEvent());
    sl.registerLazySingleton<http.Client>(() => MockHttpClient());
    await initializeAppForTesting();
    // appMainPage = NotesPage(title: ItgLocalization.tr('Notes'));
    sl<SettingsService>().appMainPage = const NotesPage();
    setUpHttpClientGetNotesSuccess200();
  });

  setUp(() async {
    itgLogVerbose('setUp - start....');
    mockGetNotesUsecase = MockGetNotesUsecase();
    mockNotesBloc = MockNotesBloc();
  });

  group('NotesList', () {
    testWidgets('page class', (widgetTester) async {
      // await widgetTester.testWidgetPageClass<NotesList>();
      await widgetTester.testWidgetPageClass<NotesView>();
    });

    testWidgets('renders CircularProgressIndicator when state is loading', (WidgetTester widgetTester) async {
      // when(() => mockNotesBloc.state).thenReturn(Loading());
      when(() => mockNotesBloc.state).thenReturn(
        const NotesState(
          status: NotesStatus.loading,
          items: []
        )
      );
      await widgetTester.pumpNotesList(mockNotesBloc);
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      expect(find.byKey(keyProgressIndicatorMain), findsOneWidget);
    });

    testWidgets('loading indicator is displayed while wait for data', (widgetTester) async {
      if (sl.isRegistered<GetNotesUsecase>()) {
        sl.unregister<GetNotesUsecase>();
      }
      sl.registerLazySingleton<GetNotesUsecase>(() => mockGetNotesUsecase);
      arrangeReturnsNNotesAfterNSecondsWait(mockGetNotesUsecase);

      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pump(const Duration(milliseconds: 500));
      expect(find.byKey(keyTextError), findsNothing);
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      expect(find.byKey(keyProgressIndicatorMain), findsOneWidget);
      await widgetTester.pump(const Duration(milliseconds: 1500));
    });

    testWidgets('renders no data message when success with empty list', (widgetTester) async {
      // when(() => mockNotesBloc.state).thenReturn(Empty());
      when(() => mockNotesBloc.state).thenReturn(
          const NotesState(
              status: NotesStatus.success,
              items: []
          )
      );
      await widgetTester.pumpNotesList(mockNotesBloc);
      expect(find.byKey(keyTextError), findsNothing);
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Notes')), findsOneWidget);
    });

    testWidgets('renders (show) N items', (widgetTester) async {
      // the items (maybe) are more but it shows only N...
      // when(() => mockNotesBloc.state)
      //     .thenReturn(Loaded(notes: mockNotes));
      when(() => mockNotesBloc.state).thenReturn(
          NotesState(
              status: NotesStatus.success,
              items: mockNotes
          )
      );
      await widgetTester.pumpNotesList(mockNotesBloc);
      expect(find.byType(NotesListItem), findsNWidgets(4));
    });
  });

  group('Notes list tests', () {
    testWidgets('render empty list', (widgetTester) async {
      // widgetTester.testRenderListEmpty(mockNotesBloc, [Loading(), const Loaded(notes: []), Empty()], Empty(), NotesSubscriptionRequestedEvent());

      itgLogVerbose('before whenListen...');
      whenListen(
        mockNotesBloc,
        Stream.fromIterable([
          // const NotesState(),
          const NotesState(status: NotesStatus.initial),
          const NotesState(status: NotesStatus.failure),
        ])
      );
      itgLogVerbose('after whenListen...');

      await widgetTester.pumpNotesList(mockNotesBloc..add(const NotesSubscriptionRequestedEvent()));
      itgLogVerbose('after pumpNotesList...');
      await widgetTester.pumpAndSettle();
      // await widgetTester.pumpAndSettle();
      // await widgetTester.pumpAndSettle();
      // await widgetTester.pump(const Duration(seconds: 1));
      // await widgetTester.pump(const Duration(seconds: 1));
      // await widgetTester.pump(const Duration(seconds: 1));

      // expect(find.byType(NotesList), findsOneWidget);
      expect(find.byType(NotesView), findsOneWidget);
      itgLogVerbose('111...');
      expect(find.byKey(keyTextError), findsNothing);
      itgLogVerbose('222...');
      // expect(find.text(textMessageToDisplayNoData(dataModelName: 'Notes')), findsOneWidget);
      itgLogVerbose('333...');
      await widgetTester.pump(const Duration(seconds: 1));
      itgLogVerbose('444...');
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      itgLogVerbose('555...');
      await widgetTester.pump(const Duration(seconds: 1));
      itgLogVerbose('666...');
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Notes')), findsNothing);
      itgLogVerbose('777...');
      expect(find.byKey(keyListWidgetItemsData), findsOneWidget);
      itgLogVerbose('888...');
      await widgetTester.pump(const Duration(seconds: 1));
      itgLogVerbose('999...');
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Notes')), findsOneWidget);
      itgLogVerbose('AAA...');
      expect(find.byKey(keyListWidgetItemsData), findsNothing);
      itgLogVerbose('BBB...');
    }, skip: true);
  });
}
