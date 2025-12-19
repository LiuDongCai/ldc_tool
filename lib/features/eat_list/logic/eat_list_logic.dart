import 'package:get/get.dart';
import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/helper/eat_helper.dart';
import 'package:ldc_tool/features/eat_list/state/eat_list_state.dart';

class EatListLogic extends GetxController {
  final EatListState state = EatListState();

  @override
  void onInit() async {
    super.onInit();

    // 接收路由参数
    final type = DCRouter.arguments('type');
    if (type != null) {
      state.eatMainType = EatMainType.values.firstWhere(
        (element) => element.type == type,
      );
    }

    initEatList();
  }

  /// 初始化餐馆列表
  Future<void> initEatList() async {
    switch (state.eatMainType) {
      case EatMainType.all:
        final eatList = await EatHelper.getEatAllList();
        state.eatList = eatList;
        break;
      case EatMainType.main:
        final eatList = await EatHelper.getEatMainList();
        state.eatList = eatList;
        break;
      case EatMainType.drink:
        final eatList = await EatHelper.getEatDrinkList();
        state.eatList = eatList;
        break;
      case EatMainType.dessert:
        final eatList = await EatHelper.getEatDessertList();
        state.eatList = eatList;
        break;
    }
    update();
  }
}
