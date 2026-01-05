import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/logic/eat_logic_random_feedback.dart';
import 'package:ldc_tool/features/eat/state/eat_state.dart';

/// 随机点餐和反馈
class EatRandomFeedbackView extends StatefulWidget {
  const EatRandomFeedbackView({super.key});

  @override
  State<EatRandomFeedbackView> createState() => _EatRandomFeedbackViewState();
}

class _EatRandomFeedbackViewState extends State<EatRandomFeedbackView>
    with EatLogicConsumerMixin<EatRandomFeedbackView> {
  EatState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRandomContent(),
        _buildFeedbackContent(context),
      ],
    );
    resultWidget = Container(
      margin: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
      ),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 随机点餐
  Widget _buildRandomContent() {
    Widget resultWidget = Column(
      children: [
        _buildTitle('不想选择吗？'),
        _buildButton(
          title: '随机点餐',
          onTap: () {
            logic.handleRandomClick();
          },
        ),
      ],
    );
    return resultWidget;
  }

  /// 反馈
  Widget _buildFeedbackContent(BuildContext context) {
    Widget resultWidget = Column(
      children: [
        _buildTitle('没有想吃的？'),
        _buildButton(
          title: '补充推荐',
          onTap: () {
            logic.handleFeedbackClick(context);
          },
        ),
      ],
    );
    return resultWidget;
  }

  /// 标题
  Widget _buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dc333333,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// 按钮
  Widget _buildButton({
    required String title,
    required Function() onTap,
  }) {
    Widget resultWidget = Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dcFFFFFF,
        fontWeight: FontWeight.w600,
      ),
    );
    resultWidget = Container(
      width: 150.w,
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
      onTap: onTap,
      child: resultWidget,
    );
    return resultWidget;
  }
}
