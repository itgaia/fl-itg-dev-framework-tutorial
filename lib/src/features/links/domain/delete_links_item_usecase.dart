import 'package:dartz/dartz.dart';

import '../../../common/helper.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import 'links_repository.dart';

class DeleteLinksItemUsecase implements UseCase<void, String> {
  final LinksRepository repository;

  DeleteLinksItemUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    itgLogVerbose('DeleteLinksItemUsecase - call - id: $id');
    return repository.deleteLinksItem(id);
  }
}
