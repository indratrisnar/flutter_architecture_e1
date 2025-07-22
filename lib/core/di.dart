import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_architecture_e1/core/platform/network_info.dart';
import 'package:flutter_architecture_e1/data/data_sources/local/session_local_data_source.dart';
import 'package:flutter_architecture_e1/data/data_sources/remote/destination_remote_data_source.dart';
import 'package:flutter_architecture_e1/data/repositories/destination_repository.dart';
import 'package:flutter_architecture_e1/presentation/home/bloc/popular_destination_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  await Hive.initFlutter();

  /// External
  final sessionBox = await Hive.openBox(SessionLocalDataSource.kSessionBoxName);

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(
    () => sessionBox,
    instanceName: SessionLocalDataSource.kSessionBoxName,
  );

  /// Platforms
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  /// Data Sources
  sl.registerLazySingleton<SessionLocalDataSource>(
    () => SessionLocalDataSourceImpl(
      sessionBox: sl(instanceName: SessionLocalDataSource.kSessionBoxName),
    ),
  );
  sl.registerLazySingleton<DestinationRemoteDataSource>(
    () => DestinationRemoteDataSourceImpl(
      client: sl(),
      sessionLocalDataSource: sl(),
    ),
  );

  /// Repositories
  sl.registerLazySingleton<DestinationRepository>(
    () => DestinationRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  /// Cubit/BLoC
  sl.registerFactory(() => PopularDestinationBloc(destinationRepository: sl()));
}
