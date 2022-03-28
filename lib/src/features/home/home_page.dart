import 'package:flutter/material.dart';

import '../../app/constants.dart';
import '../../app/custom_button.dart';
import '../../common/helper.dart';
import '../../common/itg_localization.dart';
import '../links/domain/links_helper.dart';
import '../links/presentation/main/links_page.dart';
import '../notes/domain/notes_helper.dart';
import '../notes/presentation/main/notes_page.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            widgetText(context, ItgLocalization.tr('welcomeMessage1'), key: keyTextHomePageWelcomeMessage1),
            // widgetText(context, ItgLocalization.tr('welcomeMessage2'), key: keyTextHomePageWelcomeMessage2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                    title: ItgLocalization.tr('Notes'),
                    color: Colors.cyan,
                    onPressed: () {
                      // TODO: Use restorablePushNamed...
                      // Navigator.restorablePushNamed(
                      //   context,
                      //   NotesPage.routeName,
                      // );
                      Navigator.push(
                        context,
                        NotesPage.route(),
                      );
                    },
                    key: keyButtonNotesPage
                ),
                CustomButton(
                    title: ItgLocalization.tr('Links'),
                    color: Colors.cyan,
                    onPressed: () {
                      Navigator.push(
                        context,
                        LinksPage.route(),
                      );
                    },
                    key: keyButtonLinksPage
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
