import 'package:flutter/material.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/helper/eat_helper.dart';
import 'package:ldc_tool/features/eat/model/eat_model.dart';
import 'package:ldc_tool/features/eat_list/header/eat_list_header.dart';
import 'package:ldc_tool/features/eat_list/logic/eat_list_logic.dart';

extension EatListLogicList on EatListLogic {
  /// 获取餐馆列表
  Future<void> fetchEatList() async {
    // 先获取品类下的列表
    final mainType = EatMainType.values.firstWhere(
      (element) => element.type == state.selectedMainType,
    );
    List<EatModel> eatList = await EatHelper.getEatList(mainType: mainType);

    // 再根据区域筛选
    if (state.selectedSectionId != 0) {
      eatList = eatList.where((item) {
        final section = item.section;
        if (section == null || section.isEmpty) {
          // 不限区域的餐馆
          return true;
        }
        if (section.contains(state.selectedSectionId)) {
          // 匹配区域
          return true;
        }
        return false;
      }).toList();
    }

    // 再根据菜系选择
    if (state.selectedFoodTypeIds.isNotEmpty) {
      eatList = eatList.where((item) {
        final types = item.type;
        if (types == null || types.isEmpty) {
          return false;
        }
        return types
            .any((type) => state.selectedFoodTypeIds.contains(type.toString()));
      }).toList();
    }

    // 再根据返现平台筛选
    if (state.selectedCashbackIds.isNotEmpty) {
      eatList = eatList.where((item) {
        final cashbackList = item.cashback;
        if (cashbackList == null || cashbackList.isEmpty) {
          return false;
        }
        return cashbackList.any((platform) =>
            state.selectedCashbackIds.contains(platform.toString()));
      }).toList();
    }

    // 再根据排序筛选
    switch (state.sortType) {
      case EatListFilterSortType.scoreHighToLow:
        eatList.sort((a, b) {
          final scoreA = a.score ?? 0.0;
          final scoreB = b.score ?? 0.0;
          return scoreB.compareTo(scoreA);
        });
        break;
      case EatListFilterSortType.scoreLowToHigh:
        eatList.sort((a, b) {
          final scoreA = a.score ?? 0.0;
          final scoreB = b.score ?? 0.0;
          return scoreA.compareTo(scoreB);
        });
        break;
      case EatListFilterSortType.defaultSort:
        break;
    }

    state.eatList = eatList;
    update([
      EatListUpdateId.eatList,
      EatListUpdateId.filterBar,
    ]);
  }

  /// 列表回到顶部，可选是否动画
  void scrollToTop({
    bool animated = false,
  }) {
    if (animated) {
      state.scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      state.scrollController.jumpTo(0.0);
    }
  }
}
