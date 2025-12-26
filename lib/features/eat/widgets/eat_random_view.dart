import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/state/eat_state.dart';

/// 随机点餐
class EatRandomView extends StatefulWidget {
  const EatRandomView({super.key});

  @override
  State<EatRandomView> createState() => _EatRandomViewState();
}

class _EatRandomViewState extends State<EatRandomView>
    with EatLogicConsumerMixin<EatRandomView> {
  EatState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = Column(
      children: [
        _buildTitle(),
        _buildRandomButton(),
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
      '不想选择？我来帮你！',
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dc333333,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// 去随机点餐按钮
  Widget _buildRandomButton() {
    Widget resultWidget = Text(
      '随机点餐',
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
        logic.handleRandomClick();
      },
      child: resultWidget,
    );
    return resultWidget;
  }
}
