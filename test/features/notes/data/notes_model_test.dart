import 'dart:convert';

import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_helper.dart';
import '../notes_test_helper.dart';

void main() {
  final tNotes = notesTestData(count: 3);

  test(
    'should be a subclass of Notes entity',
        () async {
      expect(tNotes.first, isA<NotesModel>());
    },
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      final jsonData = useMongoDbBackend
        ? fixture('notes_mongo_fixture.json')
        : fixture('notes_fixture.json');
      final result = (json.decode(jsonData) as List)
        .map<NotesModel>((json) => NotesModel.fromJson(json)).toList();
      expect(result, tNotes);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final expectedJsonMap = useMongoDbBackend
        ? notesMongoTestMapData(count: tNotes.length)
        : notesTestMapData(count: tNotes.length);
      final result = tNotes.map((NotesModel note) => note.toJson()).toList();
      expect(result, expectedJsonMap);
    });

    test('should return correct data - omit if null or empty', () {
      const item = NotesModel(description: 'description1');
      final result = item.toJson();
      expect(result, equals({'description': 'description1'}));
    });
  });
}
