part of 'notes_item_add_edit_bloc.dart';

enum NotesItemAddEditStatus { initial, submitting, success, failure }

extension NotesItemAddEditStatusX on NotesItemAddEditStatus {
  bool get isSubmittingOrSuccess => [
    NotesItemAddEditStatus.submitting,
    NotesItemAddEditStatus.success,
  ].contains(this);
}

class NotesItemAddEditState extends Equatable {
  const NotesItemAddEditState({
    this.status = NotesItemAddEditStatus.initial,
    this.initialData,
    this.id = '',
    this.description = '',
    this.content = '',
  });

  final NotesItemAddEditStatus status;
  final NotesModel? initialData;
  final String id;
  final String description;
  final String content;

  bool get isNew => initialData == null;

  NotesItemAddEditState copyWith({
    NotesItemAddEditStatus? status,
    NotesModel? initialData,
    String? id,
    String? description,
    String? content,
  }) {
    return NotesItemAddEditState(
      status: status ?? this.status,
      initialData: initialData ?? this.initialData,
      id: id ?? this.id,
      description: description ?? this.description,
      content: content ?? this.content,
    );
  }

  @override
  List<Object?> get props => [status, initialData, id, description, content];
}
