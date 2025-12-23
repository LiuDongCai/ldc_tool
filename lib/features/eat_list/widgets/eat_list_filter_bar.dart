import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/base/filter/dc_filter.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat_list/header/eat_list_header.dart';
import 'package:ldc_tool/features/eat_list/logic/eat_list_logic.dart';
import 'package:ldc_tool/features/eat_list/logic/eat_list_logic_filter.dart';
import 'package:ldc_tool/features/eat_list/state/eat_list_state.dart';

/// 餐馆列表筛选栏
class EatListFilterBar extends StatefulWidget {
  const EatListFilterBar({super.key});

  @override
  State<EatListFilterBar> createState() => _EatListFilterBarState();
}

class _EatListFilterBarState extends State<EatListFilterBar>
    with EatListLogicConsumerMixin<EatListFilterBar> {
  EatListState get state => logic.state;

  final GlobalKey _categoryKey = GlobalKey();
  final GlobalKey _sectionKey = GlobalKey();
  final GlobalKey _foodTypeKey = GlobalKey();
  final GlobalKey _moreKey = GlobalKey();
  final GlobalKey _sortKey = GlobalKey();

  /// 弹窗状态变化回调
  void _onFilterDropdownStateChanged() {
    // 更新筛选栏UI
    logic.update([EatListUpdateId.filterBar]);
  }

  @override
  void initState() {
    super.initState();
    // 监听弹窗状态变化
    DCFilterDropdown.addStateChangedListener(_onFilterDropdownStateChanged);
  }

  @override
  void dispose() {
    // 移除监听
    DCFilterDropdown.removeStateChangedListener(_onFilterDropdownStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EatListLogic>(
      tag: logicTag,
      id: EatListUpdateId.filterBar,
      builder: (_) {
        Widget resultWidget = Container(
          color: DCColors.dcFFFFFF,
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DCFilterTabItem(
                key: _categoryKey,
                title: state.selectedMainTypeName,
                isSelected: true,
                isOpen: DCFilterDropdown.currentFilterType ==
                    EatListFilterType.mainType.type,
                onTap: () => logic.handleCategoryFilterClick(
                  context,
                  _categoryKey.currentContext?.findRenderObject() as RenderBox?,
                ),
              ),
              DCFilterTabItem(
                key: _sectionKey,
                title: state.selectedSectionName,
                isSelected: state.selectedSectionId != 0,
                isOpen: DCFilterDropdown.currentFilterType ==
                    EatListFilterType.section.type,
                onTap: () => logic.handleSectionFilterClick(
                  context,
                  _sectionKey.currentContext?.findRenderObject() as RenderBox?,
                ),
              ),
              DCFilterTabItem(
                key: _foodTypeKey,
                title: state.selectedFoodTypeName,
                isSelected: state.selectedFoodTypeIds.isNotEmpty,
                isOpen: DCFilterDropdown.currentFilterType ==
                    EatListFilterType.foodType.type,
                onTap: () => logic.handleFoodTypeFilterClick(
                  context,
                  _foodTypeKey.currentContext?.findRenderObject() as RenderBox?,
                ),
              ),
              DCFilterTabItem(
                key: _moreKey,
                title: '更多',
                isSelected: state.selectedCashbackIds.isNotEmpty,
                isOpen: DCFilterDropdown.currentFilterType ==
                    EatListFilterType.more.type,
                onTap: () => logic.handleMoreFilterClick(
                  context,
                  _moreKey.currentContext?.findRenderObject() as RenderBox?,
                ),
              ),
              DCFilterTabItem(
                key: _sortKey,
                title: _getSortTitle(),
                isSelected: state.sortType != EatListFilterSortType.defaultSort,
                isOpen: DCFilterDropdown.currentFilterType ==
                    EatListFilterType.sort.type,
                onTap: () => logic.handleSortFilterClick(
                  context,
                  _sortKey.currentContext?.findRenderObject() as RenderBox?,
                ),
              ),
            ],
          ),
        );
        return resultWidget;
      },
    );
  }

  /// 获取排序标题
  String _getSortTitle() {
    switch (state.sortType) {
      case EatListFilterSortType.scoreHighToLow:
        return '评分↓';
      case EatListFilterSortType.scoreLowToHigh:
        return '评分↑';
      case EatListFilterSortType.defaultSort:
        return '排序';
    }
  }
}
