import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/data_sources/remote_data.dart';
import '../data/repositories/polisher_repository.dart';
import 'dio/app_dio.dart';

class DI {
  static DI? _instance;

  DI._();

  factory DI() {
    _instance ??= DI._();
    return _instance!;
  }

  final sl = GetIt.instance;

  Future<void> init() async {
    sl.registerLazySingleton<PolisherRepository>(
      () => PolisherRepositoryImpl(
        remoteData: sl(),
      ),
    );

    sl.registerLazySingleton<RemoteData>(
      () => RemoteDataImpl(
        dio: sl(),
      ),
    );

    sl.registerLazySingleton<Dio>(
      () => WritingTutorDio(
        connectivity: Connectivity(),
      ).dio,
    );
  }
}
