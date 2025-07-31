import 'package:fpdart/fpdart.dart';
import 'package:flutter_architecture_e1/core/errors/exceptions.dart';
import 'package:flutter_architecture_e1/core/errors/failures.dart';
import 'package:flutter_architecture_e1/core/platform/network_info.dart';
import 'package:flutter_architecture_e1/data/data_sources/local/session_local_data_source.dart';
import 'package:flutter_architecture_e1/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:flutter_architecture_e1/data/models/token_model.dart';
import 'package:flutter_architecture_e1/data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, (UserModel, TokenModel)>> login(
    String email,
    String password,
  );
  Future<Either<Failure, UserModel>> register(
    String name,
    String email,
    String password,
  );
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, (UserModel, TokenModel)>> getCachedAuthData();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SessionLocalDataSource _sessionLocalDataSource;
  final NetworkInfo _networkInfo;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SessionLocalDataSource sessionLocalDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _sessionLocalDataSource = sessionLocalDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, (UserModel, TokenModel)>> login(
    String email,
    String password,
  ) async {
    final connected = await _networkInfo.isConnected();
    if (!connected) {
      return const Left(
        NoConnectionFailure(
          message: 'No internet connection. Please check your network.',
        ),
      );
    }

    try {
      final (user, token) = await _remoteDataSource.login(email, password);
      await _sessionLocalDataSource.cacheUserData(user);
      await _sessionLocalDataSource.cacheAuthToken(token);
      return Right((user, token));
    } on NetworkException {
      return const Left(
        NetworkFailure(
          message: 'Failed to connect to the server. Please try again.',
        ),
      );
    } on UnauthenticatedException {
      return const Left(
        UnauthenticatedFailure(
          message: 'Invalid email or password. Please try again.',
        ),
      );
    } on BadRequestException {
      return const Left(
        InvalidInputFailure(
          message: 'Invalid credentials. Please check your email and password.',
        ),
      );
    } on ServerException {
      return const Left(
        ServerFailure(message: 'Server error. Please try again later.'),
      );
    } on DataParsingException {
      return const Left(
        UnexpectedFailure(message: 'Failed to process data from the server.'),
      );
    } on CacheException {
      return const Left(
        CacheFailure(message: 'Failed to save login data locally.'),
      );
    } catch (_) {
      return const Left(
        UnexpectedFailure(
          message:
              'An unexpected error occurred during login. Please try again later.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserModel>> register(
    String name,
    String email,
    String password,
  ) async {
    final connected = await _networkInfo.isConnected();
    if (!connected) {
      return const Left(
        NoConnectionFailure(
          message: 'No internet connection. Please check your network.',
        ),
      );
    }

    try {
      final user = await _remoteDataSource.register(name, email, password);
      return Right(user);
    } on NetworkException {
      return const Left(
        NetworkFailure(
          message: 'Failed to connect to the server. Please try again.',
        ),
      );
    } on UnauthenticatedException {
      return const Left(
        UnauthenticatedFailure(
          message: 'Registration failed. Please check your input.',
        ),
      );
    } on BadRequestException {
      return const Left(
        InvalidInputFailure(
          message: 'Invalid registration data. Please check your input.',
        ),
      );
    } on ConflictException {
      return const Left(
        ServerFailure(message: 'The email you provided is already registered.'),
      );
    } on ServerException {
      return const Left(
        ServerFailure(message: 'Server error. Please try again later.'),
      );
    } on DataParsingException {
      return const Left(
        UnexpectedFailure(message: 'Failed to process data from the server.'),
      );
    } on CacheException {
      return const Left(
        CacheFailure(message: 'Failed to save registration data locally.'),
      );
    } catch (_) {
      return const Left(
        UnexpectedFailure(
          message:
              'An unexpected error occurred during registration. Please try again later.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _sessionLocalDataSource.clearSession();
      return const Right(null);
    } on CacheException {
      return const Left(
        CacheFailure(message: 'Failed to clear local session data.'),
      );
    } catch (_) {
      return const Left(
        UnexpectedFailure(
          message: 'An unexpected error occurred during logout.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, (UserModel, TokenModel)>> getCachedAuthData() async {
    try {
      final user = await _sessionLocalDataSource.getUserData();
      final token = await _sessionLocalDataSource.getAuthToken();

      if (user != null && token != null) {
        return Right((user, token));
      }

      return const Left(
        UnauthenticatedFailure(message: 'No cached authentication data found.'),
      );
    } on CacheException {
      return const Left(
        CacheFailure(message: 'Failed to retrieve cached authentication data.'),
      );
    } on DataParsingException {
      return const Left(
        UnexpectedFailure(message: 'Corrupted cached authentication data.'),
      );
    } catch (_) {
      return const Left(
        UnexpectedFailure(
          message:
              'An unexpected error occurred while checking cached authentication.',
        ),
      );
    }
  }
}
