import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../data/notes_model.dart';

abstract class NotesRepository {
  Future<Either<Failure, List<NotesModel>>> getNotes();
  Future<Either<Failure, List<NotesModel>>> searchNotes(String query);
  Future<Either<Failure, NotesModel>> saveNotesItem(NotesModel notesItem);
  Future<Either<Failure, void>> deleteNotesItem(String id);
}
