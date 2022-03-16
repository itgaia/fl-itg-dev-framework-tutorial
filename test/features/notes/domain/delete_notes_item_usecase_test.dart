import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/delete_notes_item_usecase.dart';
import 'package:mockingjay/mockingjay.dart';

import '../notes_test_helper.dart';

void main() {
  late MockNotesRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeNotesItem());
  });

  setUp(() {
    mockRepository = MockNotesRepository();
  });

  DeleteNotesItemUsecase createSubject() => DeleteNotesItemUsecase(mockRepository);

  group('DeleteNotesItemUsecase', () {
    test('DCCIUC constructor works properly', () {
      expect(createSubject, returnsNormally);
    });

    group('DCCIUC delete', () {
      test('DCCIUC delete makes correct repository request', () {
        when(() => mockRepository.deleteNotesItem(any()))
            .thenAnswer((_) async => const Right(null));
        final subject = createSubject();
        expect(subject(sampleNotesItemId), completes);
        verify(() => mockRepository.deleteNotesItem(sampleNotesItemId)).called(1);
      });

      test('DCCIUC should delete notesItem (repository)', () async {
        when(() => mockRepository.deleteNotesItem(any()))
          .thenAnswer((_) async => const Right(null));
        final subject = createSubject();
        final result = await subject(sampleNotesItemId);
        expect(result, const Right(null));
        verify(() => mockRepository.deleteNotesItem(sampleNotesItemId));
        verifyNoMoreInteractions(mockRepository);
      });

      test('DCCIUC save should return ServerFailure from the repository if some error occurred', () async {
          when(() => mockRepository.deleteNotesItem(any()))
              .thenAnswer((_) async => const Left(ServerFailure(code: "111")));
          final subject = createSubject();
          final result = await subject(sampleNotesItemId);
          expect(result, const Left(ServerFailure(code: "111")));
          verify(() => mockRepository.deleteNotesItem(sampleNotesItemId));
          verifyNoMoreInteractions(mockRepository);
        },
      );
    });
  });
}
