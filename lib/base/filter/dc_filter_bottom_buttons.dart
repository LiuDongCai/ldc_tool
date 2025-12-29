import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/base/filter/dc_filter_dropdown.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';

/// 筛选底部按钮组件
class DCFilterBottomButtons extends StatefulWidget {
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

  const DCFilterBottomButtons({
    super.key,
    this.showReset = true,
    this.showConfirm = true,
    this.resetText = '重置',
    this.confirmText = '确定',
    this.onReset,
    this.onConfirm,
  });

  @override
  State<DCFilterBottomButtons> createState() => _DCFilterBottomButtonsState();
}

class _DCFilterBottomButtonsState extends State<DCFilterBottomButtons> {
  @override
  Widget build(BuildContext context) {
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
          if (widget.showReset) _buildResetButton(),
          if (widget.showReset && widget.showConfirm) SizedBox(width: 12.w),
          if (widget.showConfirm)
            Expanded(
              child: _buildConfirmButton(),
            ),
        ],
      ),
    );
    return resultWidget;
  }

  /// 构建重置按钮
  Widget _buildResetButton() {
    Widget resultWidget = Text(
      widget.resetText,
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dc666666,
      ),
    );
    resultWidget = Container(
      width: 100.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: DCColors.dcFFFFFF,
        border: Border.all(
          color: DCColors.dc999999,
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(8.w),
      ),
      alignment: Alignment.center,
      child: resultWidget,
    );
    resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onReset,
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 构建确定按钮
  Widget _buildConfirmButton() {
    Widget resultWidget = Text(
      widget.confirmText,
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dcFFFFFF,
        fontWeight: FontWeight.w500,
      ),
    );
    resultWidget = Container(
      height: 44.w,
      decoration: BoxDecoration(
        color: DCFilterDropdown.themeColor,
        borderRadius: BorderRadius.circular(8.w),
      ),
      alignment: Alignment.center,
      child: resultWidget,
    );
    resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onConfirm,
      child: resultWidget,
    );
    return resultWidget;
  }
}
