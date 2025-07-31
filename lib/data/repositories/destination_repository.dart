import 'package:flutter_architecture_e1/core/errors/exceptions.dart';
import 'package:flutter_architecture_e1/core/errors/failures.dart';
import 'package:flutter_architecture_e1/core/platform/network_info.dart';
import 'package:flutter_architecture_e1/data/data_sources/remote/destination_remote_data_source.dart';
import 'package:flutter_architecture_e1/data/models/destination_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class DestinationRepository {
  Future<Either<Failure, List<DestinationModel>>> fetchPopular();
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
      return const Left(
        UnauthenticatedFailure(
          message: 'You are not authenticated. Please log in again.',
        ),
      );
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
