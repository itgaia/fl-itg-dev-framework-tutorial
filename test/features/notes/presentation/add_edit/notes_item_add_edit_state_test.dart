import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/bloc/notes_item_add_edit_bloc.dart';

void main() {
  group('NotesItemAddEditState', () {
    const mockInitialData = NotesModel(
      id: '1',
      description: 'description 1',
      content: 'content 1',
    );

    NotesItemAddEditState createSubject({
      NotesItemAddEditStatus status = NotesItemAddEditStatus.initial,
      NotesModel? initialData,
      String id = '',
      String description = '',
      String content = '',
    }) {
      return NotesItemAddEditState(
        status: status,
        initialData: initialData,
        description: description,
        content: content,
      );
    }

    test('CCIAES supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('CCIAES props are correct', () {
      expect(
        createSubject(
          status: NotesItemAddEditStatus.initial,
          initialData: mockInitialData,
          id: '',
          description: 'description',
          content: 'content',
        ).props,
        equals(<Object?>[
          NotesItemAddEditStatus.initial,
          mockInitialData,
          '',
          'description',
          'content',
        ]),
      );
    });

    test('CCIAES isNew returns true when a new item is being created', () {
      expect(createSubject(initialData: null).isNew, isTrue);
    });

    group('CCIAES copyWith', () {
      test('CCIAES copyWith returns the same object if not arguments are provided', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('CCIAES copyWith retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            status: null,
            initialData: null,
            description: null,
            content: null,
          ),
          equals(createSubject()),
        );
      });

      test('CCIAES copyWith replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: NotesItemAddEditStatus.success,
            initialData: mockInitialData,
            description: 'description',
            content: 'content',
          ),
          equals(
            createSubject(
              status: NotesItemAddEditStatus.success,
              initialData: mockInitialData,
              description: 'description',
              content: 'content',
            ),
          ),
        );
      });
    });
  });
}
