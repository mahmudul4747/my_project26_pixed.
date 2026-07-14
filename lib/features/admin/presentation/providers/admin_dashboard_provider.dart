import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_project26_fixed/features/admin/presentation/providers/admin_provider.dart';
import 'package:my_project26_fixed/features/admin/presentation/providers/product_provider.dart';

import '../../data/models/dashboard_stats_model.dart';



final dashboardStatsProvider =
    FutureProvider<DashboardStatsModel>((ref) async {

  return ref
      .read(dashboardUsecaseProvider)
      .call();

});