import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/core/usecase/usecase.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/notes_support.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/get_notes_usecase.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/bloc/notes_item_add_edit_bloc.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/notes_item_add_edit_page.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/bloc/notes_bloc.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/notes_page.dart';
import 'package:dev_framework_tutorial/src/features/settings/settings_service.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../common/test_helper.dart';
import '../notes_test_helper.dart';

void main() {
  final NotesModel note = notesTestData().first;
  final NotesBloc mockNotesBloc = MockNotesBloc();
  final tItems = notesTestData();
  final tItem = tItems.first;

  late MockNavigator mockNavigator;
  late NotesSupport notesSupport;
  late NotesItemAddEditBloc mockNotesItemAddEditBloc;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() async {
    notesSupport = NotesSupport();
    mockNavigator = MockNavigator();
    when(() => mockNavigator.push(any())).thenAnswer((_) async => null);

    when(() => mockNotesBloc.add(const NotesSubscriptionRequestedEvent()))
        .thenAnswer((_) async { });

    mockNotesItemAddEditBloc = MockNotesItemAddEditBloc();
    when(() => mockNotesItemAddEditBloc.state).thenReturn(
        NotesItemAddEditState(
            initialData: note,
            description: note.description,
            content: note.content
        )
    );

    if (sl.isRegistered<GetNotesUsecase>()) {
      sl.unregister<GetNotesUsecase>();
    }
    sl.registerLazySingleton<GetNotesUsecase>(() => MockGetNotesUsecase());
    when(() => sl<GetNotesUsecase>()(any()))
        .thenAnswer((_) async => Right(tItems));

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

  group('CCS actions', () {
    Future<BuildContext> prepareSubject({required WidgetTester widgetTester}) async {
      sl<SettingsService>().appMainPage = MockNavigatorProvider(
        navigator: mockNavigator,
        child: BlocProvider.value(
          value: mockNotesBloc,
          child: const NotesPage(),
        ),
      );
      await widgetTester.pumpWidgetUnderTest();
      return widgetTester.element(find.byType(NotesPage));
    }

    group('CCS actionItemAdd', () {
      testWidgets('CCS actionItemAdd - check result', (widgetTester) async {
        expect(await notesSupport.actionItemAdd(
            context: await prepareSubject(widgetTester: widgetTester)
        ), equals(null));
      });

      testWidgets('CCS actionItemAdd - check refresh', (widgetTester) async {
        final BuildContext context = await prepareSubject(widgetTester: widgetTester);
        await notesSupport.actionItemAdd(context: context);
        verify(() => mockNotesBloc.add(const NotesSubscriptionRequestedEvent())).called(2);
      });
    });

    group('CCS actionItemDuplicate', () {
      testWidgets('CCS actionItemDuplicate - check result', (widgetTester) async {
        expect(await notesSupport.actionItemDuplicate(
            context: await prepareSubject(widgetTester: widgetTester),
            data: tItem
        ), equals(null));
      });

      testWidgets('CCS actionItemDuplicate - check refresh', (widgetTester) async {
        final BuildContext context = await prepareSubject(widgetTester: widgetTester);
        await notesSupport.actionItemDuplicate(context: context, data: tItem);
        verify(() => mockNotesBloc.add(const NotesSubscriptionRequestedEvent())).called(2);
      });
    });

    group('CCS actionItemEdit', () {
      testWidgets('CCS actionItemEdit - check result', (widgetTester) async {
        expect(await notesSupport.actionItemEdit(
            context: await prepareSubject(widgetTester: widgetTester),
            data: tItem
        ), equals(null));
      });

      testWidgets('CCS actionItemEdit - check refresh', (widgetTester) async {
        final BuildContext context = await prepareSubject(widgetTester: widgetTester);
        await notesSupport.actionItemEdit(context: context, data: tItem);
        verify(() => mockNotesBloc.add(const NotesSubscriptionRequestedEvent())).called(2);
      }, skip: true);
    });

    group('CCS actionItemDelete', () {
      // TODO: How can I mock confirm_dialog? Should I mock NotesSupport?
      testWidgets('CCS actionItemDelete - check result', (widgetTester) async {
        expect(await notesSupport.actionItemDelete(
            context: await prepareSubject(widgetTester: widgetTester),
            data: tItem
        ), equals(null));
      }, skip: true);

      testWidgets('CCS actionItemDelete - check refresh', (widgetTester) async {
        final BuildContext context = await prepareSubject(widgetTester: widgetTester);
        await notesSupport.actionItemDelete(context: context, data: tItem);
        await widgetTester.tapOnWidgetByText('OK');
        verify(() => mockNotesBloc.add(const NotesSubscriptionRequestedEvent())).called(1);
      });
    }, skip: true);

    group('CCS actionItemRefresh', () {
      testWidgets('CCS actionItemRefresh - check result', (widgetTester) async {
        expect(await notesSupport.actionItemRefresh(
          data: tItem,
          context: await prepareSubject(widgetTester: widgetTester),
        ), equals(null));
      });
    });

    group('CCS actionItemsRefresh', () {
      testWidgets('CCS actionItemsRefresh - check result', (widgetTester) async {
        expect(await notesSupport.actionItemsRefresh(
          context: await prepareSubject(widgetTester: widgetTester),
        ), equals(null));
      });
    });
  });
}