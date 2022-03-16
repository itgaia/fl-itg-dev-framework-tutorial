import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dev_framework_tutorial/src/core/error/exception.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_local_datasource.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_remote_datasource.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notes_test_helper.dart';

const sampleData = '''[
  {
    "_id": {"\$oid":"61011f6d4558ebe4f88abc1"},
    "description": "test description 1",
    "content": "test content 1"
  },
  {
    "_id": {"\$oid":"61011f6d4558ebe4f88abc2"},
    "description": "test description 2",
    "content": "test content 2"
  },
  {
    "_id": {"\$oid":"61011f6d4558ebe4f88abc3"},
    "description": "test description 3",
    "content": "test content 3"
  }
]''';


void main() {
  late NotesRemoteDataSource mockRemoteDataSource;
  late NotesLocalDataSource mockLocalDataSource;
  // late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(FakeNotesItem());
  });

  setUp(() {
    mockRemoteDataSource = MockNotesRemoteDataSource();
    mockLocalDataSource = MockNotesLocalDataSource();
    // mockNetworkInfo = MockNetworkInfo();
  });

  NotesRepositoryImpl createSubject() => NotesRepositoryImpl(
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

  group('NotesRepositoryImpl constructor', () {
    test('CCRI constructor works properly', () {
      expect(createSubject, returnsNormally);
    });
  });

  group('CCRI getNotes', () {
    final tNotesModelList = notesTestData();
    final List<NotesModel> tNotesEntityList = tNotesModelList;

    // test('should check if the device is online', () {
    //   // arrange
    //   // when(() => mockNetworkInfoIsConnected).thenAnswer((_) async => true);
    //   // don't know why this makes the test pass...
    //   when(() => mockRemoteDataSource.getNotes())
    //     .thenAnswer((_) async => tNotesModelList);
    //   when(() => mockLocalDataSource
    //     .cacheNotes(tNotesEntityList as List<NotesModel>))
    //     .thenAnswer((_) async => tNotesModelList);
    //   // act
    //   repository.getNotes();
    //   // assert
    //   verify(() => mockNetworkInfoIsConnected);
    // });

    _runTestsOnline(() {
      group('CCRI get (RemoteDataSource)', () {
        test('CCRI get should return remote data when the call to remote data source is successful', () async {
          when(() => mockRemoteDataSource.getNotes())
            .thenAnswer((_) async => tNotesModelList);
          when(() => mockLocalDataSource.cacheNotes(tNotesEntityList))
            .thenAnswer((_) async => tNotesModelList);
          final subject = createSubject();
          final result = await subject.getNotes();
          verify(() => mockRemoteDataSource.getNotes());
          expect(result, equals(Right(tNotesEntityList)));
        });

        test('CCRI get should cache the data locally when the call to remote data source is successful', () async {
          when(() => mockRemoteDataSource.getNotes())
            .thenAnswer((_) async => tNotesModelList);
          when(() => mockLocalDataSource.cacheNotes(tNotesEntityList))
            .thenAnswer((_) async => tNotesModelList);
          final subject = createSubject();
          await subject.getNotes();
          verify(() => mockRemoteDataSource.getNotes());
          verify(() => mockLocalDataSource
            .cacheNotes(tNotesEntityList));
        });

        test('CCRI get should return server failure when the call to remote data source is unsuccessful', () async {
          when(() => mockRemoteDataSource.getNotes())
            .thenThrow(const ServerException(code: "111"));
          final subject = createSubject();
          final result = await subject.getNotes();
          verify(() => mockRemoteDataSource.getNotes());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(const Left(ServerFailure(code: '111'))));
        });
      });
    });

    _runTestsOffline(() {
      group('CCRI get (LocalDataSource)', () {
        test('CCRI get should return local data when the call to local data source is successful', () async {
          SharedPreferences.setMockInitialValues({cachedNotesKey: sampleData});
          when(() => mockLocalDataSource.getNotes())
            .thenAnswer((_) async => tNotesModelList);
          final subject = createSubject();
          final result = await subject.getNotes();
          verify(() => mockLocalDataSource.getNotes());
          expect(result, equals(Right(tNotesEntityList)));
        });

        test('CCRI get should return server failure when the call to local data source is unsuccessful', () async {
          when(() => mockLocalDataSource.getNotes())
            .thenThrow(const CacheException(code: "111"));
          final subject = createSubject();
          final result = await subject.getNotes();
          verify(() => mockLocalDataSource.getNotes());
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(Left(CacheFailure())));
        });
      });
    });
  });

  group('CCRI saveNotesItem', () {
    _runTestsOnline(() {
      group('CCRI save', () {
        final List<NotesModel> tItems = notesTestData();
        final NotesModel tItem = tItems.first;

        test('CCRI save makes correct repository request (create)', () async {
          const newItem = NotesModel(
            description: 'description 4',
            content: 'content 4',
          );
          when(() => mockLocalDataSource.cacheNotes(any()))
              .thenAnswer((_) async => {});
          when(() => mockLocalDataSource.getNotes())
              .thenAnswer((_) async => tItems);
          when(() => mockRemoteDataSource.createNotesItem(any()))
              .thenAnswer((_) async => newItem);
          final subject = createSubject();
          expect(subject.saveNotesItem(newItem), completes);
          expect(await subject.saveNotesItem(newItem), equals(const Right(newItem)));
          if (await networkInfoIsConnected) {
            verify(() => mockRemoteDataSource.createNotesItem(newItem)).called(2);
          }
        });

        test('CCRI save makes correct repository request (update)', () async {
          const newItem = NotesModel(
            id: '4',
            description: 'description 4',
            content: 'content 4',
          );
          when(() => mockRemoteDataSource.updateNotesItem(any()))
              .thenAnswer((_) async => tItem);
          final subject = createSubject();
          expect(subject.saveNotesItem(newItem), completes);
          expect(await subject.saveNotesItem(newItem), equals(Right(tItem)));
          verify(() => mockRemoteDataSource.updateNotesItem(newItem)).called(2);
        });

        test('CCRI save should return remote data when the call to remote data source is successful', () async {
          when(() => mockRemoteDataSource.createNotesItem(any()))
            .thenAnswer((_) async => tItem);
          when(() => mockRemoteDataSource.updateNotesItem(any()))
            .thenAnswer((_) async => tItem);
          // when(() => mockLocalDataSource
          //   .cacheNotes(tNotesEntityList))
          //   .thenAnswer((_) async => tNotesModelList);
          final subject = createSubject();
          final result = await subject.saveNotesItem(tItem);
          verify(() => mockRemoteDataSource.updateNotesItem(tItem));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Right(tItem)));
        });

        test('CCRI save should return server failure when the call to remote data source is unsuccessful', () async {
          when(() => mockRemoteDataSource.createNotesItem(any()))
            .thenThrow(const ServerException(code: "111"));
          when(() => mockRemoteDataSource.updateNotesItem(any()))
            .thenThrow(const ServerException(code: "111"));
          final subject = createSubject();
          final result = await subject.saveNotesItem(tItem);
          verify(() => mockRemoteDataSource.updateNotesItem(tItem));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(const Left(ServerFailure(code: '111'))));
        });
      });
    });
  });

  group('CCRI deleteNotesItem', () {

    _runTestsOnline(() {
      group('CCRI delete', () {
        final NotesModel tData = notesTestData().first;

        test('CCRI delete makes correct repository request', () async {
          when(() => mockRemoteDataSource.deleteNotesItem(any()))
              .thenAnswer((_) async {});
          final subject = createSubject();
          expect(subject.deleteNotesItem(sampleNotesItemId), completes);
          expect(await subject.deleteNotesItem(sampleNotesItemId), equals(const Right(null)));
          verify(() => mockRemoteDataSource.deleteNotesItem(sampleNotesItemId)).called(2);
        });

        test('CCRI delete should return server failure when the call to remote data source is unsuccessful', () async {
          when(() => mockRemoteDataSource.createNotesItem(any()))
            .thenThrow(const ServerException(code: "111"));
          when(() => mockRemoteDataSource.updateNotesItem(any()))
            .thenThrow(const ServerException(code: "111"));
          final subject = createSubject();
          final result = await subject.saveNotesItem(tData);
          verify(() => mockRemoteDataSource.updateNotesItem(tData));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(const Left(ServerFailure(code: '111'))));
        });
      });
    });
  });
}
