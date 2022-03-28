import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../data/links_model.dart';

abstract class LinksRepository {
  Future<Either<Failure, List<LinksModel>>> getLinks();
  Future<Either<Failure, List<LinksModel>>> searchLinks(String query);
  Future<Either<Failure, LinksModel>> saveLinksItem(LinksModel linksItem);
  Future<Either<Failure, void>> deleteLinksItem(String id);
}
