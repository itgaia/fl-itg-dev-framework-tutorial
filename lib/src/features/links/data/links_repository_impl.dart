import 'package:dartz/dartz.dart';

import 'links_local_datasource.dart';
import 'links_model.dart';
import 'links_remote_datasource.dart';
import '../../../app/constants.dart';
import '../../../common/helper.dart';
import '../../../core/error/exception.dart';
import '../../../core/error/failures.dart';
import '../domain/links_repository.dart';

const msgBaseSourceClass = 'LinksRepositoryImpl';
String msgBaseSourceMethod = '';
void msgLogInfo(String msg) => itgLogVerbose('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');
void msgLogError(String msg) => itgLogError('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');

class LinksRepositoryImpl implements LinksRepository {
  final LinksRemoteDataSource remoteDataSource;
  final LinksLocalDataSource localDataSource;
  // final NetworkInfo networkInfo;

  LinksRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<LinksModel>>> getLinks() async {
    msgBaseSourceMethod = 'getLinks';
    msgLogInfo('start....');
    if (await networkInfoIsConnected) {
      try {
        msgLogInfo('Network is up....');
        final List<LinksModel> remoteLinks = await remoteDataSource.getLinks();
        localDataSource.cacheLinks(remoteLinks);
        return Right(remoteLinks);
      } on ServerException catch (e) {
        return Left(ServerFailure(code: e.code, description: e.description));
      }
    } else {
      try {
        msgLogInfo('Network is down....');
        final localLinks = await localDataSource.getLinks();
        return Right(localLinks);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<LinksModel>>> searchLinks(String query) async {
    const String baseLogMsg = '[LinksRepositoryImpl.searchLinks]';
    itgLogVerbose('$baseLogMsg query: $query');
    final networkList = await remoteDataSource.searchLinks(query);
    // final localList = await localDataSource.getLinks(query);
    // return Right(List<LinksEntity>.empty(growable: true)
    //   ..addAll(networkList)
    //   ..addAll(localList));
    return Right(networkList);
  }

  @override
  Future<Either<Failure, LinksModel>> saveLinksItem(LinksModel linksItem) async {
    msgBaseSourceMethod = 'saveLinksItem';
    msgLogInfo('link: $linksItem');
    // return Right(await localDataSource.addLink(link));
    // return Right(await remoteDataSource.createLinksItem(link));
    if (await networkInfoIsConnected) {
      try {
        final LinksModel ret;
        if (linksItem.id != null && linksItem.id!.isNotEmpty) {
          msgLogInfo('update item...');
          ret = await remoteDataSource.updateLinksItem(linksItem);
        } else {
          msgLogInfo('create item...');
          ret = await remoteDataSource.createLinksItem(linksItem);
        }
        return Right(ret);
        // return Future.value(Right(ret));
      } on ServerException catch (e) {
        return Left(ServerFailure(code: e.code, description: e.description));
      }
    } else {
      msgLogError('network is down...');
      try {
        final failureOrSuccess = await getLinks();
        failureOrSuccess.fold(
          (l) => null,
          (links) async {
            // if (linksItem.id == null) {
            //   // TODO: Why there is no setter in LinksModel?
            //   // There isn’t a setter named 'content' in class '_$LinksMode
            //******** here there is the problem with mason {{{ *******************
            //   links.add(linksItem.copyWith(id: '${links.length+1}'));
            // } else {
            //   links.add(linksItem);
            // }
            if (linksItem.id != null && linksItem.id!.isNotEmpty) {
              msgLogInfo('update item...');
              links[links.indexWhere((element) => element.id == linksItem.id)] = linksItem;
            } else {
              msgLogInfo('create item...');
              //******** here there is the problem with mason {{{ *******************
              links.add(linksItem.copyWith(id: '${links.length+1}'));
            }
            await localDataSource.cacheLinks(links);
          });
          return Right(linksItem);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  // @override
  // Future<Either<Failure, LinksModel>> editLinksItem(LinksModel link) async {
  //   return Right(await localDataSource.editLink(link));
  // }

  @override
  Future<Either<Failure, void>> deleteLinksItem(String id) async {
    msgBaseSourceMethod = 'deleteLinksItem';
    msgLogInfo('id: $id');
    if (await networkInfoIsConnected) {
      try {
        msgLogInfo('delete item...');
        await remoteDataSource.deleteLinksItem(id);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(code: e.code, description: e.description));
      }
    } else {
      msgLogError('network is down...');
      try {
        final failureOrSuccess = await getLinks();
        failureOrSuccess.fold(
          (l) => null,
          (links) async {
            links.removeWhere((element) => element.id == id);
            await localDataSource.cacheLinks(links);
          });
        return const Right(null);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
