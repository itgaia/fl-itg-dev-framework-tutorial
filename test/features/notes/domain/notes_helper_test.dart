import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/notes_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('itemNotesObjectAsString', () {
    const item = NotesModel(id: '1', description: 'sample description 1', content: 'sample content 1');
    const expected = {
      'id': '1',
      'description': 'sample description 1',
      'content': 'sample content 1',
      'createdAt': '',
      'updatedAt': ''
    };
    const expectedOmitEmpty = {
      'id': '1',
      'description': 'sample description 1',
      'content': 'sample content 1',
    };

    test('itemNotesObjectAsString returns valid', () {
      expect(itemNotesObjectAsString(item), equals(expectedOmitEmpty));
      expect(itemNotesObjectAsString(item, omitEmpty: false), equals(expected));
    });
  });
}