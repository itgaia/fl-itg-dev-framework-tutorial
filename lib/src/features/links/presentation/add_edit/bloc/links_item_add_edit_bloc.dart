import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

import '../../../../../common/helper.dart';
import '../../../data/links_model.dart';
import '../../../domain/save_links_item_usecase.dart';

part 'links_item_add_edit_event.dart';
part 'links_item_add_edit_state.dart';

const msgBaseSourceClass = 'LinksItemAddEditBloc';
String msgBaseSourceMethod = '';
void msgLogInfo(String msg) => itgLogVerbose('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');

class LinksItemAddEditBloc extends Bloc<LinksItemAddEditEvent, LinksItemAddEditState> {
  final SaveLinksItemUsecase _saveLinksItemUsecase;

  LinksItemAddEditBloc({
    required SaveLinksItemUsecase saveLinksItemUsecase,
    required LinksModel? initialData
  })  : _saveLinksItemUsecase = saveLinksItemUsecase,
        super(
          LinksItemAddEditState(
            initialData: initialData,
            description: initialData?.description ?? '',
            notes: initialData?.notes ?? '',
      )) {
    on<LinksItemAddEditDescriptionChangedEvent>(_onDescriptionChanged);
    on<LinksItemAddEditNotesChangedEvent>(_onNotesChanged);
    on<LinksItemAddEditSubmittedEvent>(_onSubmitted);
  }

  //** fields start **//
  void _onDescriptionChanged(
      LinksItemAddEditDescriptionChangedEvent event,
      Emitter<LinksItemAddEditState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onNotesChanged(
      LinksItemAddEditNotesChangedEvent event,
      Emitter<LinksItemAddEditState> emit,
  ) {
    emit(state.copyWith(notes: event.notes));
  }
  //** fields end **//

  Future<void> _onSubmitted(
      LinksItemAddEditSubmittedEvent event,
      Emitter<LinksItemAddEditState> emit,
      ) async {
    msgBaseSourceMethod = '_onSubmitted';
    msgLogInfo('start...');
    emit(state.copyWith(status: LinksItemAddEditStatus.submitting));
    msgLogInfo('emitted submitting state...');
    final linksItem = (state.initialData ?? const LinksModel(description: '')).copyWith(
      description: state.description,
      notes: state.notes,
    );

    msgLogInfo('call _saveLinksItemUsecase...');
    final failureOrSuccess = await _saveLinksItemUsecase(linksItem);
    msgLogInfo('failureOrSuccess: $failureOrSuccess');
    emit(
      failureOrSuccess.fold(
        (failure) => state.copyWith(status: LinksItemAddEditStatus.failure),
        (linksItem) => state.copyWith(status: LinksItemAddEditStatus.success)
      )
    );
  }
}