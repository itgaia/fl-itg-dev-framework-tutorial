import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app/constants.dart';

void itgLogVerbose(String msg) {
  if (appDebugMode) {
    if (kDebugMode) {
      print(msg);
    }
  }
}

void itgLogWarning(String msg) => itgLogVerbose(msg);

void itgLogError(String msg) {
  if (kDebugMode) {
    print('*** Error: $msg');
  }
}

Text widgetText(BuildContext context, String text, {required Key key}) {
  return Text(
      text,
      style: TextStyle(
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.green.shade900
            : Colors.green,
        fontWeight: FontWeight.w600,
        fontSize: 24.0,
      ),
      textAlign: TextAlign.center,
      key: key
  );
}

