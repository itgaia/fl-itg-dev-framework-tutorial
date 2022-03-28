import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/bloc/notes_item_add_edit_bloc.dart';

import '../../../notes_test_helper.dart';

void main() {
  group('NotesItemAddEditState', () {
    test('CCIAES supports value equality', () {
      expect(sampleNotesItemAddEditState(), equals(sampleNotesItemAddEditState()));
    });

    test('CCIAES props are correct', () {
      expect(
        sampleNotesItemAddEditState(
          status: NotesItemAddEditStatus.initial,
          initialData: sampleNotesItemInitialData,
        ).props,
        equals(sampleNotesItemAddEditStateObjectList),
      );
    });

    test('CCIAES isNew returns true when a new item is being created', () {
      expect(sampleNotesItemAddEditState(initialData: null).isNew, isTrue);
    });

    group('CCIAES copyWith', () {
      test('CCIAES copyWith returns the same object if not arguments are provided', () {
        expect(sampleNotesItemAddEditState().copyWith(), equals(sampleNotesItemAddEditState()));
      });

      test('CCIAES copyWith retains the old value for every parameter if null is provided', () {
        expect(
          sampleNotesItemAddEditState().copyWith(
            status: null,
            initialData: null,
            description: null,
            content: null,
          ),
          equals(sampleNotesItemAddEditState()),
        );
      });

      test('CCIAES copyWith replaces every non-null parameter', () {
        expect(
          sampleNotesItemAddEditState().copyWith(
            status: NotesItemAddEditStatus.success,
            initialData: sampleNotesItemInitialData,
          ),
          equals(
            sampleNotesItemAddEditState(
              status: NotesItemAddEditStatus.success,
              initialData: sampleNotesItemInitialData,
            ),
          ),
        );
      });
    });
  });
}
