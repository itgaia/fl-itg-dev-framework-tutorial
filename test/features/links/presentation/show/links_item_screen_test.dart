import 'package:dev_framework_tutorial/src/features/links/domain/links_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/show/links_item_screen.dart';
import 'package:dev_framework_tutorial/src/features/settings/settings_service.dart';

import '../../../../common/test_helper.dart';
import '../../links_test_helper.dart';

void main() {
  setUp(() async {
    itgLogVerbose('Links Item Page test - SetUp - Start...');
    await initializeAppForTesting();
    sl<SettingsService>().appMainPage = LinksItemScreen(data: linksTestData().first);
  });

  group('LinksItemScreen', () {
    testWidgets('LNIS page class', (widgetTester) async {
      await widgetTester.testWidgetPageClass<LinksItemScreen>();
    });

    testWidgets('LNIS render Link fields', (WidgetTester widgetTester) async {
      // List<LinksModel> data = linksTestData();
      await widgetTester.pumpWidgetUnderTest();
      await widgetTester.pumpAndSettle();

      expect(find.byKey(const Key('$keyLinksWidgetItemShowBase-col1-id')), findsOneWidget);
      expect(find.byKey(const Key('$keyLinksWidgetItemShowBase-col1-description')), findsOneWidget);
      expect(find.byKey(const Key('$keyLinksWidgetItemShowBase-col1-notes')), findsOneWidget);
    });
  });
}