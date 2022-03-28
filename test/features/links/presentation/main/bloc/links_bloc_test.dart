import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';
import 'package:dev_framework_tutorial/src/core/usecase/usecase.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/delete_links_item_usecase.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/save_links_item_usecase.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/bloc/links_bloc.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/links_list_filter.dart';
import 'package:mocktail/mocktail.dart';

import '../../../links_test_helper.dart';

void main() {
  final tItems = linksTestData();
  final tItem = tItems.first;
  // late LinksBloc bloc;
  late MockGetLinksUsecase mockGetLinksUsecase;
  late SaveLinksItemUsecase mockSaveLinksItemUsecase;
  late DeleteLinksItemUsecase mockDeleteLinksItemUsecase;

  setUpAll(() {
    registerFallbackValue(NoParams());
    linksRegisterFallbackValue();
  });

  setUp(() {
    mockGetLinksUsecase = MockGetLinksUsecase();
    // bloc = LinksBloc(links: mockGetLinksUsecase);
    if (!sl.isRegistered<SaveLinksItemUsecase>()) {
      mockSaveLinksItemUsecase = MockSaveLinksItemUsecase();
      sl.registerLazySingleton<SaveLinksItemUsecase>(() => mockSaveLinksItemUsecase);
    } else {
      mockSaveLinksItemUsecase = sl<SaveLinksItemUsecase>();
    }
    if (!sl.isRegistered<DeleteLinksItemUsecase>()) {
      mockDeleteLinksItemUsecase = MockDeleteLinksItemUsecase();
      sl.registerLazySingleton<DeleteLinksItemUsecase>(() => mockDeleteLinksItemUsecase);
    } else {
      mockDeleteLinksItemUsecase = sl<DeleteLinksItemUsecase>();
    }
  });

  LinksBloc buildBloc() {
    return LinksBloc(usecase: mockGetLinksUsecase);
  }

  group('LNB constructor', () {
    test('LNB works properly', () => expect(buildBloc, returnsNormally));

    test('LNB has correct initial state', () {
      expect(buildBloc().state, equals(const LinksState()));
    });
  });

  group('LinksSubscriptionRequestedEvent', () {
    blocTest<LinksBloc, LinksState>(
      'LNB starts listening to GetLinksUsecase stream',
      // build: buildBloc,
      build: () {
        when(() => mockGetLinksUsecase.call(any()))
            .thenAnswer((_) async => Right(tItems));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LinksSubscriptionRequestedEvent()),
      verify: (bloc) {
        verify(() => mockGetLinksUsecase(NoParams())).called(1);
      }
    );

    blocTest<LinksBloc, LinksState>(
      'LNB emits state with updated status and items '
      'when GetLinksUsecase stream emits new items',
      // build: buildBloc,
      build: () {
        when(() => mockGetLinksUsecase.call(any()))
            .thenAnswer((_) async => Right(tItems));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LinksSubscriptionRequestedEvent()),
      expect: () => [
        const LinksState(
          status: LinksStatus.loading,
        ),
        LinksState(
          status: LinksStatus.success,
          items: tItems,
        ),
      ],
    );

    blocTest<LinksBloc, LinksState>(
      'LNB emits state with failure status '
      'when GetLinksUsecase stream emits error',
      setUp: () {
        when(() => mockGetLinksUsecase(any()))
          // .thenAnswer((_) => Stream.error(Exception('oops')));
          .thenAnswer((_) async => const Left(ServerFailure()));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const LinksSubscriptionRequestedEvent()),
      expect: () => [
        const LinksState(status: LinksStatus.loading),
        const LinksState(status: LinksStatus.failure),
      ],
    );
  });

  group('LinksItemSavedEvent', () {
    blocTest<LinksBloc, LinksState>(
      'saves item using repository',
      // build: buildBloc,
      build: () {
        when(() => mockSaveLinksItemUsecase.call(any()))
            .thenAnswer((_) async => Right(tItem));
        return buildBloc();
      },
      act: (bloc) => bloc.add(LinksItemSavedEvent(tItem)),
      verify: (bloc) {
        verify(() => mockSaveLinksItemUsecase(tItem)).called(1);
      },
    );
  });

  group('LinksItemDeletedEvent', () {
    blocTest<LinksBloc, LinksState>(
      'deletes item using usecase',
      // build: buildBloc,
      build: () {
        when(() => mockDeleteLinksItemUsecase.call(any()))
            .thenAnswer((_) async => const Right(null));
        return buildBloc();
      },
      seed: () => LinksState(items: tItems),
      act: (bloc) => bloc.add(LinksItemDeletedEvent(tItem)),
      verify: (bloc) {
        verify(() => mockDeleteLinksItemUsecase(tItem.id!)).called(1);
      },
    );
  });

  group('LinksItemUndoDeletionRequestedEvent', () {
    blocTest<LinksBloc, LinksState>(
      'restores last deleted undo and clears lastDeletedUndo field',
      // build: buildBloc,
      build: () {
        when(() => mockSaveLinksItemUsecase.call(any()))
            .thenAnswer((_) async => Right(tItem));
        return buildBloc();
      },
      seed: () => LinksState(lastDeletedItem: tItem),
      act: (bloc) => bloc.add(const LinksItemUndoDeletionRequestedEvent()),
      expect: () => const [LinksState()],
      verify: (bloc) {
        verify(() => mockSaveLinksItemUsecase(tItem)).called(1);
      },
    );
  });

  group('LinksFilterChangedEvent', () {
    blocTest<LinksBloc, LinksState>(
      'emits state with updated filter',
      build: buildBloc,
      act: (bloc) => bloc.add(
        const LinksFilterChangedEvent(LinksListFilter.latest),
      ),
      expect: () => const [
        LinksState(filter: LinksListFilter.latest),
      ],
    );
  });
}
