import 'package:get/get.dart';

class DCRouter {
  /// 打开新页面
  /// 使用 Get.toNamed()：将新页面推入到当前的路由堆栈之上，保留当前页面，可以返回
  /// 适用于：从列表页进入详情页等场景
  static void open(
    String pageName, {
    Map<String, dynamic>? arguments,
  }) {
    Get.toNamed(
      pageName,
      arguments: arguments,
    );
  }

  /// 打开并替换当前页面
  /// 使用 Get.offNamed()：跳转到新页面，替换当前的路由堆栈，无法返回到被替换的页面
  /// 适用于：Web 行为或主标签页切换等场景
  static void openAndReplace(
    String pageName, {
    Map<String, dynamic>? arguments,
  }) {
    // Get.offNamed() 和 Get.offAllNamed() 的区别：
    // Get.offNamed() 直接替换当前页面,新页面占据被替换页面的位置，堆栈深度不变,适用：登录后替换登录页、标签页切换等
    // Get.offAndToNamed() 先移除当前页面（off），再推送新页面（to）,先移除当前页面，再添加新页面,适用：需要先清理当前页面再导航的场景
    Get.offAndToNamed(
      pageName,
      arguments: arguments,
    );
  }

  /// 返回上一页
  static void close() {
    Get.back();
  }

  /// 获取路由参数
  static dynamic arguments(
    String key, {
    var defaultValue,
  }) =>
      Get.parameters[key] ?? Get.arguments?[key] ?? defaultValue;

  /// 获取所有路由参数
  static dynamic get allArguments => {
        ...Get.parameters,
        ...((Get.arguments is Map) ? Get.arguments : {}),
      };
}
