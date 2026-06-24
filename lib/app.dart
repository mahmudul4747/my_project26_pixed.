import 'package:flutter/material.dart';
import 'core/config/app_router.dart';
import 'core/config/theme.dart';

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Manager',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}