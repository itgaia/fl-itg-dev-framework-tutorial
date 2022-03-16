// ignore_for_file: unused_import

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mockingjay/mockingjay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import '../features/notes/data/notes_local_datasource.dart';
import '../features/notes/data/notes_model.dart';
import '../features/notes/data/notes_remote_datasource.dart';
import '../features/notes/data/notes_repository_impl.dart';
import '../features/notes/domain/delete_notes_item_usecase.dart';
import '../features/notes/domain/get_notes_usecase.dart';
import '../features/notes/domain/notes_repository.dart';
import '../features/notes/domain/notes_support.dart';
import '../features/notes/domain/save_notes_item_usecase.dart';
import '../features/notes/presentation/add_edit/bloc/notes_item_add_edit_bloc.dart';
import '../features/notes/presentation/main/bloc/notes_bloc.dart';
import '../features/settings/settings_controller.dart';
import '../features/settings/settings_service.dart';

class MockHttpClient2 extends Mock implements http.Client {}  // return sample data
final List<NotesModel> notesData = [];

final sl = GetIt.instance;       // Service Locator

Future<void> init({bool forTesting = false}) async {
  if (!sl.isRegistered<SettingsService>()) {
    sl.registerLazySingleton(() => SettingsService());
  }
  if (!sl.isRegistered<SettingsController>()) {
    sl.registerLazySingleton(() => SettingsController(sl()));
  }
  if (!sl.isRegistered<NotesBloc>()) {
    sl.registerFactory(() => NotesBloc(usecase: sl()));
  }
  if (!sl.isRegistered<NotesItemAddEditBloc>()) {
    sl.registerFactory(() => NotesItemAddEditBloc(saveNotesItemUsecase: sl(), initialData: null));
  }
  if (!sl.isRegistered<GetNotesUsecase>()) {
    sl.registerLazySingleton(() => GetNotesUsecase(sl()));
  }
  if (!sl.isRegistered<SaveNotesItemUsecase>()) {
    sl.registerLazySingleton(() => SaveNotesItemUsecase(sl()));
  }
  if (!sl.isRegistered<DeleteNotesItemUsecase>()) {
    sl.registerLazySingleton(() => DeleteNotesItemUsecase(sl()));
  }
  if (!sl.isRegistered<NotesRepository>()) {
    sl.registerLazySingleton<NotesRepository>(
      () => NotesRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        // networkInfo: sl(),
      ));
  }
  if (!sl.isRegistered<NotesRemoteDataSource>()) {
    sl.registerLazySingleton<NotesRemoteDataSource>(
      () => NotesRemoteDataSourceImpl(client: sl()));
  }
  if (!sl.isRegistered<NotesLocalDataSource>()) {
    sl.registerLazySingleton<NotesLocalDataSource>(
      () => NotesLocalDataSourceImpl());
  }
  if (!sl.isRegistered<NotesSupport>()) {
    sl.registerLazySingleton(() => NotesSupport());
  }
  if (!sl.isRegistered<SharedPreferences>()) {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerSingletonAsync(() async => sharedPreferences);
  }
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton(() => http.Client());
  }
}
