import 'package:flutter/material.dart';
import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/features/common/router/dc_router_config.dart';
import 'package:ldc_tool/features/eat/logic/eat_logic.dart';
import 'package:ldc_tool/features/eat_list/widgets/eat_list_feedback_dialog.dart';

extension EatLogicRandomFeedback on EatLogic {
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
