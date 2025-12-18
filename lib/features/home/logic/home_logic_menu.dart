import 'package:flutter/material.dart';
import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/features/home/logic/home_logic.dart';
import 'package:ldc_tool/features/home/model/home_menu_model.dart';

extension HomeLogicMenu on HomeLogic {
  /// 点击菜单项
  void handleMenuClick(BuildContext context, HomeMenuModel model) {
    DCRouter.open(
      context,
      model.route,
      // arguments: {
      //   'title': model.title,
      //   'icon': model.icon,
      //   'route': model.route,
      // },
    );
  }
}
