import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/features/eat_list/header/eat_list_header.dart';
import 'package:ldc_tool/features/eat_list/state/eat_list_state.dart';
import 'package:ldc_tool/gen/assets.gen.dart';

/// 右下角悬浮按钮
class EatListFloatView extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  EatListFloatView({super.key});

  @override
  State<EatListFloatView> createState() => _EatListFloatViewState();
}

class _EatListFloatViewState extends State<EatListFloatView>
    with EatListLogicConsumerMixin<EatListFloatView> {
  EatListState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFeedbackWidget(),
        SizedBox(height: 16.w),
        _buildRandomWidget(),
      ],
    );
    return resultWidget;
  }

  /// 随机选择当前列表的餐馆
  Widget _buildRandomWidget() {
    Widget resultWidget = Image.asset(
      Assets.image.eatList.eatListRandom.path,
      width: 45.w,
      height: 45.w,
    );
    resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        logic.handleRandomCurrentEatList(context);
      },
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 随机选择当前列表的餐馆
  Widget _buildFeedbackWidget() {
    Widget resultWidget = Image.asset(
      Assets.image.eatList.etListFeedback.path,
      width: 45.w,
      height: 45.w,
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
