import 'package:get/get.dart';
import 'package:ldc_tool/features/main/state/main_state.dart';

class MainLogic extends GetxController {
  final MainState state = MainState();

  @override
  void onInit() async {
    super.onInit();

    // 接收路由参数
    // state.regionId = TWRouter.arguments("regionid") ?? "";
  }
}
