import 'dart:convert';

import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/core/error/exception.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_model.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/links_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_remote_datasource.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../common/test_helper.dart';
import '../../../fixtures/fixture_helper.dart';
import '../links_test_helper.dart';

void main() {
  late LinksRemoteDataSourceImpl dataSource;

  setUpAll(() {
    sl.registerLazySingleton<http.Client>(() => MockHttpClient());
  });

  setUp(() {
    dataSource = LinksRemoteDataSourceImpl(client: sl<http.Client>());
  });

  group('getLinks', () {
    test('should perform a GET request on a URL with application/json header', () {
      setUpHttpClientGetLinksSuccess200(url: urlLinks);
      dataSource.getLinks();
      verify(() => sl<http.Client>()
          .get(Uri.parse(urlLinks), headers: {'Content-Type': 'application/json'}));
        });

    // final tLinksModel = (json.decode(fixture('links_fixture.json')) as List)
    final tLinksModel = (json.decode(fixture('links_response_fixture.json')) as List)
        .map<LinksModel>((json) => LinksModel.fromJson(json)).toList();

    test('should return Links when the response code is 200', () async {
      setUpHttpClientGetLinksSuccess200();
      final result = await dataSource.getLinks();
      itgLogVerbose('test - Links - result: $result');
      itgLogVerbose('test - Links - tLinksModel: $tLinksModel');
      expect(result, equals(tLinksModel));
    });

    test(
        'should return a ServerException when the response code is 404 or other',
            () async {
          arrangeHttpClientGetReturnFailure404(url: urlLinks);
          final call = dataSource.getLinks;
          expect(() => call(), throwsA(isA<ServerException>()));
          expect(() async => await call(), throwsA(const ServerException(description: 'Invalid response "404"...')));
        });

    test(
        'should return a ServerException when an exception occurs',
            () async {
          arrangeHttpClientGetReturnException(url: urlLinks);
          final call = dataSource.getLinks;
          expect(() => call(), throwsA(isA<ServerException>()));
          expect(() => call(), throwsA(const ServerException(description: 'Exception: $textSampleException')));
        });
  });

  group('LNRDS createLinksItem', () {
    final LinksModel tData = linksTestData().first;
    // const LinksModel tData = LinksModel(code: 'test code 1', id: r'{$oid: 1}', dtFill: '2021-1-1', dtEmpty: '', dtDisinfection: '', links: 'test links 1', createdAt: '', updatedAt: '');

    test('LNRDS create should perform a POST request on a URL with application/json header', () {
      setUpHttpClientCreateLinksItemSuccess200(url: urlLinks);
      dataSource.createLinksItem(tData);
      verify(() => sl<http.Client>().post(
          Uri.parse(urlLinks),
          headers: {'Content-Type': 'application/json'},
          // body: tData.toJson()
          body: r'{"_id":"1","description":"test description 1","content":"test content 1"}'
      ));
    }, skip: !useHttpClient);

    test('LNRDS create should return the item with id and dates when the response code is 200', () async {
      setUpHttpClientCreateLinksItemSuccess200();
      final result = await dataSource.createLinksItem(itemLinksAddTestData);
      expect(result, equals(itemLinksAddTestDataExpected));
    }, skip: !useHttpClient);

    test('LNRDS create should return a ServerException when the response code is 404 or other', () async {
      arrangeHttpClientPostReturnFailure404(url: urlLinks);
      final call = dataSource.createLinksItem;
      expect(() => call(tData), throwsA(isA<ServerException>()));
      expect(() async => await call(tData), throwsA(const ServerException(description: '[LinksRemoteDataSourceImpl.createLinksItem] Failed tp create item with response code "404"...')));
      // expect(() async => await call(), throwsA(ServerException()));
    });

    test('LNRDS create should return a ServerException when an exception occurs', () async {
      arrangeHttpClientPostReturnException(url: urlLinks);
      final call = dataSource.createLinksItem;
      expect(() => call(tData), throwsA(isA<ServerException>()));
      expect(() => call(tData), throwsA(const ServerException(description: 'Exception: $textSampleException')));
    });
  });

  group('LNRDS updateLinksItem', () {
    final LinksModel tData = linksTestData().first;
    final String tUrl = '$urlLinks/${tData.id}';
    itgLogVerbose('LNRDS updateLinksItem - tUrl: $tUrl');
    itgLogVerbose('LNRDS updateLinksItem - tData: $tData');

    test('LNRDS update should perform a PUT request on a URL with application/json header', () {
      setUpHttpClientUpdateLinksItemSuccess204(url: tUrl, data: tData);
      dataSource.updateLinksItem(tData);
      verify(() => sl<http.Client>().put(
          Uri.parse(tUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(tData.toJson())
      ));
    });

    test('LNRDS update should return the item with id and dates when the response code is 204', () async {
      setUpHttpClientUpdateLinksItemSuccess204(url: tUrl, data: tData);
      final result = await dataSource.updateLinksItem(tData);
      expect(result, equals(tData));
    });

    test('LNRDS update should return a ServerException when the response code is 404 or other', () async {
      arrangeHttpClientPutReturnFailure404(url: tUrl);
      final call = dataSource.updateLinksItem;
      expect(() => call(tData), throwsA(isA<ServerException>()));
      expect(() async => await call(tData), throwsA(const ServerException(description: '[LinksRemoteDataSourceImpl.updateLinksItem] Failed tp update item with response code "404"...')));
    });

    test('LNRDS update should return a ServerException when an exception occurs', () async {
      arrangeHttpClientPutReturnException(url: tUrl);
      final call = dataSource.updateLinksItem;
      expect(() => call(tData), throwsA(isA<ServerException>()));
      expect(() => call(tData), throwsA(const ServerException(description: 'Exception: $textSampleException')));
    });
  });

  group('LNRDS deleteLinksItem', () {
    // final LinksModel tData = linksTestData().first;
    const String tUrl = '$urlLinks/$sampleLinksItemId';

    test('LNRDS delete should perform a DELETE request on a URL with application/json header', () {
      setUpHttpClientDeleteLinksItemSuccess204(url: tUrl);
      dataSource.deleteLinksItem(sampleLinksItemId);
      verify(() => sl<http.Client>().delete(
        Uri.parse(tUrl),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('LNRDS delete should return a ServerException when the response code is 404 or other', () async {
      arrangeHttpClientDeleteReturnFailure404(url: tUrl);
      final call = dataSource.deleteLinksItem;
      expect(() => call(sampleLinksItemId), throwsA(isA<ServerException>()));
      expect(() async => await call(sampleLinksItemId), throwsA(const ServerException(description: '[LinksRemoteDataSourceImpl.deleteLinksItem] Failed tp delete item "$sampleLinksItemId" with response code "404"...')));
    });

    test('LNRDS delete should return a ServerException when an exception occurs', () async {
      arrangeHttpClientDeleteReturnException(url: tUrl);
      final call = dataSource.deleteLinksItem;
      expect(() => call(sampleLinksItemId), throwsA(isA<ServerException>()));
      expect(() => call(sampleLinksItemId), throwsA(const ServerException(description: 'Exception: $textSampleException')));
    });
  });
}
