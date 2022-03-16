import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';
import 'package:dev_framework_tutorial/src/core/usecase/usecase.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/delete_notes_item_usecase.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/save_notes_item_usecase.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/bloc/notes_bloc.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/notes_list_filter.dart';
import 'package:mocktail/mocktail.dart';

import '../../notes_test_helper.dart';

void main() {
  final tItems = notesTestData();
  final tItem = tItems.first;
  // late NotesBloc bloc;
  late MockGetNotesUsecase mockGetNotesUsecase;
  late SaveNotesItemUsecase mockSaveNotesItemUsecase;
  late DeleteNotesItemUsecase mockDeleteNotesItemUsecase;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const NotesModel(description: '111'));
  });

  setUp(() {
    mockGetNotesUsecase = MockGetNotesUsecase();
    // bloc = NotesBloc(notes: mockGetNotesUsecase);
    if (!sl.isRegistered<SaveNotesItemUsecase>()) {
      mockSaveNotesItemUsecase = MockSaveNotesItemUsecase();
      sl.registerLazySingleton<SaveNotesItemUsecase>(() => mockSaveNotesItemUsecase);
    } else {
      mockSaveNotesItemUsecase = sl<SaveNotesItemUsecase>();
    }
    if (!sl.isRegistered<DeleteNotesItemUsecase>()) {
      mockDeleteNotesItemUsecase = MockDeleteNotesItemUsecase();
      sl.registerLazySingleton<DeleteNotesItemUsecase>(() => mockDeleteNotesItemUsecase);
    } else {
      mockDeleteNotesItemUsecase = sl<DeleteNotesItemUsecase>();
    }
  });

  NotesBloc buildBloc() {
    return NotesBloc(usecase: mockGetNotesUsecase);
  }

  group('CCB constructor', () {
    test('CCB works properly', () => expect(buildBloc, returnsNormally));

    test('CCB has correct initial state', () {
      expect(buildBloc().state, equals(const NotesState()));
    });
  });

  group('NotesSubscriptionRequestedEvent', () {
    blocTest<NotesBloc, NotesState>(
      'CCB starts listening to GetNotesUsecase stream',
      // build: buildBloc,
      build: () {
        when(() => mockGetNotesUsecase.call(any()))
            .thenAnswer((_) async => Right(tItems));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const NotesSubscriptionRequestedEvent()),
      verify: (bloc) {
        verify(() => mockGetNotesUsecase(NoParams())).called(1);
      }
    );

    blocTest<NotesBloc, NotesState>(
      'CCB emits state with updated status and items '
      'when GetNotesUsecase stream emits new items',
      // build: buildBloc,
      build: () {
        when(() => mockGetNotesUsecase.call(any()))
            .thenAnswer((_) async => Right(tItems));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const NotesSubscriptionRequestedEvent()),
      expect: () => [
        const NotesState(
          status: NotesStatus.loading,
        ),
        NotesState(
          status: NotesStatus.success,
          items: tItems,
        ),
      ],
    );

    blocTest<NotesBloc, NotesState>(
      'CCB emits state with failure status '
      'when GetNotesUsecase stream emits error',
      setUp: () {
        when(() => mockGetNotesUsecase(any()))
          // .thenAnswer((_) => Stream.error(Exception('oops')));
          .thenAnswer((_) async => const Left(ServerFailure()));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const NotesSubscriptionRequestedEvent()),
      expect: () => [
        const NotesState(status: NotesStatus.loading),
        const NotesState(status: NotesStatus.failure),
      ],
    );
  });

  group('NotesItemSavedEvent', () {
    blocTest<NotesBloc, NotesState>(
      'saves item using repository',
      // build: buildBloc,
      build: () {
        when(() => mockSaveNotesItemUsecase.call(any()))
            .thenAnswer((_) async => Right(tItem));
        return buildBloc();
      },
      act: (bloc) => bloc.add(NotesItemSavedEvent(tItem)),
      verify: (bloc) {
        verify(() => mockSaveNotesItemUsecase(tItem)).called(1);
      },
    );
  });

  group('NotesItemDeletedEvent', () {
    blocTest<NotesBloc, NotesState>(
      'deletes item using usecase',
      // build: buildBloc,
      build: () {
        when(() => mockDeleteNotesItemUsecase.call(any()))
            .thenAnswer((_) async => const Right(null));
        return buildBloc();
      },
      seed: () => NotesState(items: tItems),
      act: (bloc) => bloc.add(NotesItemDeletedEvent(tItem)),
      verify: (bloc) {
        verify(() => mockDeleteNotesItemUsecase(tItem.id!)).called(1);
      },
    );
  });

  group('NotesItemUndoDeletionRequestedEvent', () {
    blocTest<NotesBloc, NotesState>(
      'restores last deleted undo and clears lastDeletedUndo field',
      // build: buildBloc,
      build: () {
        when(() => mockSaveNotesItemUsecase.call(any()))
            .thenAnswer((_) async => Right(tItem));
        return buildBloc();
      },
      seed: () => NotesState(lastDeletedItem: tItem),
      act: (bloc) => bloc.add(const NotesItemUndoDeletionRequestedEvent()),
      expect: () => const [NotesState()],
      verify: (bloc) {
        verify(() => mockSaveNotesItemUsecase(tItem)).called(1);
      },
    );
  });

  group('NotesFilterChangedEvent', () {
    blocTest<NotesBloc, NotesState>(
      'emits state with updated filter',
      build: buildBloc,
      act: (bloc) => bloc.add(
        const NotesFilterChangedEvent(NotesListFilter.latest),
      ),
      expect: () => const [
        NotesState(filter: NotesListFilter.latest),
      ],
    );
  });
}
