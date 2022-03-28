part of 'links_item_add_edit_bloc.dart';

enum LinksItemAddEditStatus { initial, submitting, success, failure }

extension LinksItemAddEditStatusX on LinksItemAddEditStatus {
  bool get isSubmittingOrSuccess => [
    LinksItemAddEditStatus.submitting,
    LinksItemAddEditStatus.success,
  ].contains(this);
}

class LinksItemAddEditState extends Equatable {
  const LinksItemAddEditState({
    this.status = LinksItemAddEditStatus.initial,
    this.initialData,
    this.id = '',
    this.description = '',
    this.notes = '',
  });

  final LinksItemAddEditStatus status;
  final LinksModel? initialData;
  final String id;
  final String description;
  final String notes;

  bool get isNew => initialData == null;

  LinksItemAddEditState copyWith({
    LinksItemAddEditStatus? status,
    LinksModel? initialData,
    String? id,
    String? description,
    String? notes,
  }) {
    return LinksItemAddEditState(
      status: status ?? this.status,
      initialData: initialData ?? this.initialData,
      id: id ?? this.id,
      description: description ?? this.description,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [status, initialData, id, description, notes];
}
