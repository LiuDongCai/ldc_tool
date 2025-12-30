import 'package:get/get.dart';
import 'package:ldc_tool/features/main/header/main_header.dart';
import 'package:ldc_tool/features/main/state/main_state.dart';

class MainLogic extends GetxController {
  final MainState state = MainState();

  // @override
  // void onInit() async {
  //   super.onInit();

  //   // 接收路由参数
  //   final index = DCRouter.arguments('index') ?? 0;
  //   state.currentIndex = index;
  //   update();
  // }

  /// 切换底部导航栏
  void handleBottomNavTap(int index) {
    state.currentIndex = index;
    update();
  }

  /// 切换底部导航栏
  void handleBottomNavTapByType(MainBottomNavigationBarType type) {
    state.currentIndex = state.bottomNavigationBarTypeList.indexOf(type);
    update();
  }
}
