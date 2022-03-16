import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';
import 'package:dev_framework_tutorial/src/core/usecase/usecase.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/get_notes_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../notes_test_helper.dart';

void main() {
  late MockNotesRepository mockRepository;

  setUp(() {
    mockRepository = MockNotesRepository();
  });

  GetNotesUsecase createSubject() => GetNotesUsecase(mockRepository);

  final tNotes = notesTestData();

  group('GetNotesUsecase', () {
    test('GCCUC constructor works properly', () {
      expect(createSubject, returnsNormally);
    });

    group('GCCUC get', () {
      test('GCCUC get makes correct repository request', () {
        when(() => mockRepository.getNotes())
            .thenAnswer((_) async => Right(tNotes));
        final subject = createSubject();
        expect(subject(NoParams()), completes);
        verify(() => mockRepository.getNotes()).called(1);
      });

      test('GCCUC should get notes from the repository', () async {
        when(() => mockRepository.getNotes())
            .thenAnswer((_) async => Right(tNotes));
        final subject = createSubject();
        final result = await subject(NoParams());
        expect(result, Right(tNotes));
        verify(() => mockRepository.getNotes());
        verifyNoMoreInteractions(mockRepository);
      });

      test('GCCUC should get ServerFailure from the repository if some error occurred', () async {
        when(() => mockRepository.getNotes())
            .thenAnswer((_) async => const Left(ServerFailure(code: "111")));
        final subject = createSubject();
        final result = await subject(NoParams());
        expect(result, const Left(ServerFailure(code: "111")));
        verify(() => mockRepository.getNotes());
        verifyNoMoreInteractions(mockRepository);
      });
    });
  });

}
