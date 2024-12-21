import 'package:dio/dio.dart';

import '../models/improve_writing_result.dart';

abstract interface class RemoteData {
  Future<ImproveWritingResult> improveWriting(String text);
}

class RemoteDataImpl implements RemoteData {
  final Dio _dio;

  RemoteDataImpl({required Dio dio}) : _dio = dio;

  @override
  Future<ImproveWritingResult> improveWriting(String text) async {
    final response = await _dio.post(
      '/imporve-writing/imporve-writing',
      data: {
        'lang': 'eng',
        'prompt': text,
      },
    );

    return ImproveWritingResult.fromJson(response.data['result']);
  }
}