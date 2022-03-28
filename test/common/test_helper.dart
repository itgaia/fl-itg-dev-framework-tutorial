import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:http/http.dart' as http;

import 'package:dev_framework_tutorial/src/app/app.dart';
import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/app/custom_button.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/features/settings/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockHttpClient extends Mock implements http.Client {}

const msgBaseSourceClass = 'test_helper';
String msgBaseSourceMethod = '';
void msgLogInfo(String msg) => itgLogVerbose('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');

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

  Future<void> testNavigateToPage<T>(key, {bool initializeWidget = true}) async {
    msgBaseSourceMethod = 'testNavigateToPage';
    if (initializeWidget) await pumpWidgetUnderTest();
    expect(find.byKey(key), findsOneWidget);
    await tapOnWidget(key);
    msgLogInfo('button "${keyName(key)}" pressed....');
    // await Future.delayed(const Duration(seconds: 5));
    expect(find.byType(T), findsOneWidget);
  }

  Future<void> testNavigateToPageByText<T>(text, {bool initializeWidget = true}) async {
    msgBaseSourceMethod = 'testNavigateToPage';
    if (initializeWidget) await pumpWidgetUnderTest();
    await tapOnWidgetByText(text, waitToSettle: true);
    msgLogInfo('button "$text" pressed....');
    await Future.delayed(const Duration(seconds: 5));
    expect(find.byType(T), findsOneWidget);
  }

  Future<void> testWidgetTheme({required Brightness brightness}) async {
   // to be implemented...
  }

  Future<void> tapOnWidget(key) async {
    expect(find.byKey(key), findsOneWidget);
    await tap(find.byKey(key));
    await pumpAndSettle();
  }

  Future<void> tapOnWidgetByText(String text, {bool waitToSettle = false}) async {
    expect(find.text(text), findsOneWidget);
    await tap(find.text(text));
    if (waitToSettle) {
      await pumpAndSettle();
    } else {
      await pump();
    }
  }

  Future<void> testRenderWidget<T>(key) async {
    await pumpWidgetUnderTest();
    await pump();
    expect(find.byType(T), findsOneWidget);
    expect(find.byKey(key), findsOneWidget);
    // await pump();
  }

  /// Works also for text as part of the field value
  void testClassAndContentForTextFormField({required Key key, required String text}) {
    final target = widget<TextFormField>(find.byKey(key));
    itgLogVerbose('[testClassAndContentForTextFormField] target.initialValue: ${target.initialValue}');
    expect(
      target.initialValue,
      isA<String>().having((text) => text, 'text', contains(text)),
    );
  }
}

Future<void> initializeAppForTesting() async {
  SharedPreferences.setMockInitialValues({});
  await initializeApp(forTesting: true);
}

void arrangeHttpClientGetReturnSuccess200({required String url, required String response}) {
  itgLogVerbose('[arrangeHttpClientGetReturnSuccess200] url: $url, response: $response');
  when(() => sl<http.Client>().get(Uri.parse(url), headers: any(named: 'headers')))
      .thenAnswer((_) async => http.Response(response, 200));
}

void arrangeHttpClientGetReturnFailure404({required String url}) {
  when(() => sl<http.Client>().get(Uri.parse(url), headers: any(named: 'headers')))
      .thenAnswer((_) async => http.Response('Something went wrong', 404));
}

void arrangeHttpClientGetReturnException({required String url, Duration wait = const Duration(seconds: 0)}) {
  const String baseLogMsg = '[arrangeHttpClientGetReturnException]';
  if (wait.inMicroseconds == 0) {
    itgLogVerbose('$baseLogMsg (no wait) - url: $url');
    when(() => sl<http.Client>().get(Uri.parse(url), headers: any(named: 'headers')))
        .thenThrow(Exception(textSampleException));
  } else {
    itgLogVerbose('$baseLogMsg (wait: $wait) - url: $url');
    when(() => sl<http.Client>().get(Uri.parse(url), headers: any(named: 'headers')))
        .thenAnswer((_) async {
      await Future.delayed(wait);
      throw Exception(textSampleException);
    });
  }
}

void arrangeHttpClientPostReturnSuccess200({required String url, required String response}) {
  when(() => sl<http.Client>().post(Uri.parse(url), headers: any(named: 'headers'), body: any(named: 'body')))
      .thenAnswer((_) async => http.Response(response, 200));
}

void arrangeHttpClientPostReturnFailure404({required String url}) {
  when(() => sl<http.Client>().post(Uri.parse(url), headers: any(named: 'headers'), body: any(named: 'body')))
      .thenAnswer((_) async => http.Response('Something went wrong', 404));
}

void arrangeHttpClientPostReturnException({required String url, Duration wait = const Duration(seconds: 0)}) {
  const String baseLogMsg = '[arrangeHttpClientPostReturnException]';
  if (wait.inMicroseconds == 0) {
    itgLogVerbose('$baseLogMsg (no wait) - url: $url');
    when(() => sl<http.Client>().post(Uri.parse(url), headers: any(named: 'headers'), body: any(named: 'body')))
        .thenThrow(Exception(textSampleException));
  } else {
    itgLogVerbose('$baseLogMsg (wait: $wait) - url: $url');
    when(() => sl<http.Client>().post(Uri.parse(url), headers: any(named: 'headers'), body: any(named: 'body'))).thenAnswer((_) async {
      await Future.delayed(wait);
      throw Exception(textSampleException);
    });
  }
}

void arrangeHttpClientPutReturnSuccess204({required String url, required String response}) {
  itgLogVerbose('[arrangeHttpClientPutReturnSuccess204] url: $url, response: $response');
  when(() => sl<http.Client>().put(Uri.parse(url), headers: any(named: 'headers'), body: any(named: 'body')))
      .thenAnswer((_) async => http.Response(response, 204));
}

void arrangeHttpClientPutReturnFailure404({required String url}) {
  when(() => sl<http.Client>().put(Uri.parse(url), headers: any(named: 'headers'), body: any(named: 'body')))
      .thenAnswer((_) async => http.Response('Something went wrong', 404));
}

void arrangeHttpClientPutReturnException({required String url, Duration wait = const Duration(seconds: 0)}) {
  const String baseLogMsg = '[arrangeHttpClientPutReturnException]';
  if (wait.inMicroseconds == 0) {
    itgLogVerbose('$baseLogMsg (no wait) - url: $url');
    when(() => sl<http.Client>().put(Uri.parse(url), headers: any(named: 'headers'), body: any(named: 'body')))
        .thenThrow(Exception(textSampleException));
  } else {
    itgLogVerbose('$baseLogMsg (wait: $wait) - url: $url');
    when(() => sl<http.Client>().put(Uri.parse(url), headers: any(named: 'headers'), body: any(named: 'body'))).thenAnswer((_) async {
      await Future.delayed(wait);
      throw Exception(textSampleException);
    });
  }
}

void arrangeHttpClientDeleteReturnSuccess204({required String url, required String response}) {
  itgLogVerbose('[arrangeHttpClientDeleteReturnSuccess204] url: $url, response: $response');
  when(() => sl<http.Client>().delete(Uri.parse(url), headers: any(named: 'headers'), body: any(named: 'body')))
      .thenAnswer((_) async => http.Response(response, 204));
}

void arrangeHttpClientDeleteReturnFailure404({required String url}) {
  when(() => sl<http.Client>().delete(Uri.parse(url), headers: any(named: 'headers'), body: any(named: 'body')))
      .thenAnswer((_) async => http.Response('Something went wrong', 404));
}

void arrangeHttpClientDeleteReturnException({required String url, Duration wait = const Duration(seconds: 0)}) {
  const String baseLogMsg = '[arrangeHttpClientDeleteReturnException]';
  if (wait.inMicroseconds == 0) {
    itgLogVerbose('$baseLogMsg (no wait) - url: $url');
    when(() => sl<http.Client>().delete(Uri.parse(url), headers: any(named: 'headers'), body: any(named: 'body')))
        .thenThrow(Exception(textSampleException));
  } else {
    itgLogVerbose('$baseLogMsg (wait: $wait) - url: $url');
    when(() => sl<http.Client>().delete(Uri.parse(url), headers: any(named: 'headers'), body: any(named: 'body'))).thenAnswer((_) async {
      await Future.delayed(wait);
      throw Exception(textSampleException);
    });
  }
}
