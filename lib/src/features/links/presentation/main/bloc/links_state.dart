part of 'links_bloc.dart';

enum LinksStatus { initial, loading, success, failure }

class LinksState extends Equatable {
  const LinksState({
    this.status = LinksStatus.initial,
    this.items = const [],
    this.filter = LinksListFilter.all,
    this.lastDeletedItem
  });

  final LinksStatus status;
  final List<LinksModel> items;
  final LinksListFilter filter;
  final LinksModel? lastDeletedItem;

  Iterable<LinksModel> get filteredItems => filter.applyAll(items);

  LinksState copyWith({
    LinksStatus Function()? status,
    List<LinksModel> Function()? items,
    LinksListFilter Function()? filter,
    LinksModel? Function()? lastDeletedItem,
  }) {
    return LinksState(
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
