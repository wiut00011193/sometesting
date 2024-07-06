import 'package:dio/dio.dart';
import '../utils/constants.dart';

class BaseApi {
  final _dio = Dio(
    BaseOptions(
      baseUrl: EndPoints.base_url,
      validateStatus: (status) => true,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Dio get dio => _dio;
}
