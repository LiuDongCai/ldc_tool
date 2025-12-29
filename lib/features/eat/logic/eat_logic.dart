import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/features/common/router/dc_router_config.dart';
import 'package:ldc_tool/features/eat/state/eat_state.dart';
import 'package:ldc_tool/features/eat_list/widgets/eat_list_feedback_dialog.dart';

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

  /// 处理反馈点击
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
