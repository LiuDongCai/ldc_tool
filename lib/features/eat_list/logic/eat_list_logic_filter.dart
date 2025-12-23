import 'package:flutter/material.dart';
import 'package:ldc_tool/base/filter/filter.dart';
import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/features/common/dc_router_config.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/model/eat_model.dart';
import 'package:ldc_tool/features/eat_list/header/eat_list_header.dart';
import 'package:ldc_tool/features/eat_list/logic/eat_list_logic.dart';
import 'package:ldc_tool/features/eat_list/logic/eat_list_logic_list.dart';

extension EatListLogicFilter on EatListLogic {
  /// 应用筛选和排序
  void applyFilters() {
    List<EatModel> filteredList = List.from(state.eatList);

   
    // 排序
    switch (state.sortType) {
      case EatListFilterSortType.scoreHighToLow:
        filteredList.sort((a, b) {
          final scoreA = a.score ?? 0.0;
          final scoreB = b.score ?? 0.0;
          return scoreB.compareTo(scoreA);
        });
        break;
      case EatListFilterSortType.scoreLowToHigh:
        filteredList.sort((a, b) {
          final scoreA = a.score ?? 0.0;
          final scoreB = b.score ?? 0.0;
          return scoreA.compareTo(scoreB);
        });
        break;
      case EatListFilterSortType.defaultSort:
        break;
    }

    state.eatList = filteredList;
    update();
  }

  /// 处理品类筛选点击
  Future<void> handleCategoryFilterClick(
    BuildContext context,
    RenderBox? anchorBox,
  ) async {
    // 品类数据
    final mainTypeDataList = EatMainType.values.map((mainType) {
      return FilterOption(
        id: mainType.type.toString(),
        name: mainType.name,
        isSelected: state.selectedMainType == mainType.type,
      );
    }).toList();

    final String? selectedId;
    if (anchorBox != null) {
      selectedId = await FilterSingleSelect.showBelow(
        context: context,
        anchorBox: anchorBox,
        options: mainTypeDataList,
        showUnlimited: false, //不显示不限
        selectedId: '${state.selectedMainType}',
        title: '品类筛选',
        filterType: EatListFilterType.mainType.type,
      );
    } else {
      selectedId = await FilterSingleSelect.show(
        context: context,
        options: mainTypeDataList,
        showUnlimited: false, //不显示不限
        selectedId: '${state.selectedMainType}',
        title: '品类筛选',
      );
    }
    // 如果是null，说明没有选择，不进行下一步操作
    if (selectedId == null) return;

    final newMainType = int.tryParse(selectedId) ?? state.selectedMainType;
    // 如果新选择的品类和当前选择的品类相同，不进行下一步操作
    if (newMainType == state.selectedMainType) return;

    state.selectedMainType = newMainType;

    // 重新获取餐馆列表
    await fetchEatList();
    scrollToTop();
  }

  /// 处理区域筛选点击
  Future<void> handleSectionFilterClick(
    BuildContext context,
    RenderBox? anchorBox,
  ) async {
    final sectionDataList = SectionType.values.map((type) {
      return FilterOption(
        id: type.type.toString(),
        name: type.name,
        isSelected: state.selectedSectionId == type.type,
      );
    }).toList();

    final String? selectedId;
    if (anchorBox != null) {
      selectedId = await FilterSingleSelect.showBelow(
        context: context,
        anchorBox: anchorBox,
        options: sectionDataList,
        selectedId: '${state.selectedSectionId}',
        title: '区域筛选',
        filterType: EatListFilterType.section.type,
      );
    } else {
      selectedId = await FilterSingleSelect.show(
        context: context,
        options: sectionDataList,
        selectedId: '${state.selectedSectionId}',
        title: '区域筛选',
      );
    }
    // 如果是null，说明没有选择，不进行下一步操作
    if (selectedId == null) return;

    final newSectionId = int.tryParse(selectedId) ?? state.selectedSectionId;
    // 如果新选择的品类和当前选择的品类相同，不进行下一步操作
    if (newSectionId == state.selectedSectionId) return;

    state.selectedSectionId = newSectionId;

    // 重新获取餐馆列表
    await fetchEatList();
    scrollToTop();
  }

  /// 处理菜系筛选点击
  Future<void> handleFoodTypeFilterClick(
    BuildContext context,
    RenderBox? anchorBox,
  ) async {
    final options = FoodType.values.map((type) {
      return FilterOption(
        id: type.type.toString(),
        name: type.name,
        isSelected: state.selectedFoodTypeIds.contains(type.type.toString()),
      );
    }).toList();

    final groups = [
      FilterGroup(
        title: '菜系',
        options: options,
        isMultiSelect: true,
      ),
    ];
    final List<String> selectedValues;
    if (anchorBox != null) {
      selectedValues = await FilterMultiSelect.showBelow(
        context: context,
        anchorBox: anchorBox,
        groups: groups,
        selectedIds: state.selectedFoodTypeIds,
        title: '菜系筛选',
        filterType: EatListFilterType.foodType.type,
      );
    } else {
      selectedValues = await FilterMultiSelect.show(
        context: context,
        groups: groups,
        selectedIds: state.selectedFoodTypeIds,
        title: '菜系筛选',
      );
    }
    // 如果元素一样，不进行下一步操作
    if (state.selectedFoodTypeIds.length == selectedValues.length &&
        state.selectedFoodTypeIds.every((id) => selectedValues.contains(id))) {
      return;
    }
    state.selectedFoodTypeIds = selectedValues;

    // 重新获取餐馆列表
    await fetchEatList();
    scrollToTop();
  }

  /// 处理更多筛选点击
  Future<void> handleMoreFilterClick(
    BuildContext context,
    RenderBox? anchorBox,
  ) async {
    final cashbackOptions = CashbackPlatform.values.map((platform) {
      return FilterOption(
        id: platform.platform.toString(),
        name: platform.name,
        isSelected:
            state.selectedCashbackIds.contains(platform.platform.toString()),
      );
    }).toList();

    final groups = [
      FilterGroup(
        title: EatListMoreFilterType.cashback.type,
        options: cashbackOptions,
        isMultiSelect: true,
      ),
    ];

    final Map<String, List<String>> selectedValues;
    if (anchorBox != null) {
      selectedValues = await FilterMore.showBelow(
        context: context,
        anchorBox: anchorBox,
        groups: groups,
        selectedValues: {
          EatListMoreFilterType.cashback.type: state.selectedCashbackIds,
        },
        title: '更多筛选',
        filterType: EatListFilterType.more.type,
      );
    } else {
      selectedValues = await FilterMore.show(
        context: context,
        groups: groups,
        selectedValues: {
          EatListMoreFilterType.cashback.type: state.selectedCashbackIds,
        },
        title: '更多筛选',
      );
    }

    // 数据是否改变
    bool isDataChanged = false;

    // 返现平台
    final newCashbackIds =
        selectedValues[EatListMoreFilterType.cashback.type] ?? [];
    // 如果返现平台元素不一样，则数据改变
    if (state.selectedCashbackIds.length != newCashbackIds.length ||
        !state.selectedCashbackIds.every((id) => newCashbackIds.contains(id))) {
      isDataChanged = true;
      state.selectedCashbackIds = newCashbackIds;
    }

    // 数据未改变
    if (!isDataChanged) return;

    // 重新获取餐馆列表
    await fetchEatList();
    scrollToTop();
  }

  /// 处理排序筛选点击
  Future<void> handleSortFilterClick(
    BuildContext context,
    RenderBox? anchorBox,
  ) async {
    final options = [
      FilterOption(
        id: EatListFilterSortType.defaultSort.name,
        name: '默认排序',
        isSelected: state.sortType == EatListFilterSortType.defaultSort,
      ),
      FilterOption(
        id: EatListFilterSortType.scoreHighToLow.name,
        name: '评分从高到低',
        isSelected: state.sortType == EatListFilterSortType.scoreHighToLow,
      ),
      FilterOption(
        id: EatListFilterSortType.scoreLowToHigh.name,
        name: '评分从低到高',
        isSelected: state.sortType == EatListFilterSortType.scoreLowToHigh,
      ),
    ];

    final String? selectedSortType;
    if (anchorBox != null) {
      selectedSortType = await FilterSingleSelect.showBelow(
        context: context,
        anchorBox: anchorBox,
        options: options,
        selectedId: state.sortType.name,
        title: '排序',
        showUnlimited: false,
        filterType: EatListFilterType.sort.type,
      );
    } else {
      selectedSortType = await FilterSingleSelect.show(
        context: context,
        options: options,
        selectedId: state.sortType.name,
        title: '排序',
        showUnlimited: false,
      );
    }

    // 如果是null，说明没有选择，不进行下一步操作
    if (selectedSortType == null) return;

    // 如果新选择的排序和当前选择的排序相同，不进行下一步操作
    if (selectedSortType == state.sortType.name) return;

    state.sortType = EatListFilterSortType.values.firstWhere(
      (type) => type.name == selectedSortType,
      orElse: () => EatListFilterSortType.defaultSort,
    );

    // 重新获取餐馆列表
    await fetchEatList();
    scrollToTop();
  }

  /// 跳转到随机点餐
  Future<void> handleRandomEatClick() async {
    DCRouter.open(
      DCPages.eatRandom,
      arguments: {
        'main_type': state.selectedMainType,
      },
    );
  }
}
