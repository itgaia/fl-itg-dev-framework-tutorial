part of 'notes_item_add_edit_bloc.dart';

abstract class NotesItemAddEditEvent extends Equatable {
  const NotesItemAddEditEvent();

  @override
  List<Object> get props => [];
}

class NotesItemAddEditDescriptionChangedEvent extends NotesItemAddEditEvent {
  final String description;

  const NotesItemAddEditDescriptionChangedEvent(this.description);

  @override
  List<Object> get props => [description];
}

class NotesItemAddEditContentChangedEvent extends NotesItemAddEditEvent {
  final String content;

  const NotesItemAddEditContentChangedEvent(this.content);

  @override
  List<Object> get props => [content];
}

class NotesItemAddEditSubmittedEvent extends NotesItemAddEditEvent {
  const NotesItemAddEditSubmittedEvent();
}
