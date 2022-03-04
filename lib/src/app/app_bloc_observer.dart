import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/helper.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    itgLogVerbose('[AppBlocObserver] onChange(${bloc.runtimeType}, $change)');
    // log('onChange(${bloc.runtimeType}, $change)');   // TODO: log and print are not "logging" the same things! Why? (log emits an event...)
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('[AppBlocObserver] onError(${bloc.runtimeType}, $error, $stackTrace)');
    itgLogError('[AppBlocObserver] onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}
