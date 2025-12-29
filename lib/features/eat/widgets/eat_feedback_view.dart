import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/state/eat_state.dart';

/// 反馈
class EatFeedbackView extends StatefulWidget {
  const EatFeedbackView({super.key});

  @override
  State<EatFeedbackView> createState() => _EatFeedbackViewState();
}

class _EatFeedbackViewState extends State<EatFeedbackView>
    with EatLogicConsumerMixin<EatFeedbackView> {
  EatState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = Column(
      children: [
        _buildTitle(),
        _buildRandomButton(context),
      ],
    );
    resultWidget = Container(
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
      '没有想吃的？',
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dc333333,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// 去随机点餐按钮
  Widget _buildRandomButton(BuildContext context) {
    Widget resultWidget = Text(
      '补充推荐',
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dcFFFFFF,
        fontWeight: FontWeight.w600,
      ),
    );
    resultWidget = Container(
      width: 230.w,
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
      onTap: () {
        logic.handleFeedbackClick(context);
      },
      child: resultWidget,
    );
    return resultWidget;
  }
}
