import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';

void main () {
  group('ServerFailure', () {
    test('extends Failure', () {
      expect(const ServerFailure(), isA<Failure>());
    });

    test('created with no arguments', () {
      expect(const ServerFailure().toString(), equals('ServerFailure()'));
    });

    test('created with arguments', () {
      expect(const ServerFailure(code: '111').toString(), equals('ServerFailure(code: "111")'));
      expect(const ServerFailure(description: 'test description').toString(), equals('ServerFailure(description: "test description")'));
      expect(const ServerFailure(code: '111', description: 'test description').toString(), equals('ServerFailure(code: "111", description: "test description")'));
    });
  });

  group('CacheFailure', () {
    test('extends Failure', () {
      expect(CacheFailure(), isA<Failure>());
    });
  });
}