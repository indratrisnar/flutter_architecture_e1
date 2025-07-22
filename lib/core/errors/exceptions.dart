abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  const AppException({required this.message, this.statusCode, this.error});

  @override
  String toString() {
    final typeName = runtimeType.toString();
    return '$typeName${statusCode != null ? ' [$statusCode]' : ''}: $message';
  }
}

class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.error,
  });
}

class CacheException extends AppException {
  const CacheException({required super.message, super.error});
}

class NetworkException extends AppException {
  const NetworkException({required super.message, super.error});
}

class UnauthenticatedException extends AppException {
  const UnauthenticatedException({
    required super.message,
    super.statusCode = 401,
    super.error,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    required super.message,
    super.statusCode = 404,
    super.error,
  });
}

class BadRequestException extends AppException {
  const BadRequestException({
    required super.message,
    super.statusCode = 400,
    super.error,
  });
}

class ConflictException extends AppException {
  const ConflictException({
    required super.message,
    super.statusCode = 409,
    super.error,
  });
}

class DataParsingException extends AppException {
  const DataParsingException({required super.message, super.error});
}
