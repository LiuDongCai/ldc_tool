import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat/model/eat_model.dart';
import 'package:ldc_tool/features/eat_list/widgets/eat_list_item_view.dart';
import 'package:ldc_tool/features/eat_random/header/eat_random_header.dart';
import 'package:ldc_tool/features/eat_random/logic/eat_random_logic.dart';
import 'package:ldc_tool/features/eat_random/state/eat_random_state.dart';

/// 随机点餐结果视图
class EatRandomResultView extends StatefulWidget {
  const EatRandomResultView({super.key});

  @override
  State<EatRandomResultView> createState() => EatRandomResultViewState();
}

class EatRandomResultViewState extends State<EatRandomResultView>
    with EatRandomLogicConsumerMixin<EatRandomResultView> {
  EatRandomState get state => logic.state;

  /// 励志话语
  List<String> get motivationalWords => state.motivationalWords;

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = GetBuilder<EatRandomLogic>(
      tag: logicTag,
      id: EatRandomUpdateId.randomResult,
      builder: (_) {
        final randomResult = state.randomResult;
        if (randomResult == null) {
          return const SizedBox.shrink();
        }
        return _buildResultWidget(randomResult);
      },
    );
    return resultWidget;
  }

  /// 构建结果视图
  Widget _buildResultWidget(EatModel model) {
    Widget resultWidget = EatListItemView(model: model);
    // 卡片布局
    resultWidget = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: DCColors.dcFFFFFF,
        borderRadius: BorderRadius.circular(8.w),
        boxShadow: [
          BoxShadow(
            color: DCColors.dc516263.withAlpha(10),
            offset: Offset(0, 1.w), // 阴影xy轴偏移量
            blurRadius: 5.w, // 阴影模糊程度
            spreadRadius: -1.w, // 阴影扩散程度
          )
        ],
      ),
      child: resultWidget,
    );
    resultWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildResultType(),
        SizedBox(height: 10.w),
        resultWidget,
        SizedBox(height: 16.w),
        _buildMotivationalWords(),
      ],
    );
    resultWidget = Container(
      margin: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 36.w,
      ),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 构建结果类型
  Widget _buildResultType() {
    Widget resultWidget = Text(
      '今天推荐你吃：',
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dc42CC8F,
        fontWeight: FontWeight.w600,
      ),
    );
    return resultWidget;
  }

  /// 构建励志话语
  Widget _buildMotivationalWords() {
    final randomIndex = Random().nextInt(motivationalWords.length);
    final randomWord = motivationalWords[randomIndex];
    return Text(
      randomWord,
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dc42CC8F,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
