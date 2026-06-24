import 'package:dio/dio.dart';

class DioClient {
  DioClient._internal()
      : dio = Dio(
          BaseOptions(
            baseUrl: "https://jsonplaceholder.typicode.com/",
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              "Content-Type": "application/json",
            },
          ),
        ) {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  static final DioClient instance = DioClient._internal();

  final Dio dio;
}