import 'package:flutter/material.dart';

import '../../app/constants.dart';
import '../../common/helper.dart';
import '../../common/itg_localization.dart';
import '../settings/settings_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(ItgLocalization.tr('appTitle'), key: keyTextPageTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
          key: keyAppBarPage
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widgetText(context, ItgLocalization.tr('welcomeMessage1'), key: keyTextHomePageWelcomeMessage1),
            // widgetText(context, ItgLocalization.tr('welcomeMessage2'), key: keyTextHomePageWelcomeMessage2),
          ],
        ),
      ),
    );
  }
}
