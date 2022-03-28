part of 'links_bloc.dart';

abstract class LinksEvent extends Equatable {
  const LinksEvent();

  @override
  List<Object> get props => [];
}

class LinksSubscriptionRequestedEvent extends LinksEvent {
  const LinksSubscriptionRequestedEvent();
}

class LinksItemSavedEvent extends LinksEvent {
  const LinksItemSavedEvent(this.item);

  final LinksModel item;

  @override
  List<Object> get props => [item];
}

class LinksItemDeletedEvent extends LinksEvent {
  const LinksItemDeletedEvent(this.item);

  final LinksModel item;

  @override
  List<Object> get props => [item];
}

class LinksItemUndoDeletionRequestedEvent extends LinksEvent {
  const LinksItemUndoDeletionRequestedEvent();
}

class LinksFilterChangedEvent extends LinksEvent {
  const LinksFilterChangedEvent(this.filter);

  final LinksListFilter filter;

  @override
  List<Object> get props => [filter];
}
