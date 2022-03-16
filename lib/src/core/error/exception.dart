import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final String? code;
  final String? description;

  const ServerException({this.code, this.description});

  @override
  String toString() {
    if (code != null && description != null){
      return 'ServerException(code: "$code", description: "$description")';
    } else if (code != null){
      return 'ServerException(code: "$code")';
    } else if (description != null){
      return 'ServerException(description: "$description")';
    } else {
      return "ServerException()";
    }
  }

  @override
  List<Object?> get props => [code, description];
}

class CacheException extends Equatable implements Exception {
  final String? code;
  final String? description;

  const CacheException({this.code, this.description});

  @override
  List<Object?> get props => [code, description];
}
