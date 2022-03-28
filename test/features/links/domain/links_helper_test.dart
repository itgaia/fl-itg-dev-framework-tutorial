import 'package:dev_framework_tutorial/src/features/links/data/links_model.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/links_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('itemLinksObjectAsString', () {
    const item = LinksModel(id: '1', description: 'sample description 1', notes: 'sample notes 1');
    const expected = {
      'id': '1',
      'description': 'sample description 1',
      'notes': 'sample notes 1',
      'createdAt': '',
      'updatedAt': ''
    };
    const expectedOmitEmpty = {
      'id': '1',
      'description': 'sample description 1',
      'notes': 'sample notes 1',
    };

    test('itemLinksObjectAsString returns valid', () {
      expect(itemLinksObjectAsString(item), equals(expectedOmitEmpty));
      expect(itemLinksObjectAsString(item, omitEmpty: false), equals(expected));
    });
  });
}