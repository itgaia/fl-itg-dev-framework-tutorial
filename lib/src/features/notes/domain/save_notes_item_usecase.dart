import 'package:dartz/dartz.dart';

import '../../../common/helper.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../data/notes_model.dart';
import 'notes_repository.dart';

class SaveNotesItemUsecase implements UseCase<NotesModel, NotesModel> {
  final NotesRepository repository;

  SaveNotesItemUsecase(this.repository);

  @override
  Future<Either<Failure, NotesModel>> call(NotesModel note) async {
    itgLogVerbose('SaveNotesItemUsecase - call...');
    return repository.saveNotesItem(note);
  }
}
