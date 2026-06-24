import 'package:dio/dio.dart';

class DioClient {
  DioClient._();

  static final DioClient instance = DioClient._();

  final Dio dio = Dio();
}