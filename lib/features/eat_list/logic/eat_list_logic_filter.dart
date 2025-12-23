import 'package:flutter/material.dart';
import 'package:ldc_tool/base/filter/dc_filter.dart';
import 'package:ldc_tool/base/filter/dc_filter_dropdown.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat_list/header/eat_list_header.dart';
import 'package:ldc_tool/features/eat_list/logic/eat_list_logic.dart';
import 'package:ldc_tool/features/eat_list/logic/eat_list_logic_list.dart';

extension EatListLogicFilter on EatListLogic {
  /// 关闭当前打开的筛选弹窗
  void dismissFilterDropdown() {
    if (DCFilterDropdown.isFilterDropdownOpen) {
      DCFilterDropdown.dismiss();
    }
  }

  /// 处理品类筛选点击
  Future<void> handleCategoryFilterClick(
    BuildContext context,
    RenderBox? anchorBox,
  ) async {
    if (anchorBox == null) return;
    // 品类数据
    final mainTypeDataList = EatMainType.values.map((mainType) {
      return FilterOption(
        id: mainType.type.toString(),
        name: mainType.name,
        isSelected: state.selectedMainType == mainType.type,
      );
    }).toList();

    final List<String>? selectedIds = await DCFilterNormalSelectView.showBelow(
      context: context,
      anchorBox: anchorBox,
      options: mainTypeDataList,
      showUnlimited: false, //不显示不限
      showReset: false,
      selectedIds: [state.selectedMainType.toString()],
      filterType: EatListFilterType.mainType.type,
    );

    // 如果是null，说明没有选择，不进行下一步操作
    if (selectedIds == null) return;

    final newMainType =
        int.tryParse(selectedIds.firstOrNull ?? '') ?? state.selectedMainType;
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
    if (anchorBox == null) return;
    // 区域数据
    final sectionDataList = SectionType.values.map((type) {
      return FilterOption(
        id: type.type.toString(),
        name: type.name,
        isSelected: state.selectedSectionId == type.type,
      );
    }).toList();

    final List<String>? selectedIds = await DCFilterNormalSelectView.showBelow(
      context: context,
      anchorBox: anchorBox,
      options: sectionDataList,
      selectedIds: [state.selectedSectionId.toString()],
      filterType: EatListFilterType.section.type,
    );

    // 如果是null，说明没有选择，不进行下一步操作
    if (selectedIds == null) return;

    final newSectionId =
        int.tryParse(selectedIds.firstOrNull ?? '') ?? state.selectedSectionId;
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
    if (anchorBox == null) return;
    // 菜系数据
    final foodTypeDataList = FoodType.values.map((type) {
      return FilterOption(
        id: type.type.toString(),
        name: type.name,
        isSelected: state.selectedFoodTypeIds.contains(type.type.toString()),
      );
    }).toList();

    final List<String>? selectedValues =
        await DCFilterNormalSelectView.showBelow(
      context: context,
      anchorBox: anchorBox,
      options: foodTypeDataList,
      selectedIds: state.selectedFoodTypeIds,
      isMultiSelect: true,
      rowCount: 3,
      filterType: EatListFilterType.foodType.type,
    );

    if (selectedValues == null) return;

    // 如果元素一样，不进行下一步操作
    if (state.selectedFoodTypeIds.length == selectedValues.length &&
        state.selectedFoodTypeIds.every((id) => selectedValues.contains(id))) {
      return;
    }
    // 如果是不限，则清空
    if (selectedValues.contains('0')) {
      state.selectedFoodTypeIds = [];
    } else {
      state.selectedFoodTypeIds = selectedValues;
    }

    // 重新获取餐馆列表
    await fetchEatList();
    scrollToTop();
  }

  /// 处理更多筛选点击
  Future<void> handleMoreFilterClick(
    BuildContext context,
    RenderBox? anchorBox,
  ) async {
    if (anchorBox == null) return;
    // 返现平台数据
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

    final Map<String, List<String>> selectedValues =
        await DCFilterMoreSelectView.showBelow(
      context: context,
      anchorBox: anchorBox,
      groups: groups,
      selectedValues: {
        EatListMoreFilterType.cashback.type: state.selectedCashbackIds,
      },
      filterType: EatListFilterType.more.type,
    );

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
    if (anchorBox == null) return;
    // 排序数据
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

    final String? selectedSortType =
        await DCFilterSingleListSelectView.showBelow(
      context: context,
      anchorBox: anchorBox,
      options: options,
      selectedId: state.sortType.name,
      showUnlimited: false,
      filterType: EatListFilterType.sort.type,
    );

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
}
