import 'package:dev_framework_tutorial/src/app/app.dart';
import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/app/custom_button.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/features/settings/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension ItgAddedFunctionality on WidgetTester {
  Future<void> pumpWidgetUnderTest() async {
    itgLogVerbose('WidgetTester.pumpWidgetUnderTest - start - appMainPage: ${sl<SettingsService>().appMainPage}');
    await pumpWidget(const App());
  }

  Future<void> testWidgetPageClass<T>() async {
    await pumpWidgetUnderTest();
    await pumpAndSettle();
    expect(find.byType(T), findsWidgets);
  }

  Future<void> testWidgetPageTitle(title) async {
    await pumpWidgetUnderTest();
    expect(find.byKey(keyTextPageTitle), findsOneWidget);
    expect(find.text(title), findsOneWidget);
  }

  Future<void> testWidgetText(text, key) async {
    await pumpWidgetUnderTest();
    expect(find.byKey(key), findsOneWidget);
    expect(find.text(text), findsOneWidget);
  }

  Future<void> testWidgetButton(text, key) async {
    await pumpWidgetUnderTest();
    expect(find.byKey(key), findsOneWidget);
    expect(find.text(text), findsOneWidget);
    expect(find.byType(CustomButton), findsWidgets);
  }

  Future<void> testWidgetTheme({required Brightness brightness}) async {
   // to be implemented...
  }
}
