import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/bloc/links_bloc.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/links_list_filter.dart';

import '../../../links_test_helper.dart';

void main() {
  group('LinksEvent', () {
    final tItem = linksTestData().first;

    group('LinksSubscriptionRequestedEvent', () {
      test('LNSRE supports value equality', () {
        expect(
          const LinksSubscriptionRequestedEvent(),
          equals(const LinksSubscriptionRequestedEvent()),
        );
      });

      test('LNSRE props are correct', () {
        expect(
          const LinksSubscriptionRequestedEvent().props,
          equals(<Object?>[]),
        );
      });
    });

    group('LinksItemSavedEvent', () {
      test('LNISE supports value equality', () {
        expect(
          LinksItemSavedEvent(tItem),
          equals(LinksItemSavedEvent(tItem)),
        );
      });

      test('LNISE props are correct', () {
        expect(
          LinksItemSavedEvent(tItem).props,
          equals(<Object?>[tItem]),
        );
      });
    });

    group('LinksItemDeletedEvent', () {
      test('LNIDE supports value equality', () {
        expect(
          LinksItemDeletedEvent(tItem),
          equals(LinksItemDeletedEvent(tItem)),
        );
      });

      test('LNIDE props are correct', () {
        expect(
          LinksItemDeletedEvent(tItem).props,
          equals(<Object?>[tItem]),
        );
      });
    });

    group('LinksItemUndoDeletionRequestedEvent', () {
      test('LNIUDRE supports value equality', () {
        expect(
          const LinksItemUndoDeletionRequestedEvent(),
          equals(const LinksItemUndoDeletionRequestedEvent()),
        );
      });

      test('LNIUDRE props are correct', () {
        expect(
          const LinksItemUndoDeletionRequestedEvent().props,
          equals(<Object?>[]),
        );
      });
    });

    group('LinksFilterChangedEvent', () {
      test('LNFCE supports value equality', () {
        expect(
          const LinksFilterChangedEvent(LinksListFilter.all),
          equals(const LinksFilterChangedEvent(LinksListFilter.all)),
        );
      });

      test('LNFCE props are correct', () {
        expect(
          const LinksFilterChangedEvent(LinksListFilter.all).props,
          equals(<Object?>[LinksListFilter.all]),
        );
      });
    });
  });
}