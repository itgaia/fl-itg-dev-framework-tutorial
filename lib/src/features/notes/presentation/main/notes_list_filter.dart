import '../../../../common/helper.dart';
import '../../data/notes_model.dart';

enum NotesListFilter { all, latest }

extension NotesListFilterX on NotesListFilter {
  bool apply(NotesModel item) {
    switch (this) {
      case NotesListFilter.all:
        return true;
      case NotesListFilter.latest:
        final DateTime dtUpdatedAt = jsonStringAsValue(item.updatedAt, valueType: 'date');
        final DateTime dtMin = DateTime.now().subtract(const Duration(days: 30+1));
        return dtUpdatedAt.isAfter(dtMin);
    }
  }

  Iterable<NotesModel> applyAll(Iterable<NotesModel> items) {
    return items.where(apply);
  }
}