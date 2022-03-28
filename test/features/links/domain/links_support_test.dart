import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/core/usecase/usecase.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_model.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/links_support.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/get_links_usecase.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/add_edit/bloc/links_item_add_edit_bloc.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/add_edit/links_item_add_edit_page.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/bloc/links_bloc.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/links_page.dart';
import 'package:dev_framework_tutorial/src/features/settings/settings_service.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../common/test_helper.dart';
import '../links_test_helper.dart';

void main() {
  final LinksModel link = linksTestData().first;
  final LinksBloc mockLinksBloc = MockLinksBloc();
  final tItems = linksTestData();
  final tItem = tItems.first;

  late MockNavigator mockNavigator;
  late LinksSupport linksSupport;
  late LinksItemAddEditBloc mockLinksItemAddEditBloc;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() async {
    linksSupport = LinksSupport();
    mockNavigator = MockNavigator();
    when(() => mockNavigator.push(any())).thenAnswer((_) async => null);

    when(() => mockLinksBloc.add(const LinksSubscriptionRequestedEvent()))
        .thenAnswer((_) async { });

    mockLinksItemAddEditBloc = MockLinksItemAddEditBloc();
    when(() => mockLinksItemAddEditBloc.state).thenReturn(
        LinksItemAddEditState(
            initialData: link,
            description: link.description,
            notes: link.notes,
        )
    );

    if (sl.isRegistered<GetLinksUsecase>()) {
      sl.unregister<GetLinksUsecase>();
    }
    sl.registerLazySingleton<GetLinksUsecase>(() => MockGetLinksUsecase());
    when(() => sl<GetLinksUsecase>()(any()))
        .thenAnswer((_) async => Right(tItems));

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

  group('LNS actions', () {
    Future<BuildContext> prepareSubject({required WidgetTester widgetTester}) async {
      sl<SettingsService>().appMainPage = MockNavigatorProvider(
        navigator: mockNavigator,
        child: BlocProvider.value(
          value: mockLinksBloc,
          child: const LinksPage(),
        ),
      );
      await widgetTester.pumpWidgetUnderTest();
      return widgetTester.element(find.byType(LinksPage));
    }

    group('LNS actionItemAdd', () {
      testWidgets('LNS actionItemAdd - check result', (widgetTester) async {
        expect(await linksSupport.actionItemAdd(
            context: await prepareSubject(widgetTester: widgetTester)
        ), equals(null));
      });

      testWidgets('LNS actionItemAdd - check refresh', (widgetTester) async {
        final BuildContext context = await prepareSubject(widgetTester: widgetTester);
        await linksSupport.actionItemAdd(context: context);
        verify(() => mockLinksBloc.add(const LinksSubscriptionRequestedEvent())).called(2);
      });
    });

    group('LNS actionItemDuplicate', () {
      testWidgets('LNS actionItemDuplicate - check result', (widgetTester) async {
        expect(await linksSupport.actionItemDuplicate(
            context: await prepareSubject(widgetTester: widgetTester),
            data: tItem
        ), equals(null));
      });

      testWidgets('LNS actionItemDuplicate - check refresh', (widgetTester) async {
        final BuildContext context = await prepareSubject(widgetTester: widgetTester);
        await linksSupport.actionItemDuplicate(context: context, data: tItem);
        verify(() => mockLinksBloc.add(const LinksSubscriptionRequestedEvent())).called(2);
      });
    });

    group('LNS actionItemEdit', () {
      testWidgets('LNS actionItemEdit - check result', (widgetTester) async {
        expect(await linksSupport.actionItemEdit(
            context: await prepareSubject(widgetTester: widgetTester),
            data: tItem
        ), equals(null));
      });

      testWidgets('LNS actionItemEdit - check refresh', (widgetTester) async {
        final BuildContext context = await prepareSubject(widgetTester: widgetTester);
        await linksSupport.actionItemEdit(context: context, data: tItem);
        verify(() => mockLinksBloc.add(const LinksSubscriptionRequestedEvent())).called(2);
      }, skip: true);
    });

    group('LNS actionItemDelete', () {
      // TODO: How can I mock confirm_dialog? Should I mock LinksSupport?
      testWidgets('LNS actionItemDelete - check result', (widgetTester) async {
        expect(await linksSupport.actionItemDelete(
            context: await prepareSubject(widgetTester: widgetTester),
            data: tItem
        ), equals(null));
      }, skip: true);

      testWidgets('LNS actionItemDelete - check refresh', (widgetTester) async {
        final BuildContext context = await prepareSubject(widgetTester: widgetTester);
        await linksSupport.actionItemDelete(context: context, data: tItem);
        await widgetTester.tapOnWidgetByText('OK');
        verify(() => mockLinksBloc.add(const LinksSubscriptionRequestedEvent())).called(1);
      });
    }, skip: true);

    group('LNS actionItemRefresh', () {
      testWidgets('LNS actionItemRefresh - check result', (widgetTester) async {
        expect(await linksSupport.actionItemRefresh(
          data: tItem,
          context: await prepareSubject(widgetTester: widgetTester),
        ), equals(null));
      });
    });

    group('LNS actionItemsRefresh', () {
      testWidgets('LNS actionItemsRefresh - check result', (widgetTester) async {
        expect(await linksSupport.actionItemsRefresh(
          context: await prepareSubject(widgetTester: widgetTester),
        ), equals(null));
      });
    });
  });
}