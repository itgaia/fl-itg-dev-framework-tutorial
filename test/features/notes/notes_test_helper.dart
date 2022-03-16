import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:dev_framework_tutorial/src/app/injection_container.dart';
import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/core/error/failures.dart';
import 'package:dev_framework_tutorial/src/core/usecase/usecase.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_local_datasource.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_remote_datasource.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/delete_notes_item_usecase.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/get_notes_usecase.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/notes_repository.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/notes_support.dart';
import 'package:dev_framework_tutorial/src/features/notes/domain/save_notes_item_usecase.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/add_edit/bloc/notes_item_add_edit_bloc.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/bloc/notes_bloc.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../common/test_helper.dart';
import '../../fixtures/fixture_helper.dart';

class MockGetNotesUsecase extends Mock implements GetNotesUsecase {}
class MockSaveNotesItemUsecase extends Mock implements SaveNotesItemUsecase {}
class MockDeleteNotesItemUsecase extends Mock implements DeleteNotesItemUsecase {}
class MockNotesRepository extends Mock implements NotesRepository {}
class MockNotesRemoteDataSource extends Mock implements NotesRemoteDataSource {}
class MockNotesLocalDataSource extends Mock implements NotesLocalDataSource {}
class MockNotesSupport extends Mock implements NotesSupport {}

class MockNotesBloc extends MockBloc<NotesEvent, NotesState> implements NotesBloc {}
class FakeNotesState extends Fake implements NotesState {}
class FakeNotesEvent extends Fake implements NotesEvent {}

class MockNotesItemAddEditBloc extends MockBloc<NotesItemAddEditEvent, NotesItemAddEditState> implements NotesItemAddEditBloc {}
class FakeNotesItemAddEditState extends Fake implements NotesItemAddEditState {}
class FakeNotesItemAddEditEvent extends Fake implements NotesItemAddEditEvent {}

class FakeNotesItem extends Fake implements NotesModel {}

const String sampleNotesItemId = '61011f6d4558ebe4f88acccc';
const sampleNotesItemAddData = NotesModel(
    description: 'description-sample', content: 'sample content');
const sampleNotesItemAddDataExpected = NotesModel(
    id: sampleNotesItemId, description: 'description-sample', content: 'sample content', createdAt: "2021-01-01T21:21:21.21Z", updatedAt: "2021-01-01T21:21:21.21Z");

List<NotesModel> notesTestData({int count = 5}) => List.generate(
  count,
  (i) => NotesModel(id: '${i+1}', description: 'test description ${i+1}', content: 'test content ${i+1}')
);

List<Map<String, dynamic>> notesTestMapData({int count = 5}) => List.generate(
  count,
  // (i) => {'_id': '${i+1}', 'description': 'test description ${i+1}', 'content': 'test content ${i+1}'}
  (i) => {'id': '${i+1}', 'description': 'test description ${i+1}', 'content': 'test content ${i+1}'}
);

// "_id":{"$oid":"61011f6d4558ebe4f88acccc"}
List<Map<String, dynamic>> notesMongoTestMapData({int count = 5}) => List.generate(
  count,
  (i) => {'_id': {r"$oid": r"61011f6d4558ebe4f88acccc"}, 'description': 'test description ${i+1}', 'content': 'test content ${i+1}'}
);

void arrangeReturnsNNotes(mockGetNotesUsecase, {int count = 5}) {
  itgLogVerbose('before when....');
  when(() => mockGetNotesUsecase.call(any())).thenAnswer((_) async {
    itgLogVerbose('arrangeReturnsNNotes........');
    await Task(() => Future.value(notesTestData(count: count)))
        .attempt()
        .mapLeftToFailure()
        .map((either) =>
        either.map((data) => data as List<NotesModel>))
        .run();
  });
  itgLogVerbose('after when....');
}

void arrangeReturnsNNotesAfterNSecondsWait(
    mockGetNotesUsecase,
    {int count = 5, Duration wait = const Duration(seconds: 2)}) {
  when(() => mockGetNotesUsecase(NoParams())).thenAnswer((_) async {
    itgLogVerbose('>>> arrangeReturnsNNotesAfterNSecondsWait - count: $count, wait: $wait - start...');
    await Future.delayed(wait);
    itgLogVerbose('>>> arrangeReturnsNNotesAfterNSecondsWait - count: $count, wait: $wait - end...');
    // return Right(notesTestData(count: count));
    return await Task(() => Future.value(notesTestData(count: count)))
        .attempt()
        .mapLeftToFailure()
        .map((either) => either.map((data) => data as List<NotesModel>))
        .run();
  });
}

void arrangeNotesUsecaseReturnException(
    mockGetNotesUsecase, {Duration wait = const Duration(seconds: 0)}) {
  when(() => mockGetNotesUsecase(any()))
      .thenAnswer((_) async => const Left(ServerFailure(code: '111')));
  // when(() => mockGetNotesUsecase(NoParams())).thenAnswer((_) async {
  //     itgLogVerbose('>>> arrangeNotesUsecaseReturnException - wait: $wait - start...');
  //     await Future.delayed(wait);
  //     // return const Left(ServerFailure(description: textSampleException));
  //     // return await Task(() => Future.value([]) as Future<List<NotesModel>>)
  //     return await Task(() => Future.value([]))
  //       .attempt()
  //       .mapLeftToFailure()
  //       // .map((either) => either.map((data) => data as List<NotesModel>))
  //       .run();
  // });
}

void arrangeNotesItemDeleteUsecaseReturnSuccess() {
  if (sl.isRegistered<DeleteNotesItemUsecase>()) {
    sl.unregister<DeleteNotesItemUsecase>();
  }
  sl.registerLazySingleton<DeleteNotesItemUsecase>(() => MockDeleteNotesItemUsecase());
  when(() => sl<DeleteNotesItemUsecase>()(any()))
      .thenAnswer((_) async => const Right(null));
}

void setUpHttpClientGetNotesSuccess200({String url = urlNotes}) {
  arrangeHttpClientGetReturnSuccess200(url: url, response: fixture('notes_response_fixture.json'));
}


void setUpHttpClientCreateNotesItemSuccess200({String url = urlNotes, NotesModel data = sampleNotesItemAddData}) {
  arrangeHttpClientPostReturnSuccess200(url: url, response: fixture('notes_item_create_response_fixture.json'));
}

void setUpHttpClientUpdateNotesItemSuccess204({String url = '$urlNotes/$sampleNotesItemId', NotesModel data = sampleNotesItemAddData}) {
  arrangeHttpClientPutReturnSuccess204(url: url, response: '');
}

void setUpHttpClientDeleteNotesItemSuccess204({String url = urlNotes, String id = sampleNotesItemId}) {
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