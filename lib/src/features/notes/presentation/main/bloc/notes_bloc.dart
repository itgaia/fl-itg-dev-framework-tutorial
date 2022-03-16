import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


import '../../../../../app/injection_container.dart';
import '../../../../../common/helper.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../data/notes_model.dart';
import '../../../domain/delete_notes_item_usecase.dart';
import '../../../domain/get_notes_usecase.dart';
import '../../../domain/save_notes_item_usecase.dart';
import '../notes_list_filter.dart';

part 'notes_event.dart';
part 'notes_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc({
    // required GetNotesUsecase usecase,
    required this.usecase,
  })  : //_getNotesUsecase = usecase,
        super(const NotesState()) {
    itgLogVerbose('[NotesBloc constructor] usecase: $usecase');
    on<NotesSubscriptionRequestedEvent>(_onNotesSubscriptionRequestedEvent);
    on<NotesItemSavedEvent>(_onNotesItemSavedEvent);
    on<NotesItemDeletedEvent>(_onNotesItemDeletedEvent);
    on<NotesItemUndoDeletionRequestedEvent>(_onNotesItemUndoDeletionRequestedEvent);
    on<NotesFilterChangedEvent>(_onNotesFilterChangedEvent);
  }

  // final GetNotesUsecase _getNotesUsecase;
  final GetNotesUsecase usecase;

  // TODO: If there is no problem in get them from the sl, use it also in getXXX
  final SaveNotesItemUsecase _saveItemUsecase = sl<SaveNotesItemUsecase>();
  final DeleteNotesItemUsecase _deleteItemUsecase = sl<DeleteNotesItemUsecase>();

  Future<void> _onNotesSubscriptionRequestedEvent(
      NotesSubscriptionRequestedEvent event,
      Emitter<NotesState> emit,
      // ) async* {
      ) async {
    const String baseLogMsg = '[NotesBloc._onNotesSubscriptionRequestedEvent]';
    itgLogVerbose('$baseLogMsg loading...');
    emit(state.copyWith(status: () => NotesStatus.loading));

    itgLogVerbose('$baseLogMsg call usecase: $usecase');
    final failureOrSuccess = await usecase(NoParams());

    emit(failureOrSuccess.fold(
      (failure) => state.copyWith(status: () => NotesStatus.failure),
          // TODO: where to pass the error msg? Error(message: failure.toString()),
      (items) => state.copyWith(
        status: () => NotesStatus.success,
        items: () => items
      )));
    itgLogVerbose('$baseLogMsg status emitted!');
  }

  Future<void> _onNotesItemSavedEvent (
    NotesItemSavedEvent event, Emitter<NotesState> emit) async {
    await _saveItemUsecase(event.item);
  }

  Future<void> _onNotesItemDeletedEvent (
    NotesItemDeletedEvent event, Emitter<NotesState> emit) async {
    emit(state.copyWith(lastDeletedItem: () => event.item));
    await _deleteItemUsecase(event.item.id!);
  }

  Future<void> _onNotesItemUndoDeletionRequestedEvent (
      NotesItemUndoDeletionRequestedEvent event,
      Emitter<NotesState> emit,
      ) async {
    assert(state.lastDeletedItem != null, 'Last deleted ITEM can not be null.');

    final item = state.lastDeletedItem!;
    emit(state.copyWith(lastDeletedItem: () => null));
    await _saveItemUsecase(item);
  }

  Future<void> _onNotesFilterChangedEvent (
      NotesFilterChangedEvent event,
      Emitter<NotesState> emit,
      ) async {
    emit(state.copyWith(filter: () => event.filter));
  }
}

