import 'package:get/get.dart';
import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/features/common/dc_router_config.dart';
import 'package:ldc_tool/features/eat/state/eat_state.dart';

class EatLogic extends GetxController {
  final EatState state = EatState();

  // @override
  // void onInit() async {
  //   super.onInit();

  //   // 接收路由参数
  // }

  /// 处理随机点击
  void handleRandomClick() {
    // 跳转到随机点餐页面
    DCRouter.open(
      DCPages.eatRandom,
    );
  }
}
