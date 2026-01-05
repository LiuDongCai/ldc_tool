import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/state/eat_state.dart';

/// 家常菜
class EatCookView extends StatefulWidget {
  const EatCookView({super.key});

  @override
  State<EatCookView> createState() => _EatCookViewState();
}

class _EatCookViewState extends State<EatCookView>
    with EatLogicConsumerMixin<EatCookView> {
  EatState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = Column(
      children: [
        _buildTitle(),
        _buildCookButton(),
      ],
    );
    resultWidget = Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: 16.w,
        left: 16.w,
        right: 16.w,
      ),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 标题
  Widget _buildTitle() {
    return Text(
      '点菜点菜！！！',
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dc333333,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// 按钮
  Widget _buildCookButton() {
    Widget resultWidget = Text(
      '开始点菜',
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dcFFFFFF,
        fontWeight: FontWeight.w600,
      ),
    );
    resultWidget = Container(
      width: 200.w,
      height: 44.w,
      margin: EdgeInsets.only(
        top: 16.w,
        bottom: 16.w,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: DCColors.dc42CC8F,
        borderRadius: BorderRadius.circular(26.w),
      ),
      child: resultWidget,
    );
    resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: logic.handleCookRandomClick,
      child: resultWidget,
    );
    return resultWidget;
  }
}
