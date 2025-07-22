import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class NoConnectionFailure extends Failure {
  const NoConnectionFailure({required super.message});
}

class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure({required super.message});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message});
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure({required super.message});
}

class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure({required super.message});
}

class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}
