import 'package:dartz/dartz.dart';

import '../../../common/helper.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../data/notes_model.dart';
import 'notes_repository.dart';

class GetNotesUsecase implements UseCase<List<NotesModel>, NoParams> {
  final NotesRepository repository;

  GetNotesUsecase(this.repository);

  @override
  Future<Either<Failure, List<NotesModel>>> call(NoParams params) async {
    itgLogVerbose('[GetNotesUsecase] call...');
    return repository.getNotes();
  }
}
