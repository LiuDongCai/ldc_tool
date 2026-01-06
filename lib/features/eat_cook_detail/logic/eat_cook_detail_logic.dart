import 'package:get/get.dart';
import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/features/eat_cook_detail/state/eat_cook_detail_state.dart';

class EatCookDetailLogic extends GetxController {
  final EatCookDetailState state = EatCookDetailState();

  @override
  void onInit() async {
    super.onInit();

    // 接收路由参数
    state.cookModel = DCRouter.arguments("model");
    update();
  }
}
