import 'package:flutter/material.dart';
import 'package:ldc_tool/features/common/dc_router_config.dart';
import 'package:ldc_tool/features/home/model/home_menu_model.dart';
import 'package:ldc_tool/features/home/state/home_state.dart';
import 'package:ldc_tool/gen/assets.gen.dart';

mixin HomeStateMenu on HomeCommonState {
  /// 菜单控制器
  ScrollController menuController = ScrollController();

  /// 菜单列表
  List<HomeMenuModel> menuList = [
    HomeMenuModel(
      title: '点餐',
      icon: Assets.image.common.dcCommonError.path,
      route: DCPages.eat,
    ),
    HomeMenuModel(
      title: '可爱',
      icon: Assets.image.common.dcCommonError.path,
      route: DCPages.home,
    ),
  ];
}
