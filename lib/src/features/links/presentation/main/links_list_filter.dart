import '../../../../common/helper.dart';
import '../../data/links_model.dart';

enum LinksListFilter { all, latest }

extension LinksListFilterX on LinksListFilter {
  bool apply(LinksModel item) {
    switch (this) {
      case LinksListFilter.all:
        return true;
      case LinksListFilter.latest:
        final DateTime dtUpdatedAt = jsonStringAsValue(item.updatedAt, valueType: 'date');
        final DateTime dtMin = DateTime.now().subtract(const Duration(days: 30+1));
        return dtUpdatedAt.isAfter(dtMin);
    }
  }

  Iterable<LinksModel> applyAll(Iterable<LinksModel> items) {
    return items.where(apply);
  }
}