import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/base/filter/dc_filter.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';

/// 筛选项组件
class DCFilterTabItem extends StatefulWidget {
  /// 标题
  final String title;

  /// 是否选中（有选中数据）
  final bool isSelected;

  /// 是否打开（弹窗打开状态）
  final bool isOpen;

  /// 点击回调
  final VoidCallback onTap;

  /// 宽度
  final double? width;

  const DCFilterTabItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.isOpen,
    required this.onTap,
    this.width,
  });

  @override
  State<DCFilterTabItem> createState() => _DCFilterTabItemState();
}

class _DCFilterTabItemState extends State<DCFilterTabItem>
    with SingleTickerProviderStateMixin {
  /// 箭头旋转动画控制器
  late AnimationController _arrowAnimationController;

  /// 箭头旋转动画
  late Animation<double> _arrowRotationAnimation;

  late CurvedAnimation _arrowCurvedAnimation;

  @override
  void initState() {
    super.initState();
    _arrowAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _arrowCurvedAnimation = CurvedAnimation(
      parent: _arrowAnimationController,
      curve: Curves.easeInOut,
    );
    _arrowRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5, // 0.5 turns = 180度，从向下旋转到向上
    ).animate(_arrowCurvedAnimation);
    // 根据初始状态设置动画值
    if (widget.isOpen) {
      _arrowAnimationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(DCFilterTabItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!mounted) return;
    // 当 isOpen 状态变化时，播放动画
    if (oldWidget.isOpen != widget.isOpen) {
      if (widget.isOpen) {
        _arrowAnimationController.forward();
      } else {
        _arrowAnimationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _arrowAnimationController.dispose();
    _arrowCurvedAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 如果弹窗打开，使用选中样式；否则根据是否有选中数据决定
    final isActive = widget.isOpen || widget.isSelected;

    Widget resultWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 12.sp,
              color: isActive ? DCFilterDropdown.themeColor : DCColors.dc666666,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 2.w),
        RotationTransition(
          turns: _arrowRotationAnimation,
          child: Icon(
            Icons.keyboard_arrow_down,
            size: 16.w,
            color: isActive ? DCFilterDropdown.themeColor : DCColors.dc999999,
          ),
        ),
      ],
    );
    resultWidget = Container(
      alignment: Alignment.center,
      width: widget.width ?? 60.w,
      padding: EdgeInsets.symmetric(
        vertical: 6.w,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? DCFilterDropdown.themeColor.withValues(alpha: 0.1)
            : DCColors.dcF5F5F5,
        borderRadius: BorderRadius.circular(6.w),
        border: Border.all(
          color: isActive ? DCFilterDropdown.themeColor : DCColors.dcF5F5F5,
          width: 1.w,
        ),
      ),
      child: resultWidget,
    );
    resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap,
      child: resultWidget,
    );
    return resultWidget;
  }
}
