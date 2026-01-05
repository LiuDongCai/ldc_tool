import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat_cook_random/header/eat_cook_random_header.dart';
import 'package:ldc_tool/features/eat_cook_random/logic/eat_cook_random_logic.dart';
import 'package:ldc_tool/features/eat_cook_random/state/eat_cook_random_state.dart';

class EatCookRandomView extends StatefulWidget {
  const EatCookRandomView({super.key});

  @override
  State<EatCookRandomView> createState() => EatCookRandomViewState();
}

class EatCookRandomViewState extends State<EatCookRandomView>
    with EatCookRandomLogicConsumerMixin<EatCookRandomView> {
  EatCookRandomState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // 几菜（默认3）
            _buildCookCountWidget(),
            // 几汤（默认1）
            _buildSoupCountWidget(),
          ],
        ),
        // 随机按钮
        _buildRandomButton(),
      ],
    );
    // 卡片布局
    resultWidget = Container(
      margin: EdgeInsets.only(
        top: 16.w,
        left: 16.w,
        right: 16.w,
      ),
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
    return resultWidget;
  }

  /// 构建标题
  Widget _buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        color: DCColors.dc333333,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// 几菜（默认3）
  Widget _buildCookCountWidget() {
    Widget resultWidget = GetBuilder<EatCookRandomLogic>(
      tag: logicTag,
      id: EatCookRandomUpdateId.cookCount,
      builder: (_) {
        return _buildMainTypeDropdown();
      },
    );
    resultWidget = Row(
      children: [
        resultWidget,
        _buildTitle('菜'),
      ],
    );
    resultWidget = Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 几菜（默认3）下拉框，0-10之间选择
  Widget _buildMainTypeDropdown() {
    Widget resultWidget = DropdownButton<int>(
      value: state.cookCount,
      isExpanded: false,
      underline: const SizedBox.shrink(),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: DCColors.dc333333,
      ),
      style: TextStyle(
        fontSize: 14.sp,
        color: DCColors.dc333333,
      ),
      dropdownColor: DCColors.dcFFFFFF,
      items: List.generate(11, (index) => index).map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(
            value.toString(),
            style: TextStyle(
              fontSize: 14.sp,
              color: DCColors.dc333333,
            ),
          ),
        );
      }).toList(),
      onChanged: (int? value) {
        if (value == null) return;
        logic.handleCookCountSelect(value);
      },
    );
    return resultWidget;
  }

  /// 几汤（默认1）
  Widget _buildSoupCountWidget() {
    Widget resultWidget = GetBuilder<EatCookRandomLogic>(
      tag: logicTag,
      id: EatCookRandomUpdateId.soupCount,
      builder: (_) {
        return _buildSectionDropdown();
      },
    );
    resultWidget = Row(
      children: [
        resultWidget,
        _buildTitle('汤'),
      ],
    );
    resultWidget = Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 几汤（默认1）下拉框，0-5之间选择
  Widget _buildSectionDropdown() {
    Widget resultWidget = DropdownButton<int>(
      value: state.soupCount,
      isExpanded: false,
      underline: const SizedBox.shrink(),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: DCColors.dc333333,
      ),
      style: TextStyle(
        fontSize: 14.sp,
        color: Colors.black,
      ),
      dropdownColor: DCColors.dcFFFFFF,
      items: List.generate(6, (index) => index).map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(
            value.toString(),
            style: TextStyle(
              fontSize: 14.sp,
              color: DCColors.dc333333,
            ),
          ),
        );
      }).toList(),
      onChanged: (int? value) {
        if (value == null) return;
        logic.handleSoupCountSelect(value);
      },
    );
    return resultWidget;
  }

  /// 构建随机按钮
  Widget _buildRandomButton() {
    Widget resultWidget = Text(
      '随机选择',
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
