import 'package:flutter/material.dart';

import 'constants.dart';
import 'injection_container.dart' as di;
import 'app_config.dart';
import 'injection_container.dart';
import 'itg_app_custom.dart';
import '../common/helper.dart';
import '../common/itg_localization.dart';
import '../features/home/home_page.dart';
import '../features/settings/settings_controller.dart';
import '../features/settings/settings_service.dart';
import '../features/settings/settings_view.dart';

Future<void> initializeApp({bool forTesting = false}) async {
  const String baseLogMsg = '[initializeApp]';
  itgLogVerbose('$baseLogMsg start...');

  systemUnderTesting = forTesting;

  await di.init();
  await customizeApp();

  itgLogVerbose('$baseLogMsg load settings...');
  // Load the settings (user's preferred theme) while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await di.sl<SettingsController>().loadSettings();

  itgLogVerbose('$baseLogMsg set appMainPage...');
  di.sl<SettingsService>().appMainPage = const HomePage();

  itgLogVerbose('$baseLogMsg end...');
}

/// The Widget that configures your application.
class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = sl();

    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          onGenerateTitle: (BuildContext context) => ItgLocalization.tr('appTitle'),

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          // theme: ThemeData(),
          theme: ThemeData(
            appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
            colorScheme: ColorScheme.fromSwatch(
              accentColor: const Color(0xFF13B9FF),
            ),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          debugShowCheckedModeBanner: appDebugShowCheckedModeBanner,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case HomePage.routeName:
                  default:
                    return sl<SettingsService>().appMainPage!;
                }
              },
            );
          },
        );
      },
    );
  }
}
