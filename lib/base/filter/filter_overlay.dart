import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';

/// 筛选遮罩层组件
class FilterOverlay extends StatelessWidget {
  /// 标题
  final String? title;

  /// 内容区域
  final Widget child;

  /// 是否显示重置按钮
  final bool showReset;

  /// 是否显示确定按钮
  final bool showConfirm;

  /// 重置按钮文本
  final String resetText;

  /// 确定按钮文本
  final String confirmText;

  /// 重置回调
  final VoidCallback? onReset;

  /// 确定回调
  final VoidCallback? onConfirm;

  /// 左侧标签栏（用于三级筛选）
  final List<FilterTabItem>? leftTabs;

  /// 当前选中的标签索引
  final int? selectedTabIndex;

  /// 标签切换回调
  final ValueChanged<int>? onTabChanged;


  /// 显示筛选遮罩层
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    bool showReset = true,
    bool showConfirm = true,
    String resetText = '重置',
    String confirmText = '确定',
    VoidCallback? onReset,
    VoidCallback? onConfirm,
    List<FilterTabItem>? leftTabs,
    int? selectedTabIndex,
    ValueChanged<int>? onTabChanged,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        Widget resultWidget = FilterOverlay(
          title: title,
          child: child,
          showReset: showReset,
          showConfirm: showConfirm,
          resetText: resetText,
          confirmText: confirmText,
          onReset: onReset,
          onConfirm: onConfirm,
          leftTabs: leftTabs,
          selectedTabIndex: selectedTabIndex,
          onTabChanged: onTabChanged,
        );
        return resultWidget;
      },
    );
  }

  /// 自定义高度（用于下拉显示）
  final double? customHeight;

  /// 关闭回调（用于下拉显示）
  final VoidCallback? onClose;

  const FilterOverlay({
    super.key,
    this.title,
    required this.child,
    this.showReset = true,
    this.showConfirm = true,
    this.resetText = '重置',
    this.confirmText = '确定',
    this.onReset,
    this.onConfirm,
    this.leftTabs,
    this.selectedTabIndex,
    this.onTabChanged,
    this.customHeight,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final height = customHeight ?? MediaQuery.of(context).size.height * 0.8;
    Widget resultWidget = Container(
      height: height,
      decoration: BoxDecoration(
        color: DCColors.dcFFFFFF,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.w),
          bottomRight: Radius.circular(16.w),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildContent(),
          ),
          if (showReset || showConfirm) _buildBottomButtons(),
        ],
      ),
    );
    return resultWidget;
  }

  /// 构建头部
  Widget _buildHeader() {
    Widget resultWidget = Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.w,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: DCColors.dcF5F5F5,
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          if (title != null) _buildTitle(),
          const Spacer(),
          Builder(
            builder: (context) => _buildCloseButton(context),
          ),
        ],
      ),
    );
    return resultWidget;
  }

  /// 构建标题
  Widget _buildTitle() {
    Widget resultWidget = Text(
      title!,
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dc333333,
        fontWeight: FontWeight.w500,
      ),
    );
    return resultWidget;
  }

  /// 构建关闭按钮
  Widget _buildCloseButton(BuildContext context) {
    Widget resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onClose != null) {
          onClose!();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Icon(
        Icons.close,
        size: 24.w,
        color: DCColors.dc666666,
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
          color: isSelected ? DCColors.dcECF3FF : DCColors.dcFFFFFF,
          border: Border(
            left: BorderSide(
              color: isSelected ? DCColors.dc006AFF : Colors.transparent,
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
                color: isSelected ? DCColors.dc006AFF : DCColors.dc333333,
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

  /// 构建底部按钮
  Widget _buildBottomButtons() {
    Widget resultWidget = Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.w,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: DCColors.dcF5F5F5,
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          if (showReset) _buildResetButton(),
          if (showReset && showConfirm) SizedBox(width: 12.w),
          if (showConfirm) Expanded(child: _buildConfirmButton()),
        ],
      ),
    );
    return resultWidget;
  }

  /// 构建重置按钮
  Widget _buildResetButton() {
    Widget resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onReset,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 12.w,
        ),
        decoration: BoxDecoration(
          color: DCColors.dcFFFFFF,
          border: Border.all(
            color: DCColors.dc999999,
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Text(
          resetText,
          style: TextStyle(
            fontSize: 16.sp,
            color: DCColors.dc666666,
          ),
        ),
      ),
    );
    return resultWidget;
  }

  /// 构建确定按钮
  Widget _buildConfirmButton() {
    Widget resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onConfirm,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 12.w,
        ),
        decoration: BoxDecoration(
          color: DCColors.dc006AFF,
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Center(
          child: Text(
            confirmText,
            style: TextStyle(
              fontSize: 16.sp,
              color: DCColors.dcFFFFFF,
              fontWeight: FontWeight.w500,
            ),
          ),
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

