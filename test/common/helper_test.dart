import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('keyNameGenerator', () {
    test('keyNameGenerator return values', () {
      expect(
        keyNameGenerator(keyElement: KeyElement.widget, feature: ['sample'],
                         action: KeyAction.add),
        equals('w-sample-action-add')
      );
      expect(
        keyNameGenerator(keyElement: KeyElement.widget, feature: ['sample', keyAbbrListItem],
                         action: KeyAction.add),
        equals('w-sample-li-action-add')
      );
      expect(
        keyNameGenerator(keyElement: KeyElement.widget, feature: ['sample'],
                         action: KeyAction.add, id: 'test-id'),
        equals('w-sample-test-id-action-add')
      );
      expect(
        keyNameGenerator(keyElement: KeyElement.widget, feature: ['sample'],
                         action: KeyAction.addFloating),
        equals('w-sample-floating-action-add')
      );
      expect(
        keyNameGenerator(keyElement: KeyElement.widget, feature: ['sample'],
                         action: KeyAction.addFloating, id: 'test-id'),
        equals('w-sample-test-id-floating-action-add')
      );
      expect(
        keyNameGenerator(keyElement: KeyElement.widget, feature: ['sample'],
                         action: KeyAction.addFloating, id: 'test-id',
                         prefix: 'hello-hello'),
        equals('hello-hello-w-sample-test-id-floating-action-add')
      );
      expect(
        keyNameGenerator(keyElement: KeyElement.widget, feature: ['sample'],
                         id: 'test-id', prefix: 'my'),
        equals('my-w-sample-test-id')
      );
      expect(
        keyNameGenerator(keyElement: KeyElement.widget, feature: ['sample'],
                         id: 'test-id', prefix: 'my', suffix: 'time'),
        equals('my-w-sample-test-id-time')
      );
      expect(
        keyNameGenerator(keyElement: KeyElement.widget, feature: ['sample'],
                         id: 'test-id', suffix: 'time'),
        equals('w-sample-test-id-time')
      );
      expect(
        keyNameGenerator(keyElement: KeyElement.widget, feature: ['sample'],
                         id: 'test-id', field: 'time'),
        equals('w-sample-test-id-time')
      );
      expect(
        keyNameGenerator(keyElement: KeyElement.widget, feature: ['sample'],
                         id: 'test-id', field: 'time', suffix: 'job'),
        equals('w-sample-test-id-time-job')
      );
    });
  });
}