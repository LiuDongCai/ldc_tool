import 'package:get/get.dart';
import 'package:ldc_tool/features/eat/page/eat_page.dart';
import 'package:ldc_tool/features/eat_cook_detail/page/eat_cook_detail_page.dart';
import 'package:ldc_tool/features/eat_cook_random/page/eat_cook_random_page.dart';
import 'package:ldc_tool/features/eat_list/page/eat_list_page.dart';
import 'package:ldc_tool/features/eat_random/page/eat_random_page.dart';
import 'package:ldc_tool/features/game/page/game_page.dart';
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
    name: DCPages.game,
    page: () => const GamePage(),
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
  GetPage(
    name: DCPages.eatCookRandom,
    page: () => const EatCookRandomPage(),
  ),
  GetPage(
    name: DCPages.eatCookDetail,
    page: () => const EatCookDetailPage(),
  ),
];

class DCPages {
  /// APP主页
  static const String main = '/main';

  /// 首页
  static const String home = '/main/home';

  /// 游戏
  static const String game = '/main/game';

  /// 点餐
  static const String eat = '/main/eat';

  /// 点餐列表
  static const String eatList = '/main/eat_list';

  /// 随机点餐
  static const String eatRandom = '/main/eat_random';

  /// 家常菜随机点菜
  static const String eatCookRandom = '/main/eat_cook_random';

  /// 家常菜详情
  static const String eatCookDetail = '/main/eat_cook_detail';
}
