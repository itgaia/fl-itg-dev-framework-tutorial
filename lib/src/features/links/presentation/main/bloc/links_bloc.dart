import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


import '../../../../../app/injection_container.dart';
import '../../../../../common/helper.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../data/links_model.dart';
import '../../../domain/delete_links_item_usecase.dart';
import '../../../domain/get_links_usecase.dart';
import '../../../domain/save_links_item_usecase.dart';
import '../links_list_filter.dart';

part 'links_event.dart';
part 'links_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class LinksBloc extends Bloc<LinksEvent, LinksState> {
  LinksBloc({
    // required GetLinksUsecase usecase,
    required this.usecase,
  })  : //_getLinksUsecase = usecase,
        super(const LinksState()) {
    itgLogVerbose('[LinksBloc constructor] usecase: $usecase');
    on<LinksSubscriptionRequestedEvent>(_onLinksSubscriptionRequestedEvent);
    on<LinksItemSavedEvent>(_onLinksItemSavedEvent);
    on<LinksItemDeletedEvent>(_onLinksItemDeletedEvent);
    on<LinksItemUndoDeletionRequestedEvent>(_onLinksItemUndoDeletionRequestedEvent);
    on<LinksFilterChangedEvent>(_onLinksFilterChangedEvent);
  }

  // final GetLinksUsecase _getLinksUsecase;
  final GetLinksUsecase usecase;

  // TODO: If there is no problem in get them from the sl, use it also in getXXX
  final SaveLinksItemUsecase _saveItemUsecase = sl<SaveLinksItemUsecase>();
  final DeleteLinksItemUsecase _deleteItemUsecase = sl<DeleteLinksItemUsecase>();

  Future<void> _onLinksSubscriptionRequestedEvent(
      LinksSubscriptionRequestedEvent event,
      Emitter<LinksState> emit,
      // ) async* {
      ) async {
    const String baseLogMsg = '[LinksBloc._onLinksSubscriptionRequestedEvent]';
    itgLogVerbose('$baseLogMsg loading...');
    emit(state.copyWith(status: () => LinksStatus.loading));

    itgLogVerbose('$baseLogMsg call usecase: $usecase');
    final failureOrSuccess = await usecase(NoParams());

    emit(failureOrSuccess.fold(
      (failure) => state.copyWith(status: () => LinksStatus.failure),
          // TODO: where to pass the error msg? Error(message: failure.toString()),
      (items) => state.copyWith(
        status: () => LinksStatus.success,
        items: () => items
      )));
    itgLogVerbose('$baseLogMsg status emitted!');
  }

  Future<void> _onLinksItemSavedEvent (
    LinksItemSavedEvent event, Emitter<LinksState> emit) async {
    await _saveItemUsecase(event.item);
  }

  Future<void> _onLinksItemDeletedEvent (
    LinksItemDeletedEvent event, Emitter<LinksState> emit) async {
    emit(state.copyWith(lastDeletedItem: () => event.item));
    await _deleteItemUsecase(event.item.id!);
  }

  Future<void> _onLinksItemUndoDeletionRequestedEvent (
      LinksItemUndoDeletionRequestedEvent event,
      Emitter<LinksState> emit,
      ) async {
    assert(state.lastDeletedItem != null, 'Last deleted ITEM can not be null.');

    final item = state.lastDeletedItem!;
    emit(state.copyWith(lastDeletedItem: () => null));
    await _saveItemUsecase(item);
  }

  Future<void> _onLinksFilterChangedEvent (
      LinksFilterChangedEvent event,
      Emitter<LinksState> emit,
      ) async {
    emit(state.copyWith(filter: () => event.filter));
  }
}

