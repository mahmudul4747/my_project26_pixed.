class DashboardStatsEntity {
  final int totalProducts;
  final int totalCategories;
  final int totalOrders;
  final double totalRevenue;

  const DashboardStatsEntity({
    required this.totalProducts,
    required this.totalCategories,
    required this.totalOrders,
    required this.totalRevenue,
  });
}