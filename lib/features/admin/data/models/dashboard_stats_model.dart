import '../../domain/entities/dashboard_stats_entity.dart';

class DashboardStatsModel
    extends DashboardStatsEntity {

  const DashboardStatsModel({
    required super.totalProducts,
    required super.totalCategories,
    required super.totalOrders,
    required super.totalRevenue,
  });
}