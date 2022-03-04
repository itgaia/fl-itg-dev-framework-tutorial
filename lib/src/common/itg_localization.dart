import 'etc/itg_map.dart';
import 'helper.dart';

class ItgLocalization {
  static String language = 'en';
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'language': 'Language',
      'helloWorld': 'Hello World',
      'appWindowTitle': 'Client',
      'appTitle': 'Client App',
      'welcomeMessage1': 'What a Wonderful World for All of Us...',
      'welcomeMessage2': '(Click the menu up-right for the available options)',
    },
    'el': {
      'language': 'Γλώσσα',
      'helloWorld': 'Καλημέρα Κόσμε!',
      'appWindowTitle': 'Client',
      'appTitle': 'Client App',
      'welcomeMessage': 'Ένας Υπέροχος Κόσμος για Όλους μας...',
      'welcomeMessage2': '(Πατήστε το μενού πάνω δεξια για τις διαθέσιμες λειτουργίες)',
    }
  };

  static String tr(String text, {String lang = ''}) {
    if (lang == '') lang = language;
    String? translated = _localizedValues[lang]![text];
    translated ??= text;
    itgLogVerbose('ItgLocalization.tr - text: $text, return: $translated');
    return translated;
  }

  static void custom(Map<String, Map<String, String>> values) {
    _localizedValues = mergeMap([_localizedValues, values]) as Map<String, Map<String, String>>;
  }
}