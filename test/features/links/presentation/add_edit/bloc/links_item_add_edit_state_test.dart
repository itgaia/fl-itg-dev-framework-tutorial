import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/add_edit/bloc/links_item_add_edit_bloc.dart';

import '../../../links_test_helper.dart';

void main() {
  group('LinksItemAddEditState', () {
    test('LNIAES supports value equality', () {
      expect(sampleLinksItemAddEditState(), equals(sampleLinksItemAddEditState()));
    });

    test('LNIAES props are correct', () {
      expect(
        sampleLinksItemAddEditState(
          status: LinksItemAddEditStatus.initial,
          initialData: sampleLinksItemInitialData,
        ).props,
        equals(sampleLinksItemAddEditStateObjectList),
      );
    });

    test('LNIAES isNew returns true when a new item is being created', () {
      expect(sampleLinksItemAddEditState(initialData: null).isNew, isTrue);
    });

    group('LNIAES copyWith', () {
      test('LNIAES copyWith returns the same object if not arguments are provided', () {
        expect(sampleLinksItemAddEditState().copyWith(), equals(sampleLinksItemAddEditState()));
      });

      test('LNIAES copyWith retains the old value for every parameter if null is provided', () {
        expect(
          sampleLinksItemAddEditState().copyWith(
            status: null,
            initialData: null,
            description: null,
            notes: null,
          ),
          equals(sampleLinksItemAddEditState()),
        );
      });

      test('LNIAES copyWith replaces every non-null parameter', () {
        expect(
          sampleLinksItemAddEditState().copyWith(
            status: LinksItemAddEditStatus.success,
            initialData: sampleLinksItemInitialData,
          ),
          equals(
            sampleLinksItemAddEditState(
              status: LinksItemAddEditStatus.success,
              initialData: sampleLinksItemInitialData,
            ),
          ),
        );
      });
    });
  });
}
