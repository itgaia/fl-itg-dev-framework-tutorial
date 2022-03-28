part of 'links_item_add_edit_bloc.dart';

abstract class LinksItemAddEditEvent extends Equatable {
  const LinksItemAddEditEvent();

  @override
  List<Object> get props => [];
}

//** fields start **//
class LinksItemAddEditDescriptionChangedEvent extends LinksItemAddEditEvent {
  final String description;

  const LinksItemAddEditDescriptionChangedEvent(this.description);

  @override
  List<Object> get props => [description];
}

class LinksItemAddEditNotesChangedEvent extends LinksItemAddEditEvent {
  final String notes;

  const LinksItemAddEditNotesChangedEvent(this.notes);

  @override
  List<Object> get props => [notes];
}
//** fields end **//

class LinksItemAddEditSubmittedEvent extends LinksItemAddEditEvent {
  const LinksItemAddEditSubmittedEvent();
}
