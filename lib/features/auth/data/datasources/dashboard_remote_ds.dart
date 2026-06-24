import 'package:dio/dio.dart';
import '../../../../core/network/api_service.dart';

class DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSource(this.dio);

  Future<String> getDashboardTitle() async {
    final response = await dio.get(ApiEndpoints.dashboard);

    return response.data["title"];
  }
}