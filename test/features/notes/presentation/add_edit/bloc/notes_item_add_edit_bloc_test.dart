import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/bloc/notes_item_add_edit_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../notes_test_helper.dart';

void main() {
  group('NotesItemAddEditBloc', () {
    late MockSaveNotesItemUsecase mockSaveNotesItemUsecase;
    late NotesModel data;

    setUpAll(() {
      registerFallbackValue(FakeNotesItem());
    });

    setUp(() {
      data = notesTestData().first;
      mockSaveNotesItemUsecase = MockSaveNotesItemUsecase();
    });

    NotesItemAddEditBloc buildBloc() {
      return NotesItemAddEditBloc(
        saveNotesItemUsecase: mockSaveNotesItemUsecase,
        initialData: null,
      );
    }

    group('CCIAEB constructor', () {
      test('CCIAEBC works properly', () {
        expect(buildBloc, returnsNormally);
      });

      test('CCIAEBC has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const NotesItemAddEditState()),
        );
      });
    });

    //** fields start **//
    group('NotesItemAddEditDescriptionChangedEvent', () {
      blocTest<NotesItemAddEditBloc, NotesItemAddEditState>(
        'emits new state with updated code',
        build: buildBloc,
        act: (bloc) =>
            bloc.add(const NotesItemAddEditDescriptionChangedEvent('new code')),
        expect: () => const [
          NotesItemAddEditState(description: 'new code'),
        ],
      );
    });

    group('NotesItemAddEditContentChangedEvent', () {
      blocTest<NotesItemAddEditBloc, NotesItemAddEditState>(
        'emits new state with updated notes',
        build: buildBloc,
        act: (bloc) =>
            bloc.add(const NotesItemAddEditContentChangedEvent('new notes')),
        expect: () => const [
          NotesItemAddEditState(content: 'new notes'),
        ],
      );
    });
    //** fields end **//

    group('NotesItemAddEditSubmittedEvent', () {
      blocTest<NotesItemAddEditBloc, NotesItemAddEditState>(
        'attempts to save new item to repository '
        'if no initial data was provided',
        setUp: () {
          when(() => mockSaveNotesItemUsecase(any())).thenAnswer((_) async => Right(data));
        },
        build: buildBloc,
        seed: () => sampleNotesItemAddEditState(),
        act: (bloc) => bloc.add(const NotesItemAddEditSubmittedEvent()),
        expect: () => [
          sampleNotesItemAddEditState(status: NotesItemAddEditStatus.submitting),
          sampleNotesItemAddEditState(status: NotesItemAddEditStatus.success),
        ],
        verify: (bloc) {
          verify(() => mockSaveNotesItemUsecase(any(
                that: isA<NotesModel>()
                    .having((t) => t.description, 'description', equals('description'))
                    .having((t) => t.content, 'content', equals('content'))
          ))).called(1);
        },
      );

      blocTest<NotesItemAddEditBloc, NotesItemAddEditState>(
        'attempts to save updated item to repository '
        'if initial data was provided',
        setUp: () {
          when(() => mockSaveNotesItemUsecase(any())).thenAnswer((_) async => Right(data));
        },
        build: buildBloc,
        seed: () => sampleNotesItemAddEditState(
          initialData: sampleNotesItemInitialData
        ),
        act: (bloc) => bloc.add(const NotesItemAddEditSubmittedEvent()),
        expect: () => [
          sampleNotesItemAddEditState(
            status: NotesItemAddEditStatus.submitting,
            initialData: sampleNotesItemInitialData
          ),
          sampleNotesItemAddEditState(
            status: NotesItemAddEditStatus.success,
            initialData: sampleNotesItemInitialData
          )
        ],
        verify: (bloc) {
          verify(() => mockSaveNotesItemUsecase(any(
                that: isA<NotesModel>()
                    // .having((t) => t.id, 'id', equals('initial-id'))
                    .having((t) => t.id, 'id', equals(sampleNotesItemInitialData.id))
                    .having((t) => t.description, 'description', equals('description'))
                    .having((t) => t.content, 'content', equals('content'))
              )));
        },
      );

      blocTest<NotesItemAddEditBloc, NotesItemAddEditState>(
        'emits new state with error if save to repository fails',
        build: () {
          when(() => mockSaveNotesItemUsecase(any()))
              // .thenThrow(Exception('oops'));
            .thenAnswer((_) async => const Left(ServerFailure()));
          return buildBloc();
        },
        seed: () => sampleNotesItemAddEditState(),
        act: (bloc) => bloc.add(const NotesItemAddEditSubmittedEvent()),
        expect: () => [
          sampleNotesItemAddEditState(status: NotesItemAddEditStatus.submitting),
          sampleNotesItemAddEditState(status: NotesItemAddEditStatus.failure),
        ],
      );
    });
  });
}