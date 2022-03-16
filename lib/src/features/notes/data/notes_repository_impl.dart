import 'package:dartz/dartz.dart';

import 'notes_local_datasource.dart';
import 'notes_model.dart';
import 'notes_remote_datasource.dart';
import '../../../app/constants.dart';
import '../../../common/helper.dart';
import '../../../core/error/exception.dart';
import '../../../core/error/failures.dart';
import '../domain/notes_repository.dart';

const msgBaseSourceClass = 'NotesRepositoryImpl';
String msgBaseSourceMethod = '';
void msgLogInfo(String msg) => itgLogVerbose('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');
void msgLogError(String msg) => itgLogError('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');

class NotesRepositoryImpl implements NotesRepository {
  final NotesRemoteDataSource remoteDataSource;
  final NotesLocalDataSource localDataSource;
  // final NetworkInfo networkInfo;

  NotesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<NotesModel>>> getNotes() async {
    msgBaseSourceMethod = 'getNotes';
    msgLogInfo('start....');
    if (await networkInfoIsConnected) {
      try {
        msgLogInfo('Network is up....');
        final List<NotesModel> remoteNotes = await remoteDataSource.getNotes();
        localDataSource.cacheNotes(remoteNotes);
        return Right(remoteNotes);
      } on ServerException catch (e) {
        return Left(ServerFailure(code: e.code, description: e.description));
      }
    } else {
      try {
        msgLogInfo('Network is down....');
        final localNotes = await localDataSource.getNotes();
        return Right(localNotes);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<NotesModel>>> searchNotes(String query) async {
    const String baseLogMsg = '[NotesRepositoryImpl.searchNotes]';
    itgLogVerbose('$baseLogMsg query: $query');
    final networkList = await remoteDataSource.searchNotes(query);
    // final localList = await localDataSource.getNotes(query);
    // return Right(List<NotesEntity>.empty(growable: true)
    //   ..addAll(networkList)
    //   ..addAll(localList));
    return Right(networkList);
  }

  @override
  Future<Either<Failure, NotesModel>> saveNotesItem(NotesModel notesItem) async {
    msgBaseSourceMethod = 'saveNotesItem';
    msgLogInfo('note: $notesItem');
    // return Right(await localDataSource.addNote(note));
    // return Right(await remoteDataSource.createNotesItem(note));
    if (await networkInfoIsConnected) {
      try {
        final NotesModel ret;
        if (notesItem.id != null && notesItem.id!.isNotEmpty) {
          msgLogInfo('update item...');
          ret = await remoteDataSource.updateNotesItem(notesItem);
        } else {
          msgLogInfo('create item...');
          ret = await remoteDataSource.createNotesItem(notesItem);
        }
        return Right(ret);
        // return Future.value(Right(ret));
      } on ServerException catch (e) {
        return Left(ServerFailure(code: e.code, description: e.description));
      }
    } else {
      msgLogError('network is down...');
      try {
        final failureOrSuccess = await getNotes();
        failureOrSuccess.fold(
          (l) => null,
          (notes) async {
            // if (notesItem.id == null) {
            //   // TODO: Why there is no setter in NotesModel?
            //   // There isn’t a setter named 'content' in class '_$NotesMode
            //   notes.add(notesItem.copyWith(id: '${notes.length+1}'));
            // } else {
            //   notes.add(notesItem);
            // }
            if (notesItem.id != null && notesItem.id!.isNotEmpty) {
              msgLogInfo('update item...');
              notes[notes.indexWhere((element) => element.id == notesItem.id)] = notesItem;
            } else {
              msgLogInfo('create item...');
              notes.add(notesItem.copyWith(id: '${notes.length+1}'));
            }
            await localDataSource.cacheNotes(notes);
          });
          return Right(notesItem);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  // @override
  // Future<Either<Failure, NotesModel>> editNotesItem(NotesModel note) async {
  //   return Right(await localDataSource.editNote(note));
  // }

  @override
  Future<Either<Failure, void>> deleteNotesItem(String id) async {
    msgBaseSourceMethod = 'deleteNotesItem';
    msgLogInfo('id: $id');
    if (await networkInfoIsConnected) {
      try {
        msgLogInfo('delete item...');
        await remoteDataSource.deleteNotesItem(id);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(code: e.code, description: e.description));
      }
    } else {
      msgLogError('network is down...');
      try {
        final failureOrSuccess = await getNotes();
        failureOrSuccess.fold(
          (l) => null,
          (notes) async {
            notes.removeWhere((element) => element.id == id);
            await localDataSource.cacheNotes(notes);
          });
        return const Right(null);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
