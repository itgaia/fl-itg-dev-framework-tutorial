import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/add_edit/bloc/links_item_add_edit_bloc.dart';

void main() {
  group('LinksItemAddEditEvent', () {
    //** fields start **//
    group('LinksItemAddEditDescriptionChangedEvent', () {
      test('LNIAECE description supports value equality', () {
        expect(
          const LinksItemAddEditDescriptionChangedEvent('description'),
          equals(const LinksItemAddEditDescriptionChangedEvent('description')),
        );
      });

      test('LNIAECE description props are correct', () {
        expect(
          const LinksItemAddEditDescriptionChangedEvent('description').props,
          equals(<Object?>['description']),
        );
      });
    });

    group('LinksItemAddEditNotesChangedEvent', () {
      test('LNIAECE notes supports value equality', () {
        expect(
          const LinksItemAddEditNotesChangedEvent('notes'),
          equals(const LinksItemAddEditNotesChangedEvent('notes')),
        );
      });

      test('LNIAECE notes props are correct', () {
        expect(
          const LinksItemAddEditNotesChangedEvent('notes').props,
          equals(<Object?>['notes']),
        );
      });
    });
    //** fields end **//

    group('LinksItemAddEditSubmittedEvent', () {
      test('LNIAECE submitted supports value equality', () {
        expect(
          const LinksItemAddEditSubmittedEvent(),
          equals(const LinksItemAddEditSubmittedEvent()),
        );
      });

      test('LNIAECE submitted props are correct', () {
        expect(
          const LinksItemAddEditSubmittedEvent().props,
          equals(<Object?>[]),
        );
      });
    });
  });
}