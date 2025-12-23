import 'package:get/get.dart';
import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/features/common/dc_router_config.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat_list/logic/eat_list_logic_list.dart';
import 'package:ldc_tool/features/eat_list/state/eat_list_state.dart';

class EatListLogic extends GetxController {
  final EatListState state = EatListState();

  @override
  void onInit() async {
    super.onInit();

    // 接收路由参数
    state.selectedMainType = DCRouter.arguments(
      'main_type',
      defaultValue: EatMainType.all.type,
    );

    // 获取餐馆列表
    fetchEatList();
  }

  /// 跳转到随机点餐
  Future<void> handleRandomEatClick() async {
    DCRouter.open(
      DCPages.eatRandom,
      arguments: {
        'main_type': state.selectedMainType,
      },
    );
  }
}
