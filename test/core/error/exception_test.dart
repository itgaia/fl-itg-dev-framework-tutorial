import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/core/error/exception.dart';

void main () {
  group('ServerException', () {
    test('extends Exception', () {
      expect(const ServerException(), isA<Exception>());
    });

    test('created with no arguments', () {
      expect(const ServerException().toString(), equals('ServerException()'));
    });

    test('created with arguments', () {
      expect(const ServerException(code: '111').toString(), equals('ServerException(code: "111")'));
      expect(const ServerException(description: 'test description').toString(), equals('ServerException(description: "test description")'));
      expect(const ServerException(code: '111', description: 'test description').toString(), equals('ServerException(code: "111", description: "test description")'));
    });
  });

  group('CacheException', () {
    test('extends Exception', () {
      expect(const CacheException(), isA<Exception>());
    });
  });
}