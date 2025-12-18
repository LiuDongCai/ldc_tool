import 'package:flutter/material.dart';

class DCRouter {
  /// 打开新页面
  /// context.push(path)：将新页面推入到当前的路由堆栈之上，这和 Navigator.push 行为一致，通常用于从列表页进入详情页。
  static void open(
    BuildContext context,
    String path, {
    Map<String, String>? arguments,
  }) {
    // GoRouter.of(context).push(
    //   path,
    //   extra: arguments,
    // );
  }

  /// 打开并替换当前页面
  /// context.go(path)：跳转到新页面，它会替换当前的路由堆栈。这更适用于 Web 行为或主标签页切换。
  static void openAndReplace(
    BuildContext context,
    String path, {
    Map<String, String>? arguments,
  }) {
    // GoRouter.of(context).go(
    //   path,
    //   extra: arguments,
    // );
  }

  /// 返回上一页
  static void close(BuildContext context) {
    // GoRouter.of(context).pop();
  }

  /// 获取路由参数
  static dynamic arguments(
    BuildContext context,
    String key, {
    var defaultValue,
  }) {
    // final state = GoRouterState.of(context);
    // if (state.extra == null) {
    //   return null;
    // }
    // if (state.extra is Map<String, dynamic>) {
    //   return (state.extra as Map<String, dynamic>)[key] ?? defaultValue;
    // }
    return defaultValue;
  }
}
