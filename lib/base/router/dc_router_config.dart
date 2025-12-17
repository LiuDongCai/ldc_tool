import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ldc_tool/features/home/page/home_page.dart';
import 'package:ldc_tool/features/main/page/main_page.dart';

/// 路由配置
/// 用法:
/// MaterialApp.router(
///   routerConfig: router,
/// )
final GoRouter router = GoRouter(
  // 404 页面
  errorBuilder: (context, state) => const Scaffold(
    body: Center(
      child: Text('404 not found'),
    ),
  ),
  // 路由配置
  initialLocation: DCPages.main,
  routes: [
    GoRoute(
      path: DCPages.main,
      builder: (_, state) => const MainPage(),
    ),
    GoRoute(
      path: DCPages.home,
      builder: (_, state) => const HomePage(),
    ),
  ],
);

class DCPages {
  /// 主页
  static const String main = '/main';

  /// 首页
  static const String home = '/main/home';
}
