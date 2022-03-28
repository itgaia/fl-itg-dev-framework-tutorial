import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';
import 'package:dev_framework_tutorial/src/core/usecase/usecase.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_local_datasource.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_model.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_remote_datasource.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/delete_links_item_usecase.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/get_links_usecase.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/links_helper.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/links_repository.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/links_support.dart';
import 'package:dev_framework_tutorial/src/features/links/domain/save_links_item_usecase.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/add_edit/bloc/links_item_add_edit_bloc.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/bloc/links_bloc.dart';
import 'package:dev_framework_tutorial/src/features/links/presentation/main/links_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../common/test_helper.dart';
import '../../fixtures/fixture_helper.dart';

class MockGetLinksUsecase extends Mock implements GetLinksUsecase {}
class MockSaveLinksItemUsecase extends Mock implements SaveLinksItemUsecase {}
class MockDeleteLinksItemUsecase extends Mock implements DeleteLinksItemUsecase {}
class MockLinksRepository extends Mock implements LinksRepository {}
class MockLinksRemoteDataSource extends Mock implements LinksRemoteDataSource {}
class MockLinksLocalDataSource extends Mock implements LinksLocalDataSource {}
class MockLinksSupport extends Mock implements LinksSupport {}

class MockLinksBloc extends MockBloc<LinksEvent, LinksState> implements LinksBloc {}
class FakeLinksState extends Fake implements LinksState {}
class FakeLinksEvent extends Fake implements LinksEvent {}

class MockLinksItemAddEditBloc extends MockBloc<LinksItemAddEditEvent, LinksItemAddEditState> implements LinksItemAddEditBloc {}
class FakeLinksItemAddEditState extends Fake implements LinksItemAddEditState {}
class FakeLinksItemAddEditEvent extends Fake implements LinksItemAddEditEvent {}

class FakeLinksItem extends Fake implements LinksModel {}

linksRegisterFallbackValue() => registerFallbackValue(const LinksModel(description: '111'));

const mockLinksItem = LinksModel(
  id: '1',
  description: 'description 1',
  notes: 'notes 1',
  updatedAt: '2021-09-22T07:06:52.604Z'
);
const mockLinksItems = [mockLinksItem];

const String sampleLinksItemId = r'61011f6d4558ebe4f88acccc';
const itemLinksAddTestData = LinksModel(
    description: 'description-sample', notes: 'notes-sample');
final itemLinksUpdateTestData = itemLinksAddTestData.copyWith(id: '111');
const itemLinksAddTestDataExpected = LinksModel(
    id: sampleLinksItemId, description: 'description-sample', notes: 'notes-sample', createdAt: "2021-01-01T21:21:21.21Z", updatedAt: "2021-01-01T21:21:21.21Z");

const sampleLinksData = '''[
  {
    "_id": {"\$oid":"61011f6d4558ebe4f88abc1"},
    "description": "test description 1", 
    "notes": "test notes 1", 
  },
  {
    "_id": {"\$oid":"61011f6d4558ebe4f88abc2"},
    "description": "test description 2", 
    "notes": "test notes 2", 
  },
  {
    "_id": {"\$oid":"61011f6d4558ebe4f88abc3"},
    "description": "test description 3", 
    "notes": "test notes 3", 
  }
]''';


List<LinksModel> linksTestData({int count = 5}) => List.generate(
  count,
  (i) => LinksModel(id: '${i+1}', description: 'test description ${i+1}', notes: 'test notes ${i+1}')
);

List<Map<String, dynamic>> linksTestMapData({int count = 5}) => List.generate(
  count,
  (i) => {'id': '${i+1}', 'description': 'test description ${i+1}', 'notes': 'test notes ${i+1}'}
);

List<Map<String, dynamic>> linksMongoTestMapData({int count = 5}) => List.generate(
  count,
  (i) => {'_id': {r"$oid": r"61011f6d4558ebe4f88acccc"}, 'description': 'test description ${i+1}', 'notes': 'test notes ${i+1}'}
);

extension LinksAddedFunctionality on WidgetTester {
  Future<void> pumpLinksList(LinksBloc bloc) async {
    itgLogVerbose('WidgetTester.pumpLinksList - start...');
    return pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          // child: const LinksList(),
          child: const LinksView(),
        ),
      ),
    );
  }
}

void arrangeReturnsNLinks(mockGetLinksUsecase, {int count = 5}) {
  itgLogVerbose('before when....');
  when(() => mockGetLinksUsecase.call(any())).thenAnswer((_) async {
    itgLogVerbose('arrangeReturnsNLinks........');
    await Task(() => Future.value(linksTestData(count: count)))
        .attempt()
        .mapLeftToFailure()
        .map((either) =>
        either.map((data) => data as List<LinksModel>))
        .run();
  });
  itgLogVerbose('after when....');
}

void arrangeReturnsNLinksAfterNSecondsWait(
    mockGetLinksUsecase,
    {int count = 5, Duration wait = const Duration(seconds: 2)}) {
  when(() => mockGetLinksUsecase(NoParams())).thenAnswer((_) async {
    itgLogVerbose('>>> arrangeReturnsNLinksAfterNSecondsWait - count: $count, wait: $wait - start...');
    await Future.delayed(wait);
    itgLogVerbose('>>> arrangeReturnsNLinksAfterNSecondsWait - count: $count, wait: $wait - end...');
    // return Right(linksTestData(count: count));
    return await Task(() => Future.value(linksTestData(count: count)))
        .attempt()
        .mapLeftToFailure()
        .map((either) => either.map((data) => data as List<LinksModel>))
        .run();
  });
}

void arrangeLinksUsecaseReturnException(
    mockGetLinksUsecase, {Duration wait = const Duration(seconds: 0)}) {
  when(() => mockGetLinksUsecase(any()))
      .thenAnswer((_) async => const Left(ServerFailure(code: '111')));
  // when(() => mockGetLinksUsecase(NoParams())).thenAnswer((_) async {
  //     itgLogVerbose('>>> arrangeLinksUsecaseReturnException - wait: $wait - start...');
  //     await Future.delayed(wait);
  //     // return const Left(ServerFailure(description: textSampleException));
  //     // return await Task(() => Future.value([]) as Future<List<LinksModel>>)
  //     return await Task(() => Future.value([]))
  //       .attempt()
  //       .mapLeftToFailure()
  //       // .map((either) => either.map((data) => data as List<LinksModel>))
  //       .run();
  // });
}

void arrangeLinksItemDeleteUsecaseReturnSuccess() {
  if (sl.isRegistered<DeleteLinksItemUsecase>()) {
    sl.unregister<DeleteLinksItemUsecase>();
  }
  sl.registerLazySingleton<DeleteLinksItemUsecase>(() => MockDeleteLinksItemUsecase());
  when(() => sl<DeleteLinksItemUsecase>()(any()))
      .thenAnswer((_) async => const Right(null));
}

void setUpHttpClientGetLinksSuccess200({String url = urlLinks}) {
  arrangeHttpClientGetReturnSuccess200(url: url, response: fixture('links_response_fixture.json'));
}


void setUpHttpClientCreateLinksItemSuccess200({String url = urlLinks, LinksModel data = itemLinksAddTestData}) {
  arrangeHttpClientPostReturnSuccess200(url: url, response: fixture('links_item_create_response_fixture.json'));
}

void setUpHttpClientUpdateLinksItemSuccess204({String url = '$urlLinks/$sampleLinksItemId', LinksModel data = itemLinksAddTestData}) {
  arrangeHttpClientPutReturnSuccess204(url: url, response: '');
}

void setUpHttpClientDeleteLinksItemSuccess204({String url = urlLinks, String id = sampleLinksItemId}) {
  arrangeHttpClientDeleteReturnSuccess204(url: url, response: '');
}

extension TaskX<T extends Either<Object, U>, U> on Task<T> {
  Task<Either<Failure, U>> mapLeftToFailure() {
    return map((either) => either.leftMap((obj) {
      try {
        return obj as Failure;
      } catch (e) {
        throw obj;
      }
    }));
  }

// Task<Either<Failure, U>> mapRightToList() {
//   return map((either) => either.Map((obj) {
//     try {
//       return obj as Failure;
//     } catch (e) {
//       throw obj;
//     }
//   }));
// }
}

/// Values must be different than the ones in sampleLinksItemAddEditState
const sampleLinksItemInitialData = LinksModel(
  id: '1',
  description: 'description 1',
  notes: 'notes 1',
);

const sampleLinksItemAddEditStateObjectList = <Object?>[
  LinksItemAddEditStatus.initial,
  sampleLinksItemInitialData,
  '',
  'description',
  'notes',
];

/// Values must be different than the ones in sampleLinksItemInitialData
LinksItemAddEditState sampleLinksItemAddEditState({
  LinksItemAddEditStatus status = LinksItemAddEditStatus.initial,
  LinksModel? initialData
}) {
  return LinksItemAddEditState(
    status: status,
    initialData: initialData,
    description: 'description',
    notes: 'notes',
  );
}
