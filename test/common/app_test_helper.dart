// Contains the support code (objects, functions, constants, variables)
// used for the testing of this particular app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension ItgAppAddedFunctionality on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MaterialApp(
          home: Scaffold(body: widget),
        ),
    );
  }

  Future<void> pumpRoute(Route<dynamic> route) {
    // TODO: I could use also pumpBasicMaterialAppWithWidget...
    return pumpApp(
      Navigator(onGenerateRoute: (_) => route),
    );
  }
}

