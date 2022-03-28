import 'package:bloc_test/bloc_test.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/links_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:http/http.dart' as http;

import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/get_links_usecase.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/bloc/links_bloc.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/links_page.dart';
import 'package:dev_framework_tutorial/src/features/settings/settings_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../common/test_helper.dart';
import '../../links_test_helper.dart';

void main() {
  // late LinksBloc bloc;
  late MockLinksBloc mockLinksBloc;
  late MockGetLinksUsecase mockGetLinksUsecase;

  setUpAll(() async {
    itgLogVerbose('setUpAll - start....');
    registerFallbackValue(FakeLinksState());
    registerFallbackValue(FakeLinksEvent());
    sl.registerLazySingleton<http.Client>(() => MockHttpClient());
    await initializeAppForTesting();
    // appMainPage = LinksPage(title: ItgLocalization.tr('Links'));
    sl<SettingsService>().appMainPage = const LinksPage();
    setUpHttpClientGetLinksSuccess200();
  });

  setUp(() async {
    itgLogVerbose('setUp - start....');
    mockGetLinksUsecase = MockGetLinksUsecase();
    mockLinksBloc = MockLinksBloc();
  });

  group('LinksList', () {
    testWidgets('page class', (widgetTester) async {
      // await widgetTester.testWidgetPageClass<LinksList>();
      await widgetTester.testWidgetPageClass<LinksView>();
    });

    testWidgets('renders CircularProgressIndicator when state is loading', (WidgetTester widgetTester) async {
      // when(() => mockLinksBloc.state).thenReturn(Loading());
      when(() => mockLinksBloc.state).thenReturn(
        const LinksState(
          status: LinksStatus.loading,
          items: []
        )
      );
      await widgetTester.pumpLinksList(mockLinksBloc);
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      expect(find.byKey(keyProgressIndicatorMain), findsOneWidget);
    });

    testWidgets('loading indicator is displayed while wait for data', (widgetTester) async {
      if (sl.isRegistered<GetLinksUsecase>()) {
        sl.unregister<GetLinksUsecase>();
      }
      sl.registerLazySingleton<GetLinksUsecase>(() => mockGetLinksUsecase);
      arrangeReturnsNLinksAfterNSecondsWait(mockGetLinksUsecase);

      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pump(const Duration(milliseconds: 500));
      expect(find.byKey(keyTextError), findsNothing);
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      expect(find.byKey(keyProgressIndicatorMain), findsOneWidget);
      await widgetTester.pump(const Duration(milliseconds: 1500));
    });

    testWidgets('renders no data message when success with empty list', (widgetTester) async {
      // when(() => mockLinksBloc.state).thenReturn(Empty());
      when(() => mockLinksBloc.state).thenReturn(
          const LinksState(
              status: LinksStatus.success,
              items: []
          )
      );
      await widgetTester.pumpLinksList(mockLinksBloc);
      expect(find.byKey(keyTextError), findsNothing);
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Links')), findsOneWidget);
    });

    testWidgets('renders (show) N items', (widgetTester) async {
      // the items (maybe) are more but it shows only N...
      // when(() => mockLinksBloc.state)
      //     .thenReturn(Loaded(links: mockLinks));
      when(() => mockLinksBloc.state).thenReturn(
          LinksState(
              status: LinksStatus.success,
              items: linksTestData()
          )
      );
      await widgetTester.pumpLinksList(mockLinksBloc);
      expect(find.byType(LinksListItem), findsNWidgets(4));
    });
  });

  group('Links list tests', () {
    testWidgets('render empty list', (widgetTester) async {
      // widgetTester.testRenderListEmpty(mockLinksBloc, [Loading(), const Loaded(links: []), Empty()], Empty(), LinksSubscriptionRequestedEvent());

      itgLogVerbose('before whenListen...');
      whenListen(
        mockLinksBloc,
        Stream.fromIterable([
          // const LinksState(),
          const LinksState(status: LinksStatus.initial),
          const LinksState(status: LinksStatus.failure),
        ])
      );
      itgLogVerbose('after whenListen...');

      await widgetTester.pumpLinksList(mockLinksBloc..add(const LinksSubscriptionRequestedEvent()));
      itgLogVerbose('after pumpLinksList...');
      await widgetTester.pumpAndSettle();
      // await widgetTester.pumpAndSettle();
      // await widgetTester.pumpAndSettle();
      // await widgetTester.pump(const Duration(seconds: 1));
      // await widgetTester.pump(const Duration(seconds: 1));
      // await widgetTester.pump(const Duration(seconds: 1));

      // expect(find.byType(LinksList), findsOneWidget);
      expect(find.byType(LinksView), findsOneWidget);
      itgLogVerbose('111...');
      expect(find.byKey(keyTextError), findsNothing);
      itgLogVerbose('222...');
      // expect(find.text(textMessageToDisplayNoData(dataModelName: 'Links')), findsOneWidget);
      itgLogVerbose('333...');
      await widgetTester.pump(const Duration(seconds: 1));
      itgLogVerbose('444...');
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      itgLogVerbose('555...');
      await widgetTester.pump(const Duration(seconds: 1));
      itgLogVerbose('666...');
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Links')), findsNothing);
      itgLogVerbose('777...');
      expect(find.byKey(keyListWidgetItemsData), findsOneWidget);
      itgLogVerbose('888...');
      await widgetTester.pump(const Duration(seconds: 1));
      itgLogVerbose('999...');
      expect(find.text(textMessageToDisplayNoData(dataModelName: 'Links')), findsOneWidget);
      itgLogVerbose('AAA...');
      expect(find.byKey(keyListWidgetItemsData), findsNothing);
      itgLogVerbose('BBB...');
    }, skip: true);
  });
}
