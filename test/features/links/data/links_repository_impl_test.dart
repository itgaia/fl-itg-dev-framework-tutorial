import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dev_framework_tutorial/src/core/error/exception.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_local_datasource.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_model.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_remote_datasource.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../links_test_helper.dart';

void main() {
  late LinksRemoteDataSource mockRemoteDataSource;
  late LinksLocalDataSource mockLocalDataSource;
  // late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(FakeLinksItem());
  });

  setUp(() {
    mockRemoteDataSource = MockLinksRemoteDataSource();
    mockLocalDataSource = MockLinksLocalDataSource();
    // mockNetworkInfo = MockNetworkInfo();
  });

  LinksRepositoryImpl createSubject() => LinksRepositoryImpl(
    remoteDataSource: mockRemoteDataSource,
    localDataSource: mockLocalDataSource,
    // networkInfo: mockNetworkInfo,
  );

  void _runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        // when(() => mockNetworkInfoIsConnected).thenAnswer((_) async => true);
        networkInfoIsConnected = Future.value(true);
      });

      body();
    });
  }

  void _runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        // when(() => mockNetworkInfoIsConnected).thenAnswer((_) async => false);
        networkInfoIsConnected = Future.value(false);
      });

      body();
    });
  }

  group('LinksRepositoryImpl constructor', () {
    test('LNRI constructor works properly', () {
      expect(createSubject, returnsNormally);
    });
  });

  group('LNRI getLinks', () {
    final tLinksModelList = linksTestData();
    final List<LinksModel> tLinksEntityList = tLinksModelList;

    // test('should check if the device is online', () {
    //   // arrange
    //   // when(() => mockNetworkInfoIsConnected).thenAnswer((_) async => true);
    //   // don't know why this makes the test pass...
    //   when(() => mockRemoteDataSource.getLinks())
    //     .thenAnswer((_) async => tLinksModelList);
    //   when(() => mockLocalDataSource
    //     .cacheLinks(tLinksEntityList as List<LinksModel>))
    //     .thenAnswer((_) async => tLinksModelList);
    //   // act
    //   repository.getLinks();
    //   // assert
    //   verify(() => mockNetworkInfoIsConnected);
    // });

    _runTestsOnline(() {
      group('LNRI get (RemoteDataSource)', () {
        test('LNRI get should return remote data when the call to remote data source is successful', () async {
          when(() => mockRemoteDataSource.getLinks())
            .thenAnswer((_) async => tLinksModelList);
          when(() => mockLocalDataSource.cacheLinks(tLinksEntityList))
            .thenAnswer((_) async => tLinksModelList);
          final subject = createSubject();
          final result = await subject.getLinks();
          verify(() => mockRemoteDataSource.getLinks());
          expect(result, equals(Right(tLinksEntityList)));
        });

        test('LNRI get should cache the data locally when the call to remote data source is successful', () async {
          when(() => mockRemoteDataSource.getLinks())
            .thenAnswer((_) async => tLinksModelList);
          when(() => mockLocalDataSource.cacheLinks(tLinksEntityList))
            .thenAnswer((_) async => tLinksModelList);
          final subject = createSubject();
          await subject.getLinks();
          verify(() => mockRemoteDataSource.getLinks());
          verify(() => mockLocalDataSource
            .cacheLinks(tLinksEntityList));
        });

        test('LNRI get should return server failure when the call to remote data source is unsuccessful', () async {
          when(() => mockRemoteDataSource.getLinks())
            .thenThrow(const ServerException(code: "111"));
          final subject = createSubject();
          final result = await subject.getLinks();
          verify(() => mockRemoteDataSource.getLinks());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(const Left(ServerFailure(code: '111'))));
        });
      });
    });

    _runTestsOffline(() {
      group('LNRI get (LocalDataSource)', () {
        test('LNRI get should return local data when the call to local data source is successful', () async {
          SharedPreferences.setMockInitialValues({cachedLinksKey: sampleLinksData});
          when(() => mockLocalDataSource.getLinks())
            .thenAnswer((_) async => tLinksModelList);
          final subject = createSubject();
          final result = await subject.getLinks();
          verify(() => mockLocalDataSource.getLinks());
          expect(result, equals(Right(tLinksEntityList)));
        });

        test('LNRI get should return server failure when the call to local data source is unsuccessful', () async {
          when(() => mockLocalDataSource.getLinks())
            .thenThrow(const CacheException(code: "111"));
          final subject = createSubject();
          final result = await subject.getLinks();
          verify(() => mockLocalDataSource.getLinks());
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(Left(CacheFailure())));
        });
      });
    });
  });

  group('LNRI saveLinksItem', () {
    _runTestsOnline(() {
      group('LNRI save', () {
        final List<LinksModel> tItems = linksTestData();
        final LinksModel tItem = tItems.first;

        test('LNRI save makes correct repository request (create)', () async {
          const newItem = itemLinksAddTestData;
          when(() => mockLocalDataSource.cacheLinks(any()))
              .thenAnswer((_) async => {});
          when(() => mockLocalDataSource.getLinks())
              .thenAnswer((_) async => tItems);
          when(() => mockRemoteDataSource.createLinksItem(any()))
              .thenAnswer((_) async => newItem);
          final subject = createSubject();
          expect(subject.saveLinksItem(newItem), completes);
          expect(await subject.saveLinksItem(newItem), equals(const Right(newItem)));
          if (await networkInfoIsConnected) {
            verify(() => mockRemoteDataSource.createLinksItem(newItem)).called(2);
          }
        });

        test('LNRI save makes correct repository request (update)', () async {
          final item = itemLinksUpdateTestData;
          when(() => mockRemoteDataSource.updateLinksItem(any()))
              .thenAnswer((_) async => tItem);
          final subject = createSubject();
          expect(subject.saveLinksItem(item), completes);
          expect(await subject.saveLinksItem(item), equals(Right(tItem)));
          verify(() => mockRemoteDataSource.updateLinksItem(item)).called(2);
        });

        test('LNRI save should return remote data when the call to remote data source is successful', () async {
          when(() => mockRemoteDataSource.createLinksItem(any()))
            .thenAnswer((_) async => tItem);
          when(() => mockRemoteDataSource.updateLinksItem(any()))
            .thenAnswer((_) async => tItem);
          // when(() => mockLocalDataSource
          //   .cacheLinks(tLinksEntityList))
          //   .thenAnswer((_) async => tLinksModelList);
          final subject = createSubject();
          final result = await subject.saveLinksItem(tItem);
          verify(() => mockRemoteDataSource.updateLinksItem(tItem));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Right(tItem)));
        });

        test('LNRI save should return server failure when the call to remote data source is unsuccessful', () async {
          when(() => mockRemoteDataSource.createLinksItem(any()))
            .thenThrow(const ServerException(code: "111"));
          when(() => mockRemoteDataSource.updateLinksItem(any()))
            .thenThrow(const ServerException(code: "111"));
          final subject = createSubject();
          final result = await subject.saveLinksItem(tItem);
          verify(() => mockRemoteDataSource.updateLinksItem(tItem));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(const Left(ServerFailure(code: '111'))));
        });
      });
    });
  });

  group('LNRI deleteLinksItem', () {

    _runTestsOnline(() {
      group('LNRI delete', () {
        final LinksModel tData = linksTestData().first;

        test('LNRI delete makes correct repository request', () async {
          when(() => mockRemoteDataSource.deleteLinksItem(any()))
              .thenAnswer((_) async {});
          final subject = createSubject();
          expect(subject.deleteLinksItem(sampleLinksItemId), completes);
          expect(await subject.deleteLinksItem(sampleLinksItemId), equals(const Right(null)));
          verify(() => mockRemoteDataSource.deleteLinksItem(sampleLinksItemId)).called(2);
        });

        test('LNRI delete should return server failure when the call to remote data source is unsuccessful', () async {
          when(() => mockRemoteDataSource.createLinksItem(any()))
            .thenThrow(const ServerException(code: "111"));
          when(() => mockRemoteDataSource.updateLinksItem(any()))
            .thenThrow(const ServerException(code: "111"));
          final subject = createSubject();
          final result = await subject.saveLinksItem(tData);
          verify(() => mockRemoteDataSource.updateLinksItem(tData));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(const Left(ServerFailure(code: '111'))));
        });
      });
    });
  });
}
