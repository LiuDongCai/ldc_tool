import 'package:get/get.dart';
import 'package:ldc_tool/features/game/state/game_state.dart';

class GameLogic extends GetxController {
  final GameState state = GameState();

  @override
  void onInit() async {
    super.onInit();

    // 接收路由参数
    // state.regionId = TWRouter.arguments("regionid") ?? "";
  }
}
