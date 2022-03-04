import 'package:flutter/material.dart';

class ItgCustom {
  MaterialColor colorAppMain = Colors.indigo;
  Color colorAppContrastMain = Colors.white;
  Color colorAppSecondary = Colors.amber;

  ThemeData getThemeAppMain(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: colorAppMain)
          .copyWith(secondary: colorAppSecondary),
      primaryColor: colorAppMain,
      appBarTheme: AppBarTheme(
          foregroundColor: colorAppContrastMain
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: colorAppContrastMain,
          backgroundColor: colorAppMain
      ),
    );
  }

}
