import 'package:get_it/get_it.dart';

import '../features/settings/settings_controller.dart';
import '../features/settings/settings_service.dart';

final sl = GetIt.instance;       // Service Locator

Future<void> init({bool forTesting = false}) async {
  if (!sl.isRegistered<SettingsService>()) {
    sl.registerLazySingleton(() => SettingsService());
  }
  if (!sl.isRegistered<SettingsController>()) {
    sl.registerLazySingleton(() => SettingsController(sl()));
  }
}
