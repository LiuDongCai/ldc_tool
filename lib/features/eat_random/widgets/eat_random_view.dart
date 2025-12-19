import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat_random/header/eat_random_header.dart';
import 'package:ldc_tool/features/eat_random/logic/eat_random_logic.dart';
import 'package:ldc_tool/features/eat_random/state/eat_random_state.dart';

class EatRandomView extends StatefulWidget {
  const EatRandomView({super.key});

  @override
  State<EatRandomView> createState() => EatRandomViewState();
}

class EatRandomViewState extends State<EatRandomView>
    with EatRandomLogicConsumerMixin<EatRandomView> {
  EatRandomState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 随机选择前提-大类，选择一个，默认全部
        _buildMainTypeWidget(),
        // 随机选择前提-区域，选择一个，默认福田
        _buildSectionWidget(),
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

  /// 构建大类选择,下拉选择框，默认选中全部
  Widget _buildMainTypeWidget() {
    Widget resultWidget = GetBuilder<EatRandomLogic>(
      tag: logicTag,
      id: EatRandomUpdateId.mainType,
      builder: (_) {
        return _buildMainTypeDropdown();
      },
    );
    resultWidget = Row(
      children: [
        _buildTitle('品类:'),
        SizedBox(width: 22.w),
        resultWidget,
      ],
    );
    resultWidget = Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 构建大类下拉选择框
  Widget _buildMainTypeDropdown() {
    Widget resultWidget = DropdownButton<EatMainType>(
      value: state.mainType,
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
      items: EatMainType.values.map((EatMainType type) {
        return DropdownMenuItem<EatMainType>(
          value: type,
          child: Text(
            type.name,
            style: TextStyle(
              fontSize: 14.sp,
              color: DCColors.dc333333,
            ),
          ),
        );
      }).toList(),
      onChanged: (EatMainType? value) {
        logic.handleMainTypeClick(value);
      },
    );
    return resultWidget;
  }

  /// 构建区域选择,下拉选择框，默认选中福田
  Widget _buildSectionWidget() {
    Widget resultWidget = GetBuilder<EatRandomLogic>(
      tag: logicTag,
      id: EatRandomUpdateId.section,
      builder: (_) {
        return _buildSectionDropdown();
      },
    );
    resultWidget = Row(
      children: [
        _buildTitle('区域:'),
        SizedBox(width: 22.w),
        resultWidget,
      ],
    );
    resultWidget = Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 构建区域下拉选择框
  Widget _buildSectionDropdown() {
    Widget resultWidget = DropdownButton<SectionType>(
      value: state.section,
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
      items: SectionType.values.map((SectionType type) {
        return DropdownMenuItem<SectionType>(
          value: type,
          child: Text(
            type.name,
            style: TextStyle(
              fontSize: 14.sp,
              color: DCColors.dc333333,
            ),
          ),
        );
      }).toList(),
      onChanged: (SectionType? value) {
        logic.handleSectionClick(value);
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
