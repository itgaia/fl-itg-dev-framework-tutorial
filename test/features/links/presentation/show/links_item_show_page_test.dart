import 'package:dev_framework_tutorial/src/features/links/domain/links_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/common/itg_localization.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_model.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/add_edit/links_item_add_edit_page.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/bloc/links_bloc.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/links_page.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/show/links_item_show_page.dart';
import 'package:dev_framework_tutorial/src/features/settings/settings_service.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../../common/test_helper.dart';
import '../../links_test_helper.dart';

const tagFull = 'Links Item Show Page';
const tagShort = r'NISP';

void main() {
  final List<LinksModel> tItems = linksTestData();
  final LinksModel tData = tItems.first;
  late MockLinksBloc mockLinksBloc;
  late MockNavigator mockNavigator;

  setUp(() async {
    itgLogVerbose(r'Links Item Show Page test - SetUp - Start...');

    mockNavigator = MockNavigator();
    // when(() => mockNavigator.push(any())).thenAnswer((_) async => null);

    mockLinksBloc = MockLinksBloc();
    when(() => mockLinksBloc.state).thenReturn(LinksState(
      status: LinksStatus.success,
      items: tItems
    ));

    await initializeAppForTesting();
    sl<SettingsService>().appMainPage = BlocProvider<LinksBloc>.value(
      value: mockLinksBloc,
      child: LinksItemShowPage(title: ItgLocalization.tr('LinksItem'), item: tData),
    );
  });

  group('Links Item Show Page tests', (){
    test('NISP correct route name', () {
      expect(LinksItemShowPage.routeName, '/links_item');
    });

    testWidgets('NISP page class', (widgetTester) async {
      await widgetTester.testWidgetPageClass<LinksItemShowPage>();
    });

    testWidgets('NISP page title', (widgetTester) async {
      await widgetTester.testWidgetPageTitle(appTitleLinksItem);
    });

    testWidgets('NISP show actions', (widgetTester) async {
      // TODO: check with allowXXXX set to false or true....
      // if (sl.isRegistered<LinksSupport>()) {
      //   sl.unregister<LinksSupport>();
      // }
      // sl.registerLazySingleton<LinksSupport>(() => mockLinksSupport);
      //
      // when(() => mockLinksSupport(any())).thenReturn(LinksSupport());
      // when(() => mockLinksSupport.allowRefresh).thenReturn(true);

      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      expect(find.byKey(const Key('$keyLinksWidgetItemShowBase-floating-actions')), findsOneWidget);
      expect(find.byKey(Key('$keyLinksWidgetItemShowBase-$keyFloatingActionRefresh')), findsOneWidget);
      expect(find.byKey(Key('$keyLinksWidgetItemShowBase-$keyFloatingActionEdit')), findsOneWidget);
      expect(find.byKey(Key('$keyLinksWidgetItemShowBase-$keyFloatingActionDuplicate')), findsOneWidget);
      expect(find.byKey(Key('$keyLinksWidgetItemShowBase-$keyFloatingActionAdd')), findsOneWidget);
      expect(find.byKey(Key('$keyLinksWidgetItemShowBase-$keyFloatingActionDelete')), findsOneWidget);
    });
  });

  group('Links Item Show Page actions', (){
    testWidgets('NISP action edit', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      await widgetTester.tapOnWidget(Key('$keyLinksWidgetItemShowBase-$keyFloatingActionEdit'));
      expect(find.byType(LinksItemAddEditPage), findsOneWidget);
      expect(find.text(textSampleContent), findsNothing);
    });

    testWidgets('NISP action duplicate', (widgetTester) async {
      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      await widgetTester.tapOnWidget(Key('$keyLinksWidgetItemShowBase-$keyFloatingActionDuplicate'));
      expect(find.byType(LinksItemAddEditPage), findsOneWidget);
      expect(find.text(textSampleContent), findsNothing);
      expect(find.byKey(keyTextPageTitle), findsOneWidget);
      expect(find.text(appTitleLinksItemDuplicatePage), findsOneWidget);
      expect(find.byKey(const Key('$keyLinksWidgetItemAddEditBase-col1-description')), findsOneWidget);
      widgetTester.testClassAndContentForTextFormField(key: const Key('$keyLinksWidgetItemAddEditBase-col1-description'), text: textTitleSuffixDuplicate);
    });

    group('Links Item Show Page action delete', () {
      setUp(() {
        arrangeLinksItemDeleteUsecaseReturnSuccess();
      });

      testWidgets('NISP action delete', (widgetTester) async {
        await widgetTester.pumpWidgetUnderTest();
        await widgetTester.pumpAndSettle();

        await widgetTester.tapOnWidget(Key('$keyLinksWidgetItemShowBase-$keyFloatingActionDelete'));
        await widgetTester.tapOnWidgetByText('OK');
        // await widgetTester.pumpAndSettle();

        expect(find.byKey(keyNotificationSuccess), findsOneWidget);
        expect(find.text('Link has been deleted'), findsOneWidget);
        expect(find.byKey(keyNotificationFailure), findsNothing);
        expect(find.byType(LinksItemShowPage), findsOneWidget);
        expect(find.byType(LinksPage), findsNothing);
      });

      testWidgets('NISP pops when deleted successfully', (widgetTester) async {
        when(() => mockNavigator.push(any())).thenAnswer((_) async => null);
        // TODO: When I use the MockNavigatorProvider then the process does not
        //       continue after the confirm_dialog... Why?
        sl<SettingsService>().appMainPage = MockNavigatorProvider(
            navigator: mockNavigator,
            child: BlocProvider<LinksBloc>.value(
              value: mockLinksBloc,
              child: LinksItemShowPage(title: ItgLocalization.tr('LinksItem'), item: tData),
            )
        );

        await widgetTester.pumpWidgetUnderTest();
        await widgetTester.pumpAndSettle();

        await widgetTester.tapOnWidget(Key('$keyLinksWidgetItemShowBase-$keyFloatingActionDelete'));
        await widgetTester.tapOnWidgetByText('OK');
        await widgetTester.pumpAndSettle();
        await widgetTester.pumpAndSettle();
        await widgetTester.pumpAndSettle();

        verify(() => mockNavigator.pop(any<dynamic>())).called(1);
      }, skip: false);
    });

    testWidgets('NISP action refresh', (widgetTester) async {
      // if (sl.isRegistered<LinksSupport>()) {
      //   sl.unregister<LinksSupport>();
      // }
      // // sl.registerLazySingleton<LinksSupport>(() => mockLinksSupport);
      // sl.registerLazySingleton<LinksSupport>(() => MockLinksSupport());
      //
      // when(() => sl<LinksSupport>().actionItemRefresh(data: any(named: "data")))
      //   .thenAnswer((_) => Future.value(true));
      // when(() => sl<LinksSupport>().allowRefresh).thenReturn(true);

      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      await widgetTester.tapOnWidget(Key('$keyLinksWidgetItemShowBase-$keyFloatingActionRefresh'));
      expect(find.byType(LinksItemShowPage), findsOneWidget);
      expect(find.byType(LinksPage), findsNothing);
      expect(find.text(textSampleContent), findsNothing);

      // verify(() => sl<LinksSupport>().actionItemRefresh(data: any(named: "data"))).called(1);
      // verify(() => sl<LinksSupport>().allowRefresh).called(1);
    });
  });
}