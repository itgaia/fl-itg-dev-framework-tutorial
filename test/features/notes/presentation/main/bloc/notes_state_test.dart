import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/bloc/notes_bloc.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/notes_list_filter.dart';

import '../../../notes_test_helper.dart';

void main() {
  group('NotesState', () {
    NotesState createSubject({
      NotesStatus status = NotesStatus.initial,
      List<NotesModel>? items,
      NotesListFilter filter = NotesListFilter.all,
      NotesModel? lastDeletedItem,
    }) {
      return NotesState(
        status: status,
        items: items ?? mockNotesItems,
        filter: filter,
        lastDeletedItem: lastDeletedItem,
      );
    }

    test('CCS supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('CCS props are correct', () {
      expect(
        createSubject(
          status: NotesStatus.initial,
          items: mockNotesItems,
          filter: NotesListFilter.all,
          lastDeletedItem: null,
        ).props,
        equals(<Object?>[
          NotesStatus.initial, // status
          mockNotesItems, // todos
          NotesListFilter.all, // filter
          null, // lastDeletedTodo
        ]),
      );
    });

    test('CCS filteredItems returns items filtered by filter', () {
      expect(
        createSubject(
          items: mockNotesItems,
          filter: NotesListFilter.latest,
        ).filteredItems,
        // equals(mockNotesItems.where((item) => item.dtEmpty.isNotEmpty).toList()),
        equals(mockNotesItems.where((item) {
          final DateTime dtUpdatedAt = jsonStringAsValue(item.updatedAt, valueType: 'date');
          final DateTime dtMin = DateTime.now().subtract(const Duration(days: 30+1));
          return dtUpdatedAt.isAfter(dtMin);
        }).toList()),
      );
    });

    group('CCS copyWith', () {
      test('CCS copyWith returns the same object if no arguments are provided', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('CCS copyWith retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            status: null,
            items: null,
            filter: null,
            lastDeletedItem: null,
          ),
          equals(createSubject()),
        );
      });

      test('CCS copyWith replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: () => NotesStatus.success,
            items: () => [],
            filter: () => NotesListFilter.latest,
            lastDeletedItem: () => mockNotesItem,
          ),
          equals(
            createSubject(
              status: NotesStatus.success,
              items: [],
              filter: NotesListFilter.latest,
              lastDeletedItem: mockNotesItem,
            ),
          ),
        );
      });

      test('CCS can copyWith null lastDeletedItem', () {
        expect(
          createSubject(lastDeletedItem: mockNotesItem).copyWith(
            lastDeletedItem: () => null,
          ),
          equals(createSubject(lastDeletedItem: null)),
        );
      });
    });
  });
}
