import 'package:dartz/dartz.dart';

import '../../../common/helper.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';
import '../data/links_model.dart';
import 'links_repository.dart';

class GetLinksUsecase implements UseCase<List<LinksModel>, NoParams> {
  final LinksRepository repository;

  GetLinksUsecase(this.repository);

  @override
  Future<Either<Failure, List<LinksModel>>> call(NoParams params) async {
    itgLogVerbose('[GetLinksUsecase] call...');
    return repository.getLinks();
  }
}
