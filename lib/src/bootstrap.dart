import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app_bloc_observer.dart';
import 'common/helper.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  const String baseLogMsg = '[bootstrap]';
  itgLogVerbose('$baseLogMsg start...');

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
    itgLogError('[FlutterError] ${details.exceptionAsString()}');
  };

  itgLogVerbose('$baseLogMsg runZonedGuarded...');
  await runZonedGuarded(
        () async {
      await BlocOverrides.runZoned(
            () async => runApp(await builder()),
        blocObserver: AppBlocObserver(),
      );
    },
    // (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
        (error, stackTrace) {
      itgLogError('[runZonedGuarded] ${error.toString()}');
      log(error.toString(), stackTrace: stackTrace);
    } ,
  );
}

