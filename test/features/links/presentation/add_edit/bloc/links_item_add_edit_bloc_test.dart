import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_model.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/add_edit/bloc/links_item_add_edit_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../links_test_helper.dart';

void main() {
  group('LinksItemAddEditBloc', () {
    late MockSaveLinksItemUsecase mockSaveLinksItemUsecase;
    late LinksModel data;

    setUpAll(() {
      registerFallbackValue(FakeLinksItem());
    });

    setUp(() {
      data = linksTestData().first;
      mockSaveLinksItemUsecase = MockSaveLinksItemUsecase();
    });

    LinksItemAddEditBloc buildBloc() {
      return LinksItemAddEditBloc(
        saveLinksItemUsecase: mockSaveLinksItemUsecase,
        initialData: null,
      );
    }

    group('LNIAEB constructor', () {
      test('LNIAEBC works properly', () {
        expect(buildBloc, returnsNormally);
      });

      test('LNIAEBC has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const LinksItemAddEditState()),
        );
      });
    });

    //** fields start **//
    group('LinksItemAddEditDescriptionChangedEvent', () {
      blocTest<LinksItemAddEditBloc, LinksItemAddEditState>(
        'emits new state with updated description',
        build: buildBloc,
        act: (bloc) =>
            bloc.add(const LinksItemAddEditDescriptionChangedEvent('new description')),
        expect: () => const [
          LinksItemAddEditState(description: 'new description'),
        ],
      );
    });

    group('LinksItemAddEditNotesChangedEvent', () {
      blocTest<LinksItemAddEditBloc, LinksItemAddEditState>(
        'emits new state with updated notes',
        build: buildBloc,
        act: (bloc) =>
            bloc.add(const LinksItemAddEditDescriptionChangedEvent('new notes')),
        expect: () => const [
          LinksItemAddEditState(description: 'new notes'),
        ],
      );
    });
    //** fields end **//

    group('LinksItemAddEditSubmittedEvent', () {
      blocTest<LinksItemAddEditBloc, LinksItemAddEditState>(
        'attempts to save new item to repository '
        'if no initial data was provided',
        setUp: () {
          when(() => mockSaveLinksItemUsecase(any())).thenAnswer((_) async => Right(data));
        },
        build: buildBloc,
        seed: () => sampleLinksItemAddEditState(),
        act: (bloc) => bloc.add(const LinksItemAddEditSubmittedEvent()),
        expect: () => [
          sampleLinksItemAddEditState(status: LinksItemAddEditStatus.submitting),
          sampleLinksItemAddEditState(status: LinksItemAddEditStatus.success),
        ],
        verify: (bloc) {
          verify(() => mockSaveLinksItemUsecase(any(
                that: isA<LinksModel>()
                    .having((t) => t.description, 'description', equals('description'))
                    .having((t) => t.notes, 'notes', equals('notes'))
          ))).called(1);
        },
      );

      blocTest<LinksItemAddEditBloc, LinksItemAddEditState>(
        'attempts to save updated item to repository '
        'if initial data was provided',
        setUp: () {
          when(() => mockSaveLinksItemUsecase(any())).thenAnswer((_) async => Right(data));
        },
        build: buildBloc,
        seed: () => sampleLinksItemAddEditState(
          initialData: sampleLinksItemInitialData
        ),
        act: (bloc) => bloc.add(const LinksItemAddEditSubmittedEvent()),
        expect: () => [
          sampleLinksItemAddEditState(
            status: LinksItemAddEditStatus.submitting,
            initialData: sampleLinksItemInitialData
          ),
          sampleLinksItemAddEditState(
            status: LinksItemAddEditStatus.success,
            initialData: sampleLinksItemInitialData
          )
        ],
        verify: (bloc) {
          verify(() => mockSaveLinksItemUsecase(any(
                that: isA<LinksModel>()
                    // .having((t) => t.id, 'id', equals('initial-id'))
                    .having((t) => t.id, 'id', equals(sampleLinksItemInitialData.id))
                    .having((t) => t.description, 'description', equals('description'))
                    .having((t) => t.notes, 'notes', equals('notes'))
              )));
        },
      );

      blocTest<LinksItemAddEditBloc, LinksItemAddEditState>(
        'emits new state with error if save to repository fails',
        build: () {
          when(() => mockSaveLinksItemUsecase(any()))
              // .thenThrow(Exception('oops'));
            .thenAnswer((_) async => const Left(ServerFailure()));
          return buildBloc();
        },
        seed: () => sampleLinksItemAddEditState(),
        act: (bloc) => bloc.add(const LinksItemAddEditSubmittedEvent()),
        expect: () => [
          sampleLinksItemAddEditState(status: LinksItemAddEditStatus.submitting),
          sampleLinksItemAddEditState(status: LinksItemAddEditStatus.failure),
        ],
      );
    });
  });
}