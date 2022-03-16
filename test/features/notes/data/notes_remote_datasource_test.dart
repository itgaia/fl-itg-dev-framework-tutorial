import 'dart:convert';

import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/core/error/exception.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_remote_datasource.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../common/test_helper.dart';
import '../../../fixtures/fixture_helper.dart';
import '../notes_test_helper.dart';

void main() {
  late NotesRemoteDataSourceImpl dataSource;

  setUpAll(() {
    sl.registerLazySingleton<http.Client>(() => MockHttpClient());
  });

  setUp(() {
    dataSource = NotesRemoteDataSourceImpl(client: sl<http.Client>());
  });

  group('getNotes', () {
    test('should perform a GET request on a URL with application/json header', () {
      setUpHttpClientGetNotesSuccess200(url: urlNotes);
      dataSource.getNotes();
      verify(() => sl<http.Client>()
          .get(Uri.parse(urlNotes), headers: {'Content-Type': 'application/json'}));
        });

    // final tNotesModel = (json.decode(fixture('notes_fixture.json')) as List)
    final tNotesModel = (json.decode(fixture('notes_response_fixture.json')) as List)
        .map<NotesModel>((json) => NotesModel.fromJson(json)).toList();

    test('should return Notes when the response code is 200', () async {
      setUpHttpClientGetNotesSuccess200();
      final result = await dataSource.getNotes();
      itgLogVerbose('test - Notes - result: $result');
      itgLogVerbose('test - Notes - tNotesModel: $tNotesModel');
      expect(result, equals(tNotesModel));
    });

    test(
        'should return a ServerException when the response code is 404 or other',
            () async {
          arrangeHttpClientGetReturnFailure404(url: urlNotes);
          final call = dataSource.getNotes;
          expect(() => call(), throwsA(isA<ServerException>()));
          expect(() async => await call(), throwsA(const ServerException(description: 'Invalid response "404"...')));
        });

    test(
        'should return a ServerException when an exception occurs',
            () async {
          arrangeHttpClientGetReturnException(url: urlNotes);
          final call = dataSource.getNotes;
          expect(() => call(), throwsA(isA<ServerException>()));
          expect(() => call(), throwsA(const ServerException(description: 'Exception: $textSampleException')));
        });
  });

  group('CCRDS createNotesItem', () {
    final NotesModel tData = notesTestData().first;
    // const NotesModel tData = NotesModel(code: 'test code 1', id: r'{$oid: 1}', dtFill: '2021-1-1', dtEmpty: '', dtDisinfection: '', notes: 'test notes 1', createdAt: '', updatedAt: '');

    test('CCRDS create should perform a POST request on a URL with application/json header', () {
      setUpHttpClientCreateNotesItemSuccess200(url: urlNotes);
      dataSource.createNotesItem(tData);
      verify(() => sl<http.Client>().post(
          Uri.parse(urlNotes),
          headers: {'Content-Type': 'application/json'},
          // body: tData.toJson()
          body: r'{"_id":"1","description":"test description 1","content":"test content 1"}'
      ));
    }, skip: !useHttpClient);

    test('CCRDS create should return the item with id and dates when the response code is 200', () async {
      setUpHttpClientCreateNotesItemSuccess200();
      final result = await dataSource.createNotesItem(sampleNotesItemAddData);
      expect(result, equals(sampleNotesItemAddDataExpected));
    }, skip: !useHttpClient);

    test('CCRDS create should return a ServerException when the response code is 404 or other', () async {
      arrangeHttpClientPostReturnFailure404(url: urlNotes);
      final call = dataSource.createNotesItem;
      expect(() => call(tData), throwsA(isA<ServerException>()));
      expect(() async => await call(tData), throwsA(const ServerException(description: '[NotesRemoteDataSourceImpl.createNotesItem] Failed tp create item with response code "404"...')));
      // expect(() async => await call(), throwsA(ServerException()));
    });

    test('CCRDS create should return a ServerException when an exception occurs', () async {
      arrangeHttpClientPostReturnException(url: urlNotes);
      final call = dataSource.createNotesItem;
      expect(() => call(tData), throwsA(isA<ServerException>()));
      expect(() => call(tData), throwsA(const ServerException(description: 'Exception: $textSampleException')));
    });
  });

  group('CCRDS updateNotesItem', () {
    final NotesModel tData = notesTestData().first;
    final String tUrl = '$urlNotes/${tData.id}';
    itgLogVerbose('CCRDS updateNotesItem - tUrl: $tUrl');
    itgLogVerbose('CCRDS updateNotesItem - tData: $tData');

    test('CCRDS update should perform a PUT request on a URL with application/json header', () {
      setUpHttpClientUpdateNotesItemSuccess204(url: tUrl, data: tData);
      dataSource.updateNotesItem(tData);
      verify(() => sl<http.Client>().put(
          Uri.parse(tUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(tData.toJson())
      ));
    });

    test('CCRDS update should return the item with id and dates when the response code is 204', () async {
      setUpHttpClientUpdateNotesItemSuccess204(url: tUrl, data: tData);
      final result = await dataSource.updateNotesItem(tData);
      expect(result, equals(tData));
    });

    test('CCRDS update should return a ServerException when the response code is 404 or other', () async {
      arrangeHttpClientPutReturnFailure404(url: tUrl);
      final call = dataSource.updateNotesItem;
      expect(() => call(tData), throwsA(isA<ServerException>()));
      expect(() async => await call(tData), throwsA(const ServerException(description: '[NotesRemoteDataSourceImpl.updateNotesItem] Failed tp update item with response code "404"...')));
    });

    test('CCRDS update should return a ServerException when an exception occurs', () async {
      arrangeHttpClientPutReturnException(url: tUrl);
      final call = dataSource.updateNotesItem;
      expect(() => call(tData), throwsA(isA<ServerException>()));
      expect(() => call(tData), throwsA(const ServerException(description: 'Exception: $textSampleException')));
    });
  });

  group('CCRDS deleteNotesItem', () {
    // final NotesModel tData = notesTestData().first;
    const String tUrl = '$urlNotes/$sampleNotesItemId';

    test('CCRDS delete should perform a DELETE request on a URL with application/json header', () {
      setUpHttpClientDeleteNotesItemSuccess204(url: tUrl);
      dataSource.deleteNotesItem(sampleNotesItemId);
      verify(() => sl<http.Client>().delete(
        Uri.parse(tUrl),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('CCRDS delete should return a ServerException when the response code is 404 or other', () async {
      arrangeHttpClientDeleteReturnFailure404(url: tUrl);
      final call = dataSource.deleteNotesItem;
      expect(() => call(sampleNotesItemId), throwsA(isA<ServerException>()));
      expect(() async => await call(sampleNotesItemId), throwsA(const ServerException(description: '[NotesRemoteDataSourceImpl.deleteNotesItem] Failed tp delete item "$sampleNotesItemId" with response code "404"...')));
    });

    test('CCRDS delete should return a ServerException when an exception occurs', () async {
      arrangeHttpClientDeleteReturnException(url: tUrl);
      final call = dataSource.deleteNotesItem;
      expect(() => call(sampleNotesItemId), throwsA(isA<ServerException>()));
      expect(() => call(sampleNotesItemId), throwsA(const ServerException(description: 'Exception: $textSampleException')));
    });
  });
}
