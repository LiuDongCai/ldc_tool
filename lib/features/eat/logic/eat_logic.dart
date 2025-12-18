import 'package:get/get.dart';
import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/features/common/model/dc_menu_model.dart';
import 'package:ldc_tool/features/eat/state/eat_state.dart';

class EatLogic extends GetxController {
  final EatState state = EatState();

  // @override
  // void onInit() async {
  //   super.onInit();

  //   // 接收路由参数
  // }

  /// 点击菜单
  void handleMenuClick(DCMenuModel model) {
    DCRouter.open(model.router);
  }
}
