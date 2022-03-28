import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/bloc/notes_bloc.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/notes_list_filter.dart';

import '../../../notes_test_helper.dart';

void main() {
  group('NotesEvent', () {
    final tItem = notesTestData().first;

    group('NotesSubscriptionRequestedEvent', () {
      test('CCSRE supports value equality', () {
        expect(
          const NotesSubscriptionRequestedEvent(),
          equals(const NotesSubscriptionRequestedEvent()),
        );
      });

      test('CCSRE props are correct', () {
        expect(
          const NotesSubscriptionRequestedEvent().props,
          equals(<Object?>[]),
        );
      });
    });

    group('NotesItemSavedEvent', () {
      test('CCISE supports value equality', () {
        expect(
          NotesItemSavedEvent(tItem),
          equals(NotesItemSavedEvent(tItem)),
        );
      });

      test('CCISE props are correct', () {
        expect(
          NotesItemSavedEvent(tItem).props,
          equals(<Object?>[tItem]),
        );
      });
    });

    group('NotesItemDeletedEvent', () {
      test('CCIDE supports value equality', () {
        expect(
          NotesItemDeletedEvent(tItem),
          equals(NotesItemDeletedEvent(tItem)),
        );
      });

      test('CCIDE props are correct', () {
        expect(
          NotesItemDeletedEvent(tItem).props,
          equals(<Object?>[tItem]),
        );
      });
    });

    group('NotesItemUndoDeletionRequestedEvent', () {
      test('CCIUDRE supports value equality', () {
        expect(
          const NotesItemUndoDeletionRequestedEvent(),
          equals(const NotesItemUndoDeletionRequestedEvent()),
        );
      });

      test('CCIUDRE props are correct', () {
        expect(
          const NotesItemUndoDeletionRequestedEvent().props,
          equals(<Object?>[]),
        );
      });
    });

    group('NotesFilterChangedEvent', () {
      test('CCFCE supports value equality', () {
        expect(
          const NotesFilterChangedEvent(NotesListFilter.all),
          equals(const NotesFilterChangedEvent(NotesListFilter.all)),
        );
      });

      test('CCFCE props are correct', () {
        expect(
          const NotesFilterChangedEvent(NotesListFilter.all).props,
          equals(<Object?>[NotesListFilter.all]),
        );
      });
    });
  });
}