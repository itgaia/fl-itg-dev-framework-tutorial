import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/bloc/notes_item_add_edit_bloc.dart';

void main() {
  group('NotesItemAddEditEvent', () {
    //** fields start **//
    group('NotesItemAddEditDescriptionChangedEvent', () {
      test('CCIAECE code supports value equality', () {
        expect(
          const NotesItemAddEditDescriptionChangedEvent('description'),
          equals(const NotesItemAddEditDescriptionChangedEvent('description')),
        );
      });

      test('CCIAECE code props are correct', () {
        expect(
          const NotesItemAddEditDescriptionChangedEvent('description').props,
          equals(<Object?>['description']),
        );
      });
    });

    group('NotesItemAddEditContentChangedEvent', () {
      test('CCIAECE notes supports value equality', () {
        expect(
          const NotesItemAddEditContentChangedEvent('content'),
          equals(const NotesItemAddEditContentChangedEvent('content')),
        );
      });

      test('CCIAECE notes props are correct', () {
        expect(
          const NotesItemAddEditContentChangedEvent('content').props,
          equals(<Object?>['content']),
        );
      });
    });
    //** fields end **//

    group('NotesItemAddEditSubmittedEvent', () {
      test('CCIAECE submitted supports value equality', () {
        expect(
          const NotesItemAddEditSubmittedEvent(),
          equals(const NotesItemAddEditSubmittedEvent()),
        );
      });

      test('CCIAECE submitted props are correct', () {
        expect(
          const NotesItemAddEditSubmittedEvent().props,
          equals(<Object?>[]),
        );
      });
    });
  });
}