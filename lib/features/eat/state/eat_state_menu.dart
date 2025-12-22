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
      title: EatMainType.all.name,
      icon: Assets.image.eat.eatRestaurant.path,
      page: DCPages.eatList,
      params: {
        'type': EatMainType.all.type,
        'title': EatMainType.all.name,
      },
    ),
    DCMenuModel(
      title: EatMainType.main.name,
      icon: Assets.image.eat.eatMain.path,
      page: DCPages.eatList,
      params: {
        'type': EatMainType.main.type,
        'title': EatMainType.main.name,
      },
    ),
    DCMenuModel(
      title: EatMainType.drink.name,
      icon: Assets.image.eat.eatDrink.path,
      page: DCPages.eatList,
      params: {
        'type': EatMainType.drink.type,
        'title': EatMainType.drink.name,
      },
    ),
    DCMenuModel(
      title: EatMainType.dessert.name,
      icon: Assets.image.eat.eatDessert.path,
      page: DCPages.eatList,
      params: {
        'type': EatMainType.dessert.type,
        'title': EatMainType.dessert.name,
      },
    ),
  ];
}
