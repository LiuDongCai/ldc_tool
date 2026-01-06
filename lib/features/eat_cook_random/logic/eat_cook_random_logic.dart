import 'dart:math';

import 'package:get/get.dart';
import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/features/common/router/dc_router_config.dart';
import 'package:ldc_tool/features/eat_cook_random/header/eat_cook_random_header.dart';
import 'package:ldc_tool/features/eat_cook_random/helper/eat_cook_helper.dart';
import 'package:ldc_tool/features/eat_cook_random/model/eat_model.dart';
import 'package:ldc_tool/features/eat_cook_random/state/eat_cook_random_state.dart';

class EatCookRandomLogic extends GetxController {
  final EatCookRandomState state = EatCookRandomState();

  /// 几菜
  void handleCookCountSelect(int cookCount) {
    state.cookCount = cookCount;
    update([EatCookRandomUpdateId.cookCount]);
  }

  /// 几汤
  void handleSoupCountSelect(int soupCount) {
    state.soupCount = soupCount;
    update([EatCookRandomUpdateId.soupCount]);
  }

  /// 处理随机点击
  Future<void> handleRandomClick() async {
    // 几菜几汤
    // final selectedCookCount = state.cookCount;
    // final selectedSoupCount = state.soupCount;

    final cookMainList = await EatCookHelper.getCookMainList();
    // final cookSoupList = await EatCookHelper.getCookSoupList();

    // 随机选择几菜
    final randomCookList =
        cookMainList.elementAt(Random().nextInt(cookMainList.length));
    // // 随机选择几汤
    // final randomSoupList =
    //     cookSoupList.elementAt(Random().nextInt(cookSoupList.length));

    state.randomResult = randomCookList;
    update([EatCookRandomUpdateId.randomResult]);
  }

  /// 跳转到家常菜详情
  void handleCookDetailClick(EatCookModel? model) {
    if (model == null) return;
    DCRouter.open(
      DCPages.eatCookDetail,
      arguments: {
        'model': model,
      },
    );
  }
}
