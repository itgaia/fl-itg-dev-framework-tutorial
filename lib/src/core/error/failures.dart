import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? code;
  final String? description;

  const Failure({this.code, this.description});

  @override
  String toString() {
    if (code != null && description != null){
      return 'Failure(code: "$code", description: "$description")';
    } else if (code != null){
      return 'Failure(code: "$code")';
    } else if (description != null){
      return 'Failure(description: "$description")';
    } else {
      return "Failure()";
    }
  }

  @override
  List<Object?> get props => [code, description];
}

// General failures
class ServerFailure extends Failure {
  @override
  final String? code;
  @override
  final String? description;

  const ServerFailure({this.code, this.description}): super(code: code, description: description);

  @override
  String toString() => super.toString().replaceAll('Failure', 'ServerFailure');

  @override
  List<Object?> get props => [code, description];
}

class CacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}
