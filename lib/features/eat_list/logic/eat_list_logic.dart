import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/common/widgets/toast/dc_toast.dart';
import 'package:ldc_tool/features/common/dc_router_config.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat_list/logic/eat_list_logic_filter.dart';
import 'package:ldc_tool/features/eat_list/logic/eat_list_logic_list.dart';
import 'package:ldc_tool/features/eat_list/state/eat_list_state.dart';
import 'package:ldc_tool/features/eat_list/widgets/eat_list_feedback_dialog.dart';
import 'package:ldc_tool/features/eat_list/widgets/eat_list_random_result_dialog.dart';

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
    dismissFilterDropdown();
    DCRouter.open(
      DCPages.eatRandom,
      arguments: {
        'main_type': state.selectedMainType,
      },
    );
  }

  /// 随机选择当前列表的餐馆
  void handleRandomCurrentEatList(BuildContext context) {
    // 如果当前列表无数据，则不随机，并提示无数据
    if (state.eatList.isEmpty) {
      DCToast.show(
        message: '当前列表无数据\n请更改筛选条件再操作',
        textAlign: TextAlign.center,
      );
      return;
    }
    final randomRestaurant = state.eatList.elementAt(
      Random().nextInt(state.eatList.length),
    );
    // 弹窗展示随机结果
    showDialog(
      context: context,
      builder: (context) {
        return EatListRandomResultDialog(model: randomRestaurant);
      },
    );
  }

  /// 反馈补充餐馆
  void handleFeedbackClick(BuildContext context) {
    // 弹窗展示反馈对话框
    showDialog(
      context: context,
      builder: (context) {
        return const EatListFeedbackDialog();
      },
    );
  }
}
