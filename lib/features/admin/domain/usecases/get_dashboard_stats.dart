import '../repositories/admin_repository.dart';
import '../../data/models/dashboard_stats_model.dart';

class GetDashboardStats {

  final AdminRepository repository;

  GetDashboardStats(this.repository);

  Future<DashboardStatsModel> call() {
    return repository.getDashboardStats();
  }
}