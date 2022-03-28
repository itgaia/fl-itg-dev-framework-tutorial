import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_model.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/save_links_item_usecase.dart';
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

  SaveLinksItemUsecase createSubject() => SaveLinksItemUsecase(mockRepository);

  final LinksModel tData = linksTestData().first;

  group('SaveLinksItemUsecase', () {
    test('SLNIUC constructor works properly', () {
      expect(createSubject, returnsNormally);
    });

    group('SLNIUC save', () {
      test('SLNIUC save makes correct repository request', () {
        final newItem = itemLinksUpdateTestData;
        when(() => mockRepository.saveLinksItem(any()))
            .thenAnswer((_) async => Right(tData));
        final subject = createSubject();
        expect(subject(newItem), completes);
        verify(() => mockRepository.saveLinksItem(newItem)).called(1);
      });

      test('SLNIUC should save linksItem (repository)', () async {
        when(() => mockRepository.saveLinksItem(any()))
          .thenAnswer((_) async => Right(tData));
        final subject = createSubject();
        final result = await subject(tData);
        expect(result, Right(tData));
        verify(() => mockRepository.saveLinksItem(tData));
        verifyNoMoreInteractions(mockRepository);
      });

      test('SLNIUC save should return ServerFailure from the repository if some error occurred', () async {
        when(() => mockRepository.saveLinksItem(any()))
            .thenAnswer((_) async => const Left(ServerFailure(code: "111")));
        final subject = createSubject();
        final result = await subject(tData);
        expect(result, const Left(ServerFailure(code: "111")));
        verify(() => mockRepository.saveLinksItem(tData));
        verifyNoMoreInteractions(mockRepository);
      });
    });
  });
}
