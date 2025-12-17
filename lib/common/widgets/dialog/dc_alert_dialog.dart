import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';

/// 按钮点击回调
typedef ButtonClickCallback = void Function();

/// 包含两个按钮的对话框
class DCAlertDialog extends StatelessWidget {
  const DCAlertDialog({
    Key? key,
    required this.message,
    required this.positiveText,
    this.onPositive,
    this.title = "",
    this.negativeText = "",
    this.onNegative,
    this.titleFontSize,
    this.titleColor,
    this.negativeTextFontSize,
    this.positiveTextFontSize,
    this.positiveTextColor,
    this.negativeTextColor,
    this.messageFontSize,
    this.messageColor,
    this.messageFontWeight,
    this.radius,
  }) : super(key: key);

  final String title;
  final String message;
  final String positiveText;
  final double? positiveTextFontSize;
  final Color? positiveTextColor;
  final String negativeText;
  final double? negativeTextFontSize;
  final Color? negativeTextColor;
  final double? titleFontSize;
  final Color? titleColor;
  final double? messageFontSize;
  final FontWeight? messageFontWeight;
  final Color? messageColor;
  final double? radius;

  /// “确定”按钮点击回调
  final ButtonClickCallback? onPositive;

  /// “取消”按钮点击回调
  final ButtonClickCallback? onNegative;

  /// 构造对话框按钮
  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        if (negativeText.isNotEmpty)
          Expanded(
            child: GestureDetector(
              child: Container(
                child: Text(
                  negativeText,
                  style: TextStyle(
                    fontSize: negativeTextFontSize ?? 16.w,
                    color: negativeTextColor ??
                        DCColors.tw000000.withValues(alpha: 0.5),
                    overflow: TextOverflow.ellipsis,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      width: 1.w,
                      color: DCColors.tw000000.withValues(alpha: 0.15),
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context, false);
                onNegative?.call();
              },
            ),
          ),
        Expanded(
          child: GestureDetector(
            child: Container(
              child: Text(
                positiveText,
                style: TextStyle(
                  fontSize: positiveTextFontSize ?? 16.w,
                  color: positiveTextColor ?? DCColors.twFF8000,
                  overflow: TextOverflow.ellipsis,
                ),
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.all(10.w),
            ),
            onTap: () {
              Navigator.pop(context, true);
              onPositive?.call();
            },
          ),
        ),
      ],
    );
  }

  /// 构造对话框内容
  Widget _buildContent(BuildContext context) {
    return ConstrainedBox(
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 20.w,
                horizontal: 16.w,
              ),
              child: Column(
                children: [
                  if (title.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: titleColor ??
                              DCColors.tw000000.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                          fontSize: titleFontSize ?? 16.w,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Text(
                    message,
                    style: TextStyle(
                      color: messageColor ??
                          DCColors.tw000000.withValues(alpha: 0.5),
                      fontSize: messageFontSize ?? 14.w,
                      fontWeight: messageFontWeight ?? FontWeight.normal,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              color: DCColors.tw000000.withValues(alpha: 0.15),
              height: 0.5.w,
            ),
            _buildButtons(context),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
        ),
        decoration: BoxDecoration(
          color: DCColors.twFFFFFF,
          borderRadius: BorderRadius.circular(radius ?? 2.w),
        ),
      ),
      constraints: BoxConstraints(
        maxWidth: ScreenUtil().screenWidth * 0.72,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: _buildContent(context),
      elevation: 0,
      backgroundColor: DCColors.tw00000000,
    );
  }
}
