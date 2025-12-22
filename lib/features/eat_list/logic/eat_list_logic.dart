import 'package:get/get.dart';
import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/features/common/dc_router_config.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/helper/eat_helper.dart';
import 'package:ldc_tool/features/eat_list/state/eat_list_state.dart';

class EatListLogic extends GetxController {
  final EatListState state = EatListState();

  @override
  void onInit() async {
    super.onInit();

    // 接收路由参数
    final type = DCRouter.arguments(
      'type',
      defaultValue: EatMainType.all.type,
    );
    if (type != null) {
      state.eatMainType = EatMainType.values.firstWhere(
        (element) => element.type == type,
      );
    }
    state.eatMainTypeName = DCRouter.arguments(
      'title',
      defaultValue: EatMainType.all.name,
    );

    initEatList();
  }

  /// 初始化餐馆列表
  Future<void> initEatList() async {
    final eatList = await EatHelper.getEatList(mainType: state.eatMainType);
    state.eatList = eatList;
    update();
  }

  /// 跳转到随机点餐
  Future<void> handleRandomEatClick() async {
    DCRouter.open(
      DCPages.eatRandom,
      arguments: {
        'type': state.eatMainType.type,
      },
    );
  }
}
