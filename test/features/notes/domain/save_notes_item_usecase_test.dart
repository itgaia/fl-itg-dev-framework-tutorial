import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/save_notes_item_usecase.dart';
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

  SaveNotesItemUsecase createSubject() => SaveNotesItemUsecase(mockRepository);

  final NotesModel tData = notesTestData().first;

  group('SaveNotesItemUsecase', () {
    test('SCCIUC constructor works properly', () {
      expect(createSubject, returnsNormally);
    });

    group('SCCIUC save', () {
      test('SCCIUC save makes correct repository request', () {
        const newItem = NotesModel(
          id: '4',
          description: 'description 4',
          content: 'content 4',
        );
        when(() => mockRepository.saveNotesItem(any()))
            .thenAnswer((_) async => Right(tData));
        final subject = createSubject();
        expect(subject(newItem), completes);
        verify(() => mockRepository.saveNotesItem(newItem)).called(1);
      });

      test('SCCIUC should save notesItem (repository)', () async {
        when(() => mockRepository.saveNotesItem(any()))
          .thenAnswer((_) async => Right(tData));
        final subject = createSubject();
        final result = await subject(tData);
        expect(result, Right(tData));
        verify(() => mockRepository.saveNotesItem(tData));
        verifyNoMoreInteractions(mockRepository);
      });

      test('SCCIUC save should return ServerFailure from the repository if some error occurred', () async {
        when(() => mockRepository.saveNotesItem(any()))
            .thenAnswer((_) async => const Left(ServerFailure(code: "111")));
        final subject = createSubject();
        final result = await subject(tData);
        expect(result, const Left(ServerFailure(code: "111")));
        verify(() => mockRepository.saveNotesItem(tData));
        verifyNoMoreInteractions(mockRepository);
      });
    });
  });
}
