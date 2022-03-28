import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';
import 'package:dev_framework_tutorial/src/core/usecase/usecase.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/get_links_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../links_test_helper.dart';

void main() {
  late MockLinksRepository mockRepository;

  setUp(() {
    mockRepository = MockLinksRepository();
  });

  GetLinksUsecase createSubject() => GetLinksUsecase(mockRepository);

  final tLinks = linksTestData();

  group('GetLinksUsecase', () {
    test('GCCUC constructor works properly', () {
      expect(createSubject, returnsNormally);
    });

    group('GCCUC get', () {
      test('GCCUC get makes correct repository request', () {
        when(() => mockRepository.getLinks())
            .thenAnswer((_) async => Right(tLinks));
        final subject = createSubject();
        expect(subject(NoParams()), completes);
        verify(() => mockRepository.getLinks()).called(1);
      });

      test('GCCUC should get links from the repository', () async {
        when(() => mockRepository.getLinks())
            .thenAnswer((_) async => Right(tLinks));
        final subject = createSubject();
        final result = await subject(NoParams());
        expect(result, Right(tLinks));
        verify(() => mockRepository.getLinks());
        verifyNoMoreInteractions(mockRepository);
      });

      test('GCCUC should get ServerFailure from the repository if some error occurred', () async {
        when(() => mockRepository.getLinks())
            .thenAnswer((_) async => const Left(ServerFailure(code: "111")));
        final subject = createSubject();
        final result = await subject(NoParams());
        expect(result, const Left(ServerFailure(code: "111")));
        verify(() => mockRepository.getLinks());
        verifyNoMoreInteractions(mockRepository);
      });
    });
  });

}
