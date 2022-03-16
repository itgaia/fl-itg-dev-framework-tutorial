import 'package:dartz/dartz.dart';

import '../../../common/helper.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import 'notes_repository.dart';

class DeleteNotesItemUsecase implements UseCase<void, String> {
  final NotesRepository repository;

  DeleteNotesItemUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    itgLogVerbose('DeleteNotesItemUsecase - call - id: $id');
    return repository.deleteNotesItem(id);
  }
}
