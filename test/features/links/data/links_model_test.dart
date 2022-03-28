import 'dart:convert';

import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_model.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/links_helper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_helper.dart';
import '../links_test_helper.dart';

void main() {
  final tLinks = linksTestData(count: 3);

  test(
    'should be a subclass of Links entity',
        () async {
      expect(tLinks.first, isA<LinksModel>());
    },
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      itgLogPrint('Links model - should return a valid model from JSON - useMongoDbBackend: $useMongoDbBackend');
      final jsonData = useMongoDbBackend
        ? fixture('links_mongo_fixture.json')
        : fixture('links_fixture.json');
      final result = (json.decode(jsonData) as List)
        .map<LinksModel>((json) => LinksModel.fromJson(json)).toList();
      expect(result, tLinks);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final expectedJsonMap = useMongoDbBackend
        ? linksMongoTestMapData(count: tLinks.length)
        : linksTestMapData(count: tLinks.length);
      final result = tLinks.map((LinksModel link) => link.toJson()).toList();
      expect(result, expectedJsonMap);
    });

    test('should return correct data - omit if null or empty', () {
      final item = itemLinksSample();
      final result = item.toJson();
      expect(result, equals(itemLinksObjectAsString(item)));
    });
  });
}
