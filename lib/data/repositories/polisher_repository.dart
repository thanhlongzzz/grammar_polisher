import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/failure.dart';
import '../data_sources/remote_data.dart';
import '../models/improve_writing_result.dart';

abstract interface class PolisherRepository {
  Future<Either<Failure, ImproveWritingResult>> polish(String text);
}

class PolisherRepositoryImpl implements PolisherRepository {
  final RemoteData _remoteData;

  PolisherRepositoryImpl({required RemoteData remoteData}) : _remoteData = remoteData;

  @override
  Future<Either<Failure, ImproveWritingResult>> polish(String text) async {
    try {
      final result = await _remoteData.improveWriting(text);
      return Right(result);
    } on DioException catch (e) {
      return Left(Failure(message: e.message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(Failure());
    }
  }
}