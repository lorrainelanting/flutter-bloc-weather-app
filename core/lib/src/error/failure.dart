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

class LocationServiceDisabledFailure extends Failure {
  const LocationServiceDisabledFailure()
      : super('LOCATION_SERVICE_DISABLED', 'Location services are disabled');
}

class LocationPermissionDeniedFailure extends Failure {
  const LocationPermissionDeniedFailure()
      : super('LOCATION_PERMISSION_DENIED', 'Location permission was denied');
}
