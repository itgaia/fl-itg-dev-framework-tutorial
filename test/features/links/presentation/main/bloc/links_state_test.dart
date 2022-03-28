import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_model.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/bloc/links_bloc.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/links_list_filter.dart';

import '../../../links_test_helper.dart';

void main() {
  group('LinksState', () {
    LinksState createSubject({
      LinksStatus status = LinksStatus.initial,
      List<LinksModel>? items,
      LinksListFilter filter = LinksListFilter.all,
      LinksModel? lastDeletedItem,
    }) {
      return LinksState(
        status: status,
        items: items ?? mockLinksItems,
        filter: filter,
        lastDeletedItem: lastDeletedItem,
      );
    }

    test('LNS supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('LNS props are correct', () {
      expect(
        createSubject(
          status: LinksStatus.initial,
          items: mockLinksItems,
          filter: LinksListFilter.all,
          lastDeletedItem: null,
        ).props,
        equals(<Object?>[
          LinksStatus.initial, // status
          mockLinksItems, // todos
          LinksListFilter.all, // filter
          null, // lastDeletedTodo
        ]),
      );
    });

    test('LNS filteredItems returns items filtered by filter', () {
      expect(
        createSubject(
          items: mockLinksItems,
          filter: LinksListFilter.latest,
        ).filteredItems,
        // equals(mockLinksItems.where((item) => item.dtEmpty.isNotEmpty).toList()),
        equals(mockLinksItems.where((item) {
          final DateTime dtUpdatedAt = jsonStringAsValue(item.updatedAt, valueType: 'date');
          final DateTime dtMin = DateTime.now().subtract(const Duration(days: 30+1));
          return dtUpdatedAt.isAfter(dtMin);
        }).toList()),
      );
    });

    group('LNS copyWith', () {
      test('LNS copyWith returns the same object if no arguments are provided', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('LNS copyWith retains the old value for every parameter if null is provided', () {
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

      test('LNS copyWith replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: () => LinksStatus.success,
            items: () => [],
            filter: () => LinksListFilter.latest,
            lastDeletedItem: () => mockLinksItem,
          ),
          equals(
            createSubject(
              status: LinksStatus.success,
              items: [],
              filter: LinksListFilter.latest,
              lastDeletedItem: mockLinksItem,
            ),
          ),
        );
      });

      test('LNS can copyWith null lastDeletedItem', () {
        expect(
          createSubject(lastDeletedItem: mockLinksItem).copyWith(
            lastDeletedItem: () => null,
          ),
          equals(createSubject(lastDeletedItem: null)),
        );
      });
    });
  });
}
