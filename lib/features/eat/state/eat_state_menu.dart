import 'package:flutter/material.dart';
import 'package:ldc_tool/features/common/dc_router_config.dart';
import 'package:ldc_tool/features/common/model/dc_menu_model.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/state/eat_state.dart';
import 'package:ldc_tool/gen/assets.gen.dart';

mixin EatStateMenu on EatCommonState {
  /// 菜单控制器
  ScrollController eatMenuController = ScrollController();

  /// 菜单列表
  List<DCMenuModel> eatMenuList = [
    DCMenuModel(
      title: '全部',
      icon: Assets.image.eat.eatRestaurant.path,
      page: DCPages.eatList,
      params: {
        'type': EatMainType.all.type,
      },
    ),
    DCMenuModel(
      title: '主食',
      icon: Assets.image.eat.eatMain.path,
      page: DCPages.eatList,
      params: {
        'type': EatMainType.main.type,
      },
    ),
    DCMenuModel(
      title: '饮品',
      icon: Assets.image.eat.eatDrink.path,
      page: DCPages.eatList,
      params: {
        'type': EatMainType.drink.type,
      },
    ),
    DCMenuModel(
      title: '甜点',
      icon: Assets.image.eat.eatDessert.path,
      page: DCPages.eatList,
      params: {
        'type': EatMainType.dessert.type,
      },
    ),
  ];
}
