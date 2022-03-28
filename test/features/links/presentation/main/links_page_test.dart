import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/links_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';
import 'package:dev_framework_tutorial/src/core/usecase/usecase.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/add_edit/links_item_add_edit_page.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/bloc/links_bloc.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/show/links_item_show_page.dart';
import 'package:dev_framework_tutorial/src/features/settings/settings_service.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:http/http.dart' as http;
import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/get_links_usecase.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/links_page.dart';

import '../../../../common/app_test_helper.dart';
import '../../../../common/test_helper.dart';
import '../../links_test_helper.dart';

void main() {
  final tData = linksTestData();
  late FakeLinksState fakeLinksState;
  late FakeLinksEvent fakeLinksEvent;

  setUpAll(() {
    fakeLinksState = FakeLinksState();
    fakeLinksEvent = FakeLinksEvent();
    registerFallbackValue(fakeLinksState);
    registerFallbackValue(fakeLinksEvent);
    registerFallbackValue(NoParams());
    sl.registerLazySingleton<http.Client>(() => MockHttpClient());
  });

  setUp(() async {
    itgLogVerbose('Links Page test - SetUp - Start...');
    await initializeAppForTesting();
    if (sl.isRegistered<GetLinksUsecase>()) {
      sl.unregister<GetLinksUsecase>();
    }
    sl.registerLazySingleton<GetLinksUsecase>(() => MockGetLinksUsecase());
    sl<SettingsService>().appMainPage = const LinksPage();
    when(() => sl<GetLinksUsecase>()(any()))
      .thenAnswer((_) async => Right(tData));
  });

  group('Links page tests', () {
    test('LNP correct route name', () {
      expect(LinksPage.routeName, '/links');
    });

    testWidgets('LNP page class', (widgetTester) async {
      await widgetTester.testWidgetPageClass<LinksPage>();
    });

    testWidgets('LNP page title', (widgetTester) async {
      await widgetTester.testWidgetPageTitle(appTitleLinks);
    });

    testWidgets('LNP show floating actions', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();

      expect(find.byKey(const Key('$keyLinksWidgetListItemBase-floating-actions')), findsOneWidget);
      expect(find.byKey(Key('$keyLinksWidgetListItemBase-$keyFloatingActionRefresh')), findsOneWidget);
      expect(find.byKey(Key('$keyLinksWidgetListItemBase-$keyFloatingActionAdd')), findsOneWidget);
      expect(find.byKey(Key('$keyLinksWidgetListItemBase-$keyFloatingActionEdit')), findsNothing);
      expect(find.byKey(Key('$keyLinksWidgetListItemBase-$keyFloatingActionDuplicate')), findsNothing);
      expect(find.byKey(Key('$keyLinksWidgetListItemBase-$keyFloatingActionDelete')), findsNothing);
    });

    testWidgets('subscribes to items from usecase on initialization', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();
      verify(() => sl<GetLinksUsecase>().call(any())).called(1);
    });
  });

  group('Links View tests', () {
    late MockNavigator mockNavigator;
    late LinksBloc mockLinksBloc;

    setUp(() {
      mockNavigator = MockNavigator();
      when(() => mockNavigator.push(any())).thenAnswer((_) async => null);

      mockLinksBloc = MockLinksBloc();
      when(() => mockLinksBloc.state).thenReturn(
        LinksState(
          status: LinksStatus.success,
          items: tData
        )
      );

      // usecase with empty data... is it needed?
    });

    Widget buildSubject() {
      return MockNavigatorProvider(
        navigator: mockNavigator,
        child: BlocProvider.value(
          value: mockLinksBloc,
          child: const LinksView()
        )
      );
    }

    testWidgets('renders AppBar with title text', (widgetTester) async {
      await widgetTester.pumpApp(buildSubject(),);

        expect(find.byType(AppBar), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text(appTitleLinks),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('renders error text when status changes to failure', (widgetTester) async {
        whenListen<LinksState>(
          mockLinksBloc,
          Stream.fromIterable([
            const LinksState(),
            const LinksState(
              status: LinksStatus.failure,
            ),
          ]),
        );

        await widgetTester.pumpApp(buildSubject(),);
        await widgetTester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(SnackBar),
            matching: find.text(textMessageToDisplayError(dataModelName: 'Links', errorMessage: '')),
          ),
          findsOneWidget
        );
      },
    );

    group('LinkDeletionConfirmationSnackBar', () {
      setUp(() {
        when(() => mockLinksBloc.state)
          .thenReturn(LinksState(lastDeletedItem: tData.first));
        whenListen<LinksState>(
          mockLinksBloc,
          Stream.fromIterable([
            const LinksState(),
            LinksState(
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
        'adds LinksSubscriptionRequestedEvent '
        'to LinksBloc '
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

          verify(() => mockLinksBloc.add(
            const LinksSubscriptionRequestedEvent(),
          )).called(1);
        }, skip: true);
    });

    group('when items is empty', () {
      setUp(() {
        when(() => mockLinksBloc.state)
          .thenReturn(const LinksState());
      });

      testWidgets('renders nothing when status is initial or error', (widgetTester) async {
          await widgetTester.pumpApp(buildSubject());

          expect(find.byType(ListView), findsNothing);
          expect(find.byType(CupertinoActivityIndicator), findsNothing);
        },
      );

      testWidgets('renders loading indicator when status is loading', (widgetTester) async {
          when(() => mockLinksBloc.state).thenReturn(
            const LinksState(status: LinksStatus.loading),
          );

          await widgetTester.pumpApp(buildSubject());

          expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
        },
      );

      testWidgets('renders items empty text when status is success', (widgetTester) async {
          when(() => mockLinksBloc.state).thenReturn(
            const LinksState(status: LinksStatus.success),
          );

          await widgetTester.pumpApp(buildSubject());

          expect(find.text(appTitleLinks), findsOneWidget);
        },
      );
    });
  });

  group('Links Page list tests', () {
    testWidgets('LNP renders list widget', (widgetTester) async {
      widgetTester.testRenderWidget<LinksView>(keyItemsListWidget);
    });

    testWidgets('LNP render empty list', (widgetTester) async {
      arrangeReturnsNLinksAfterNSecondsWait(sl<GetLinksUsecase>(), count: 0);
      await widgetTester.pumpWidgetUnderTest();

      expect(find.byType(LinksView), findsOneWidget);
      expect(find.byKey(keyTextError), findsNothing);
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Links')), findsNothing);
      expect(find.byType(CupertinoActivityIndicator), findsNothing);
      await widgetTester.pump();
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Links')), findsNothing);
      await widgetTester.pumpAndSettle();
      expect(find.byType(CupertinoActivityIndicator), findsNothing);
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Links')), findsOneWidget);
      expect(find.byKey(keyListWidgetItemsData), findsNothing);
      await widgetTester.pump();
      sl.unregister<GetLinksUsecase>();
      await widgetTester.pump();
    });

    testWidgets('LNP render list', (widgetTester) async {
      arrangeReturnsNLinksAfterNSecondsWait(sl<GetLinksUsecase>());
      await widgetTester.pumpWidgetUnderTest();

      expect(find.byType(LinksView), findsOneWidget);
      expect(find.byKey(keyTextError), findsNothing);
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Links')), findsNothing);
      await widgetTester.pump();
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      await widgetTester.pump(const Duration(seconds: 2));
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Links')), findsNothing);
      expect(find.byKey(keyItemsListWidget), findsOneWidget);
      await widgetTester.pump();
      sl.unregister<GetLinksUsecase>();
      await widgetTester.pump();
    });

    testWidgets('LNP render error', (widgetTester) async {
      // arrangeLinksUsecaseReturnException(sl<GetLinksUsecase>());
      when(() => sl<GetLinksUsecase>()(any()))
          .thenAnswer((_) async => const Left(ServerFailure(code: '111')));
      await widgetTester.pumpWidgetUnderTest();

      expect(find.byType(LinksView), findsOneWidget);
      expect(find.byKey(keyTextError), findsNothing);
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Links')), findsNothing);
      await widgetTester.pump();
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Links')), findsNothing);
      expect(find.byKey(keyListWidgetItemsData), findsNothing);
      expect(find.byKey(keyTextError), findsOneWidget);
      expect(find.text(
          // textMessageToDisplayError(dataModelName: 'Links', errorMessage: const ServerFailure(description: 'Exception: $textSampleException').toString())),
          textMessageToDisplayError(dataModelName: 'Links', errorMessage: '')),
          findsOneWidget
      );
      await widgetTester.pump();
      sl.unregister<GetLinksUsecase>();
      await widgetTester.pump();
    });
  });

  group('Links Page actions', (){
    testWidgets('LNP - action - add', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();

      await widgetTester.tapOnWidget(Key('$keyLinksWidgetListItemBase-$keyFloatingActionAdd'));
      expect(find.byType(LinksItemAddEditPage), findsOneWidget);
      expect(find.text(textSampleContent), findsNothing);
    });

    testWidgets('LNP - action - refresh', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      itgLogVerbose('LNP - action - refresh - before press refresh');
      await widgetTester.tapOnWidget(Key('$keyLinksWidgetListItemBase-$keyFloatingActionRefresh'));
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpAndSettle();
      expect(find.byType(LinksPage), findsOneWidget);
      expect(find.byType(LinksItemAddEditPage), findsNothing);
      expect(find.text(textSampleContent), findsNothing);

      verify(() => sl<GetLinksUsecase>().call(any())).called(2);
    }, skip: false);
  });

  group('Links List Item actions', (){
    testWidgets('LNLI - action - show', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      await widgetTester.tapOnWidget(Key('$keyLinksWidgetListItemBase-1-$keyActionShow'));
      expect(find.byType(LinksItemShowPage), findsOneWidget);
      expect(find.text(textSampleContent), findsNothing);
    });

    testWidgets('LNLI - action - edit', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      await widgetTester.tapOnWidget(const Key('$keyLinksWidgetListItemBase-1-action-edit'));
      expect(find.byType(LinksItemAddEditPage), findsOneWidget);
      expect(find.text(textSampleContent), findsNothing);
    });

    testWidgets('LNLI - action - duplicate', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      await widgetTester.tapOnWidget(const Key('$keyLinksWidgetListItemBase-1-action-duplicate'));
      expect(find.byType(LinksItemAddEditPage), findsOneWidget);
      expect(find.text(textSampleContent), findsNothing);
      expect(find.byKey(keyTextPageTitle), findsOneWidget);
      expect(find.text(appTitleLinksItemDuplicatePage), findsOneWidget);
      expect(find.byKey(const Key('$keyLinksWidgetItemAddEditBase-col1-description')), findsOneWidget);
      widgetTester.testClassAndContentForTextFormField(key: const Key('$keyLinksWidgetItemAddEditBase-col1-description'), text: textTitleSuffixDuplicate);
    });

    testWidgets('LNLI - action - delete', (widgetTester) async {
      arrangeLinksItemDeleteUsecaseReturnSuccess();

      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      await widgetTester.tapOnWidget(const Key('$keyLinksWidgetListItemBase-1-action-delete'));
      await widgetTester.tapOnWidgetByText('OK');

      expect(find.byKey(keyNotificationSuccess), findsOneWidget);
      expect(find.text('Link has been deleted'), findsOneWidget);
      expect(find.byKey(keyNotificationFailure), findsNothing);
      expect(find.byType(LinksItemShowPage), findsNothing);
      expect(find.byType(LinksPage), findsOneWidget);
    });
  });
}