part of 'notes_bloc.dart';

enum NotesStatus { initial, loading, success, failure }

class NotesState extends Equatable {
  const NotesState({
    this.status = NotesStatus.initial,
    this.items = const [],
    this.filter = NotesListFilter.all,
    this.lastDeletedItem
  });

  final NotesStatus status;
  final List<NotesModel> items;
  final NotesListFilter filter;
  final NotesModel? lastDeletedItem;

  Iterable<NotesModel> get filteredItems => filter.applyAll(items);

  NotesState copyWith({
    NotesStatus Function()? status,
    List<NotesModel> Function()? items,
    NotesListFilter Function()? filter,
    NotesModel? Function()? lastDeletedItem,
  }) {
    return NotesState(
      status: status != null ? status() : this.status,
      items: items != null ? items() : this.items,
      filter: filter != null ? filter() : this.filter,
      lastDeletedItem: lastDeletedItem != null ? lastDeletedItem() : this.lastDeletedItem,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    filter,
    lastDeletedItem,
  ];
}
