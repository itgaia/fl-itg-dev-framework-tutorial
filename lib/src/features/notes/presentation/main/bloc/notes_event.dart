part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class NotesSubscriptionRequestedEvent extends NotesEvent {
  const NotesSubscriptionRequestedEvent();
}

class NotesItemSavedEvent extends NotesEvent {
  const NotesItemSavedEvent(this.item);

  final NotesModel item;

  @override
  List<Object> get props => [item];
}

class NotesItemDeletedEvent extends NotesEvent {
  const NotesItemDeletedEvent(this.item);

  final NotesModel item;

  @override
  List<Object> get props => [item];
}

class NotesItemUndoDeletionRequestedEvent extends NotesEvent {
  const NotesItemUndoDeletionRequestedEvent();
}

class NotesFilterChangedEvent extends NotesEvent {
  const NotesFilterChangedEvent(this.filter);

  final NotesListFilter filter;

  @override
  List<Object> get props => [filter];
}
