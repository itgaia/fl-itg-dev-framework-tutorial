import 'package:dartz/dartz.dart';

import '../../../common/helper.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../data/links_model.dart';
import 'links_repository.dart';

class SaveLinksItemUsecase implements UseCase<LinksModel, LinksModel> {
  final LinksRepository repository;

  SaveLinksItemUsecase(this.repository);

  @override
  Future<Either<Failure, LinksModel>> call(LinksModel link) async {
    itgLogVerbose('SaveLinksItemUsecase - call...');
    return repository.saveLinksItem(link);
  }
}
