import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/admin_remote_datasource.dart';
import '../../data/repositories/admin_repository_impl.dart';

import '../../domain/usecases/get_dashboard_stats.dart';

final adminRemoteDatasourceProvider =
    Provider<AdminRemoteDatasource>((ref) {
  return AdminRemoteDatasource();
});

final adminRepositoryProvider =
    Provider<AdminRepositoryImpl>((ref) {
  return AdminRepositoryImpl(
    ref.read(adminRemoteDatasourceProvider),
  );
});

final dashboardUsecaseProvider =
    Provider<GetDashboardStats>((ref) {
  return GetDashboardStats(
    ref.read(adminRepositoryProvider),
  );
});