import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

import '../../../../../common/helper.dart';
import '../../../data/notes_model.dart';
import '../../../domain/save_notes_item_usecase.dart';

part 'notes_item_add_edit_event.dart';
part 'notes_item_add_edit_state.dart';

const msgBaseSourceClass = 'NotesItemAddEditBloc';
String msgBaseSourceMethod = '';
void msgLogInfo(String msg) => itgLogVerbose('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');

class NotesItemAddEditBloc extends Bloc<NotesItemAddEditEvent, NotesItemAddEditState> {
  final SaveNotesItemUsecase _saveNotesItemUsecase;

  NotesItemAddEditBloc({
    required SaveNotesItemUsecase saveNotesItemUsecase,
    required NotesModel? initialData
  })  : _saveNotesItemUsecase = saveNotesItemUsecase,
        super(
          NotesItemAddEditState(
            initialData: initialData,
            description: initialData?.description ?? '',
            content: initialData?.content ?? '',
      )) {
    on<NotesItemAddEditDescriptionChangedEvent>(_onDescriptionChanged);
    on<NotesItemAddEditContentChangedEvent>(_onContentChanged);
    on<NotesItemAddEditSubmittedEvent>(_onSubmitted);
  }

  void _onDescriptionChanged(
      NotesItemAddEditDescriptionChangedEvent event,
      Emitter<NotesItemAddEditState> emit,
  ) {
    msgBaseSourceMethod = '_onDescriptionChanged';
    msgLogInfo('event.description: ${event.description}');
    emit(state.copyWith(description: event.description));
  }

  void _onContentChanged(
      NotesItemAddEditContentChangedEvent event,
      Emitter<NotesItemAddEditState> emit,
  ) {
    emit(state.copyWith(content: event.content));
  }

  Future<void> _onSubmitted(
      NotesItemAddEditSubmittedEvent event,
      Emitter<NotesItemAddEditState> emit,
      ) async {
    msgBaseSourceMethod = '_onSubmitted';
    msgLogInfo('start...');
    emit(state.copyWith(status: NotesItemAddEditStatus.submitting));
    msgLogInfo('emitted submitting state...');
    final notesItem = (state.initialData ?? const NotesModel(description: '')).copyWith(
      description: state.description,
      content: state.content,
    );

    msgLogInfo('call _saveNotesItemUsecase...');
    final failureOrSuccess = await _saveNotesItemUsecase(notesItem);
    msgLogInfo('failureOrSuccess: $failureOrSuccess');
    emit(
      failureOrSuccess.fold(
        (failure) => state.copyWith(status: NotesItemAddEditStatus.failure),
        (notesItem) => state.copyWith(status: NotesItemAddEditStatus.success)
      )
    );
  }
}