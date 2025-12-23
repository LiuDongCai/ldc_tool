import 'dart:math';

import 'package:get/get.dart';
import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/helper/eat_helper.dart';
import 'package:ldc_tool/features/eat_random/header/eat_random_header.dart';
import 'package:ldc_tool/features/eat_random/state/eat_random_state.dart';

class EatRandomLogic extends GetxController {
  final EatRandomState state = EatRandomState();

  @override
  void onInit() async {
    super.onInit();

    // 接收路由参数
    final type = DCRouter.arguments(
      'main_type',
      defaultValue: EatMainType.all.type,
    );
    if (type != null) {
      state.mainType = EatMainType.values.firstWhere(
        (element) => element.type == type,
      );
    }
    update([EatRandomUpdateId.mainType]);
  }

  /// 处理大类选择
  void handleMainTypeClick(EatMainType? mainType) {
    if (mainType == null) return;
    state.mainType = mainType;
    update([EatRandomUpdateId.mainType]);
  }

  /// 处理区域选择
  void handleSectionClick(SectionType? section) {
    if (section == null) return;
    state.section = section;
    update([EatRandomUpdateId.section]);
  }

  /// 处理随机点击
  Future<void> handleRandomClick() async {
    // 选中的大类
    final selectedMainType = state.mainType;
    // 大类的餐馆数据
    final eatList = await EatHelper.getEatList(mainType: selectedMainType);

    // 选中的区域
    final selectedSection = state.section;
    // 区域的餐馆数据，餐馆里section空的数据表示不限，也包含在内
    final sectionEatList = eatList.where((element) {
      final section = element.section;
      // 如果区域为不限，则返回true
      if (section == null || section.isEmpty) {
        return true;
      }
      return section.contains(selectedSection.type);
    }).toList();

    // 随机选择一个餐馆
    final randomRestaurant =
        sectionEatList.elementAt(Random().nextInt(sectionEatList.length));
    state.randomResult = randomRestaurant;
    update([EatRandomUpdateId.randomResult]);
  }
}
