import 'package:flutter_architecture_e1/core/errors/exceptions.dart';
import 'package:flutter_architecture_e1/core/errors/failures.dart';
import 'package:flutter_architecture_e1/core/platform/network_info.dart';
import 'package:flutter_architecture_e1/data/data_sources/remote/destination_remote_data_source.dart';
import 'package:flutter_architecture_e1/data/models/destination_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class DestinationRepository {
  Future<Either<Failure, List<DestinationModel>>> fetchPopular();
  Future<Either<Failure, List<DestinationModel>>> fetchNearby(
    double latitude,
    double longitude,
    double radius,
  );
  Future<Either<Failure, DestinationModel>> findById(int id);
}

class DestinationRepositoryImpl implements DestinationRepository {
  final DestinationRemoteDataSource _destinationRemoteDataSource;
  final NetworkInfo _networkInfo;

  const DestinationRepositoryImpl({
    required DestinationRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _networkInfo = networkInfo,
       _destinationRemoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<DestinationModel>>> fetchPopular() async {
    try {
      final connected = await _networkInfo.isConnected();
      if (!connected) {
        return const Left(
          NoConnectionFailure(message: 'You are not connected to the network.'),
        );
      }

      final destinations = await _destinationRemoteDataSource.fetchPopular();
      return Right(destinations);
    } on NetworkException {
      return const Left(
        NetworkFailure(message: 'Failed to connect to the network'),
      );
    } on UnauthenticatedException {
      return const Left(UnauthenticatedFailure(message: ''));
    } on ServerException {
      return const Left(
        ServerFailure(message: 'Server error. Please try again'),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'An unknown error occurred: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<DestinationModel>>> fetchNearby(
    double latitude,
    double longitude,
    double radius,
  ) async {
    try {
      final connected = await _networkInfo.isConnected();
      if (!connected) {
        return const Left(
          NoConnectionFailure(message: 'You are not connected to the network.'),
        );
      }

      final destinations = await _destinationRemoteDataSource.fetchNearby(
        latitude,
        longitude,
        radius,
      );
      return Right(destinations);
    } on NetworkException {
      return const Left(
        NetworkFailure(message: 'Failed to connect to the network'),
      );
    } on UnauthenticatedException {
      return const Left(UnauthenticatedFailure(message: ''));
    } on ServerException {
      return const Left(
        ServerFailure(message: 'Server error. Please try again'),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'An unknown error occurred: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, DestinationModel>> findById(int id) async {
    try {
      final connected = await _networkInfo.isConnected();
      if (!connected) {
        return const Left(
          NoConnectionFailure(message: 'You are not connected to the network.'),
        );
      }

      final destinations = await _destinationRemoteDataSource.findById(id);
      return Right(destinations);
    } on NetworkException {
      return const Left(
        NetworkFailure(message: 'Failed to connect to the network'),
      );
    } on UnauthenticatedException {
      return const Left(UnauthenticatedFailure(message: ''));
    } on NotFoundException {
      return const Left(NotFoundFailure(message: 'No Destination Found'));
    } on ServerException {
      return const Left(
        ServerFailure(message: 'Server error. Please try again'),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'An unknown error occurred: ${e.toString()}',
        ),
      );
    }
  }
}
