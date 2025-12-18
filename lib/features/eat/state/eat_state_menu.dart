import 'package:flutter/material.dart';
import 'package:ldc_tool/features/common/dc_router_config.dart';
import 'package:ldc_tool/features/common/model/dc_menu_model.dart';
import 'package:ldc_tool/features/eat/state/eat_state.dart';
import 'package:ldc_tool/gen/assets.gen.dart';

mixin EatStateMenu on EatCommonState {
  /// 菜单控制器
  ScrollController eatMenuController = ScrollController();

  /// 菜单列表
  List<DCMenuModel> eatMenuList = [
    DCMenuModel(
      title: '点餐',
      icon: Assets.image.common.dcCommonError.path,
      router: DCPages.eat,
    ),
  ];
}
