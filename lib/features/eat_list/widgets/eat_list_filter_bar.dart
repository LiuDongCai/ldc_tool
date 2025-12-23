import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
              _buildFilterItem(
                key: _categoryKey,
                title: state.selectedMainTypeName,
                isSelected: true,
                onTap: () => logic.handleCategoryFilterClick(
                  context,
                  _categoryKey.currentContext?.findRenderObject() as RenderBox?,
                ),
              ),
              _buildFilterItem(
                key: _sectionKey,
                title: state.selectedSectionName,
                isSelected: state.selectedSectionId != 0,
                onTap: () => logic.handleSectionFilterClick(
                  context,
                  _sectionKey.currentContext?.findRenderObject() as RenderBox?,
                ),
              ),
              _buildFilterItem(
                key: _foodTypeKey,
                title: state.selectedFoodTypeName,
                isSelected: state.selectedFoodTypeIds.isNotEmpty,
                onTap: () => logic.handleFoodTypeFilterClick(
                  context,
                  _foodTypeKey.currentContext?.findRenderObject() as RenderBox?,
                ),
              ),
              _buildFilterItem(
                key: _moreKey,
                title: '更多',
                isSelected: state.selectedCashbackIds.isNotEmpty,
                onTap: () => logic.handleMoreFilterClick(
                  context,
                  _moreKey.currentContext?.findRenderObject() as RenderBox?,
                ),
              ),
              _buildFilterItem(
                key: _sortKey,
                title: _getSortTitle(),
                isSelected: state.sortType != EatListFilterSortType.defaultSort,
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

  /// 构建筛选项
  Widget _buildFilterItem({
    required Key key,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    Widget resultWidget = GestureDetector(
      key: key,
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 60.w,
        padding: EdgeInsets.symmetric(
          vertical: 6.w,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? DCColors.dc42CC8F.withValues(alpha: 0.1)
              : DCColors.dcF5F5F5,
          borderRadius: BorderRadius.circular(6.w),
          border: Border.all(
            color: isSelected ? DCColors.dc42CC8F : DCColors.dcF5F5F5,
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isSelected ? DCColors.dc42CC8F : DCColors.dc666666,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 2.w),
            Icon(
              isSelected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 16.w,
              color: isSelected ? DCColors.dc42CC8F : DCColors.dc999999,
            ),
          ],
        ),
      ),
    );
    return resultWidget;
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
