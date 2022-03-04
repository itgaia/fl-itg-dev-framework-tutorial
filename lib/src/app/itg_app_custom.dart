import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../common/helper.dart';
import '../common/itg_custom.dart';
import '../common/itg_localization.dart';
import 'constants.dart';

Map<String, Map<String, String>> _localizedValues = {
  'en': {
    'appWindowTitle': 'DEVFWRK_TUT_P1',
    'appTitle': 'Dev Framework Tutorial (part 1)',
  },
};

void customizeApp() {
  itgLogVerbose('[ItgAppCustom.customizeApp]');
  _localizedValues['el'] = {
    'appWindowTitle': _localizedValues['en']!['appWindowTitle']!,
    'appTitle': _localizedValues['en']!['appTitle']!
  };
  ItgLocalization.custom(_localizedValues);
  debugPaintSizeEnabled = appDebugPaintSizeEnabled;
}

class ItgAppCustom extends ItgCustom {
  // TODO: refactor in order not to override fields!
  @override
  MaterialColor colorAppMain = Colors.orange;

  @override
  Color colorAppSecondary = Colors.lightGreen;
}
