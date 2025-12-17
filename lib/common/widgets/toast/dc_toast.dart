import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/common/widgets/image/dc_image.dart';
import 'package:oktoast/oktoast.dart';

enum DCToastIconPosition {
  /// 左侧
  left,

  /// 顶部
  top,
}

/// 吐司组件
class DCToast {
  ToastFuture? _currentToast;

  /// 构造吐司布局
  Widget _buildLayout({
    String? message,
    Widget? messageWidget,
    String? subMessage,
    Widget? subMessageWidget,
    String? icon,
    Widget? iconWidget,
    TextAlign? textAlign,
    DCToastIconPosition iconPosition = DCToastIconPosition.left,
    bool plain = false,
  }) {
    // 构建对应的 icon widget
    Widget? _iconWidget;
    if (icon != null) {
      _iconWidget = icon.endsWith('.svg')
          ? SvgPicture.asset(
              icon,
              height: 24.w,
              width: 24.w,
            )
          : DCImage.asset(
              icon,
              height: 24.w,
              width: 24.w,
            );
    }
    if (iconWidget != null) {
      _iconWidget = SizedBox(width: 24.w, height: 24.w, child: iconWidget);
    }

    Widget messageRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // icon widget 的位置在左侧
        if (_iconWidget != null && DCToastIconPosition.left == iconPosition)
          Padding(
            child: _iconWidget,
            padding: EdgeInsets.only(right: 8.w),
          ),
        if (message != null)
          Flexible(
            child: Transform.translate(
              // 需要视觉调整向上偏移一点，否则会感觉文字偏下
              offset: Offset(0, -0.5.w),
              child: Text(
                message,
                textAlign: textAlign,
                style: TextStyle(
                  color: DCColors.twFFFFFF,
                  fontSize: 16.sp,
                  height: 26 / 16,
                ),
              ),
            ),
          ),
        if (messageWidget != null) Flexible(child: messageWidget)
      ],
      mainAxisSize: MainAxisSize.min,
    );
    // icon widget 的位置在顶部
    bool showTopIcon =
        _iconWidget != null && DCToastIconPosition.top == iconPosition;

    Widget resultWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showTopIcon) SizedBox(height: 5.w),
        if (showTopIcon) _iconWidget,
        if (showTopIcon) SizedBox(height: 4.w),
        messageRow,
        if (subMessage != null) _buildSubMessage(message: subMessage),
        if (subMessageWidget != null) subMessageWidget,
        if (showTopIcon) SizedBox(height: 3.w),
      ],
    );

    // 纯展示模式：直接返回内容布局（不包裹外层 Container）
    if (plain) {
      return resultWidget;
    }
    return Container(
      child: resultWidget,
      decoration: BoxDecoration(
        color: DCColors.tw000000.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(6.w),
        boxShadow: [
          BoxShadow(
            color: DCColors.tw000000.withValues(alpha: 0.04),
            offset: Offset(0, 6.w), // 阴影xy轴偏移量
            blurRadius: 32.w, // 阴影模糊程度
            spreadRadius: 5, // 阴影扩散程度
          ),
          BoxShadow(
            color: DCColors.tw000000.withValues(alpha: 0.04),
            offset: Offset(0, 16.w), // 阴影xy轴偏移量
            blurRadius: 24.w, // 阴影模糊程度
            spreadRadius: 2, // 阴影扩散程度
          ),
          BoxShadow(
            color: DCColors.tw000000.withValues(alpha: 0.08),
            offset: Offset(0, 8.w), // 阴影xy轴偏移量
            blurRadius: 10.w, // 阴影模糊程度
            spreadRadius: -5, // 阴影扩散程度
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 9.w,
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
    );
  }

  /// 构建副标题widget
  Widget _buildSubMessage({required String message}) {
    return Text(
      message,
      style: TextStyle(
        color: DCColors.twFFFFFF,
        fontSize: 16.sp,
        height: 26 / 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// 显示吐司
  DCToast.show({
    String? message,
    Widget? messageWidget,
    String? subMessage,
    Widget? subMessageWidget,
    String? icon,
    Widget? iconWidget,
    DCToastIconPosition iconPosition = DCToastIconPosition.left,
    BuildContext? context,
    Duration duration = const Duration(seconds: 2),
    ToastPosition position = ToastPosition.center,
    bool dismissOther = false,
    bool? handleTouch,
    TextAlign? textAlign,
    bool plain = false,
  }) {
    _currentToast = showToastWidget(
      _buildLayout(
        message: message,
        messageWidget: messageWidget,
        subMessage: subMessage,
        subMessageWidget: subMessageWidget,
        icon: icon,
        iconWidget: iconWidget,
        iconPosition: iconPosition,
        textAlign: textAlign,
        plain: plain,
      ),
      context: context,
      duration: duration,
      position: position,
      dismissOtherToast: dismissOther,
      handleTouch: handleTouch,
    );
  }

  /// 显示带耐克标的成功吐司
  DCToast.success({
    required String message,
    Duration duration = const Duration(seconds: 2),
    DCToastIconPosition iconPosition = DCToastIconPosition.left,
    TextAlign? textAlign,
  }) {
    _currentToast = showToastWidget(
      _buildLayout(
        message: message,
        iconPosition: iconPosition,
        textAlign: textAlign,
        iconWidget: Icon(
          Icons.check,
          size: 24.w,
          color: DCColors.twFFFFFF,
        ),
      ),
      duration: duration,
    );
  }

  /// 显示带叉的失败吐司
  DCToast.error({
    required String message,
    Duration duration = const Duration(seconds: 2),
    TextAlign? textAlign,
    DCToastIconPosition iconPosition = DCToastIconPosition.left,
  }) {
    _currentToast = showToastWidget(
      _buildLayout(
        message: message,
        iconPosition: iconPosition,
        textAlign: textAlign,
        iconWidget: Icon(
          Icons.close_outlined,
          size: 24.w,
          color: DCColors.twFFFFFF,
        ),
      ),
      duration: duration,
    );
  }

  /// 隐藏当前吐司
  void cancel() {
    _currentToast?.dismiss(showAnim: false);
  }

  /// 隐藏所有吐司
  static void cancelAll() {
    dismissAllToast(showAnim: false);
  }
}
