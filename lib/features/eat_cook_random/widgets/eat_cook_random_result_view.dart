import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/common/widgets/image/dc_cached_image.dart';
import 'package:ldc_tool/features/eat_cook_random/header/eat_cook_random_header.dart';
import 'package:ldc_tool/features/eat_cook_random/model/eat_model.dart';
import 'package:ldc_tool/features/eat_cook_random/logic/eat_cook_random_logic.dart';
import 'package:ldc_tool/features/eat_cook_random/state/eat_cook_random_state.dart';

/// 随机点餐结果视图
class EatCookRandomResultView extends StatefulWidget {
  const EatCookRandomResultView({super.key});

  @override
  State<EatCookRandomResultView> createState() =>
      EatCookRandomResultViewState();
}

class EatCookRandomResultViewState extends State<EatCookRandomResultView>
    with EatCookRandomLogicConsumerMixin<EatCookRandomResultView> {
  EatCookRandomState get state => logic.state;

  /// 励志话语
  List<String> get motivationalWords => state.motivationalWords;

  /// 菜单item
  EatCookModel? get randomResult => state.randomResult;

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = GetBuilder<EatCookRandomLogic>(
      tag: logicTag,
      id: EatCookRandomUpdateId.randomResult,
      builder: (_) {
        if (randomResult == null) {
          return const SizedBox.shrink();
        }
        return _buildResultWidget();
      },
    );
    return resultWidget;
  }

  /// 构建结果视图
  Widget _buildResultWidget() {
    Widget resultWidget = _buildCookItem();
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
    resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        logic.handleCookDetailClick(randomResult);
      },
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 菜单item
  Widget _buildCookItem() {
    Widget resultWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCover(),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildInfo(),
        ),
      ],
    );
    resultWidget = Container(
      padding: EdgeInsets.all(10.w),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 封面
  Widget _buildCover() {
    Widget resultWidget = DCCachedImage(
      randomResult?.image ?? '',
      width: 90.w,
      height: 90.w,
    );
    resultWidget = ClipRRect(
      borderRadius: BorderRadius.circular(8.w),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 信息
  Widget _buildInfo() {
    return Text(
      randomResult?.name ?? '',
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dc333333,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// 构建结果类型
  Widget _buildResultType() {
    Widget resultWidget = Text(
      '今日菜单：',
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
