import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';

/// 筛选遮罩层组件
class FilterOverlay extends StatelessWidget {
  /// 内容区域
  final Widget child;

  /// 左侧标签栏（用于三级筛选）
  final List<FilterTabItem>? leftTabs;

  /// 当前选中的标签索引
  final int? selectedTabIndex;

  /// 标签切换回调
  final ValueChanged<int>? onTabChanged;

  const FilterOverlay({
    super.key,
    required this.child,
    this.leftTabs,
    this.selectedTabIndex,
    this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = Container(
      decoration: BoxDecoration(
        color: DCColors.dcFFFFFF,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.w),
          bottomRight: Radius.circular(8.w),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildContent(),
        ],
      ),
    );
    return resultWidget;
  }

  /// 构建内容区域
  Widget _buildContent() {
    Widget resultWidget = Row(
      children: [
        if (leftTabs != null && leftTabs!.isNotEmpty) _buildLeftTabs(),
        Expanded(
          child: child,
        ),
      ],
    );
    return resultWidget;
  }

  /// 构建左侧标签栏
  Widget _buildLeftTabs() {
    Widget resultWidget = Container(
      width: 100.w,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: DCColors.dcF5F5F5,
            width: 1.w,
          ),
        ),
      ),
      child: ListView.builder(
        itemCount: leftTabs!.length,
        itemBuilder: (context, index) {
          return _buildTabItem(
            item: leftTabs![index],
            index: index,
          );
        },
      ),
    );
    return resultWidget;
  }

  /// 构建标签项
  Widget _buildTabItem({
    required FilterTabItem item,
    required int index,
  }) {
    final isSelected = selectedTabIndex == index;
    Widget resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTabChanged?.call(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 16.w,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? DCColors.dc42CC8F.withValues(alpha: 0.1)
              : DCColors.dcFFFFFF,
          border: Border(
            left: BorderSide(
              color: isSelected ? DCColors.dc42CC8F : Colors.transparent,
              width: 3.w,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: TextStyle(
                fontSize: 14.sp,
                color: isSelected ? DCColors.dc42CC8F : DCColors.dc333333,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            if (item.badge != null) _buildBadge(item.badge!),
          ],
        ),
      ),
    );
    return resultWidget;
  }

  /// 构建角标
  Widget _buildBadge(String badge) {
    Widget resultWidget = Container(
      margin: EdgeInsets.only(top: 4.w),
      padding: EdgeInsets.symmetric(
        horizontal: 6.w,
        vertical: 2.w,
      ),
      decoration: BoxDecoration(
        color: DCColors.dcF01800,
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Text(
        badge,
        style: TextStyle(
          fontSize: 10.sp,
          color: DCColors.dcFFFFFF,
        ),
      ),
    );
    return resultWidget;
  }
}

/// 筛选标签项
class FilterTabItem {
  /// 标题
  final String title;

  /// 角标（如：NEW）
  final String? badge;

  FilterTabItem({
    required this.title,
    this.badge,
  });
}
