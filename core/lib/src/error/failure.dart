import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String errorCode;
  final String message;
  const Failure(this.errorCode, this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.errorCode, super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.errorCode, super.message);
}
