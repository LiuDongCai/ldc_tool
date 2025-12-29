import 'package:get/get.dart';
import 'package:ldc_tool/features/eat/page/eat_page.dart';
import 'package:ldc_tool/features/eat_list/page/eat_list_page.dart';
import 'package:ldc_tool/features/eat_random/page/eat_random_page.dart';
import 'package:ldc_tool/features/home/page/home_page.dart';
import 'package:ldc_tool/features/main/page/main_page.dart';

/// 路由配置
final router = [
  GetPage(
    name: DCPages.main,
    page: () => const MainPage(),
  ),
  GetPage(
    name: DCPages.home,
    page: () => const HomePage(),
  ),
  GetPage(
    name: DCPages.eat,
    page: () => const EatPage(),
  ),
  GetPage(
    name: DCPages.eatList,
    page: () => const EatListPage(),
  ),
  GetPage(
    name: DCPages.eatRandom,
    page: () => const EatRandomPage(),
  ),
];

class DCPages {
  /// 主页
  static const String main = '/main';

  /// 首页
  static const String home = '/main/home';

  /// 点餐
  static const String eat = '/main/eat';

  /// 点餐列表
  static const String eatList = '/main/eat_list';

  /// 随机点餐
  static const String eatRandom = '/main/eat_random';
}
