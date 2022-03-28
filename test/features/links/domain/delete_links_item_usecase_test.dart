import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/delete_links_item_usecase.dart';
import 'package:mockingjay/mockingjay.dart';

import '../links_test_helper.dart';

void main() {
  late MockLinksRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeLinksItem());
  });

  setUp(() {
    mockRepository = MockLinksRepository();
  });

  DeleteLinksItemUsecase createSubject() => DeleteLinksItemUsecase(mockRepository);

  group('DeleteLinksItemUsecase', () {
    test('DLNIUC constructor works properly', () {
      expect(createSubject, returnsNormally);
    });

    group('DLNIUC delete', () {
      test('DLNIUC delete makes correct repository request', () {
        when(() => mockRepository.deleteLinksItem(any()))
            .thenAnswer((_) async => const Right(null));
        final subject = createSubject();
        expect(subject(sampleLinksItemId), completes);
        verify(() => mockRepository.deleteLinksItem(sampleLinksItemId)).called(1);
      });

      test('DLNIUC should delete linksItem (repository)', () async {
        when(() => mockRepository.deleteLinksItem(any()))
          .thenAnswer((_) async => const Right(null));
        final subject = createSubject();
        final result = await subject(sampleLinksItemId);
        expect(result, const Right(null));
        verify(() => mockRepository.deleteLinksItem(sampleLinksItemId));
        verifyNoMoreInteractions(mockRepository);
      });

      test('DLNIUC save should return ServerFailure from the repository if some error occurred', () async {
          when(() => mockRepository.deleteLinksItem(any()))
              .thenAnswer((_) async => const Left(ServerFailure(code: "111")));
          final subject = createSubject();
          final result = await subject(sampleLinksItemId);
          expect(result, const Left(ServerFailure(code: "111")));
          verify(() => mockRepository.deleteLinksItem(sampleLinksItemId));
          verifyNoMoreInteractions(mockRepository);
        },
      );
    });
  });
}
