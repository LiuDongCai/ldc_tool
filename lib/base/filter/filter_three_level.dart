import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/base/filter/dc_filter_dropdown.dart';
import 'package:ldc_tool/base/filter/model/dc_filter_model.dart';
import 'package:ldc_tool/base/filter/filter_overlay.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';

/// 三级筛选组件
class FilterThreeLevel extends StatefulWidget {
  /// 筛选数据
  final ThreeLevelFilterData data;

  /// 选择回调
  final ValueChanged<ThreeLevelFilterData>? onSelected;

  /// 左侧标签列表
  final List<FilterTabItem>? leftTabs;

  const FilterThreeLevel({
    super.key,
    required this.data,
    this.onSelected,
    this.leftTabs,
  });

  /// 在指定位置下方显示三级筛选弹窗
  static Future<ThreeLevelFilterData?> showBelow({
    required BuildContext context,
    required RenderBox anchorBox,
    required ThreeLevelFilterData data,
    List<FilterTabItem>? leftTabs,
    ValueChanged<ThreeLevelFilterData>? onSelected,
    String? filterType,
  }) async {
    ThreeLevelFilterData? result;
    await DCFilterDropdown.showBelow<ThreeLevelFilterData>(
      context: context,
      anchorBox: anchorBox,
      filterType: filterType,
      leftTabs: leftTabs,
      selectedTabIndex: 0,
      // onReset: () {
      //   result = data.copyWith(
      //     selectedLevel1Id: null,
      //     selectedLevel2Id: null,
      //     selectedLevel3Id: null,
      //   );
      // },
      // onConfirm: () {},
      child: FilterThreeLevel(
        data: data,
        leftTabs: leftTabs,
        onSelected: (newData) {
          result = newData;
        },
      ),
    );
    return result;
  }

  @override
  State<FilterThreeLevel> createState() => _FilterThreeLevelState();
}

class _FilterThreeLevelState extends State<FilterThreeLevel> {
  late ThreeLevelFilterData _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = Column(
      children: [
        _buildTopSection(),
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
    return resultWidget;
  }

  /// 构建顶部区域（城市选择）
  Widget _buildTopSection() {
    Widget resultWidget = Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.w,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: DCColors.dcF5F5F5,
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildUnlimitedOption(),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildLevel1Options(),
          ),
        ],
      ),
    );
    return resultWidget;
  }

  /// 构建"不限"选项
  Widget _buildUnlimitedOption() {
    final isSelected = _data.selectedLevel1Id == null;
    Widget resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _data = _data.copyWith(
            selectedLevel1Id: null,
            selectedLevel2Id: null,
            selectedLevel3Id: null,
          );
        });
        widget.onSelected?.call(_data);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.w,
        ),
        decoration: BoxDecoration(
          color: isSelected ? DCColors.dcECF3FF : DCColors.dcFFFFFF,
          border: Border.all(
            color: isSelected ? DCColors.dc006AFF : DCColors.dcF5F5F5,
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(6.w),
        ),
        child: Row(
          children: [
            if (isSelected)
              Icon(
                Icons.check,
                size: 16.w,
                color: DCColors.dc006AFF,
              ),
            if (isSelected) SizedBox(width: 4.w),
            Text(
              '不限',
              style: TextStyle(
                fontSize: 14.sp,
                color: isSelected ? DCColors.dc006AFF : DCColors.dc666666,
              ),
            ),
          ],
        ),
      ),
    );
    return resultWidget;
  }

  /// 构建第一级选项（城市列表）
  Widget _buildLevel1Options() {
    Widget resultWidget = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            _data.level1.map((option) => _buildLevel1Option(option)).toList(),
      ),
    );
    return resultWidget;
  }

  /// 构建第一级选项项
  Widget _buildLevel1Option(DCFilterOption option) {
    final isSelected = _data.selectedLevel1Id == option.id;
    Widget resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _data = _data.copyWith(
            selectedLevel1Id: option.id,
            selectedLevel2Id: null,
            selectedLevel3Id: null,
          );
        });
        widget.onSelected?.call(_data);
      },
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.w,
        ),
        decoration: BoxDecoration(
          color: isSelected ? DCColors.dcECF3FF : DCColors.dcFFFFFF,
          border: Border.all(
            color: isSelected ? DCColors.dc006AFF : DCColors.dcF5F5F5,
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(6.w),
        ),
        child: Row(
          children: [
            if (isSelected)
              Icon(
                Icons.check,
                size: 16.w,
                color: DCColors.dc006AFF,
              ),
            if (isSelected) SizedBox(width: 4.w),
            Text(
              option.name,
              style: TextStyle(
                fontSize: 14.sp,
                color: isSelected ? DCColors.dc006AFF : DCColors.dc666666,
              ),
            ),
          ],
        ),
      ),
    );
    return resultWidget;
  }

  /// 构建内容区域（区域和生活圈）
  Widget _buildContent() {
    if (_data.selectedLevel1Id == null) {
      return const SizedBox.shrink();
    }

    Widget resultWidget = Row(
      children: [
        if (_data.level2 != null) _buildLevel2Column(),
        if (_data.level2 != null && _data.level3 != null) SizedBox(width: 1.w),
        if (_data.level3 != null) Expanded(child: _buildLevel3Column()),
      ],
    );
    return resultWidget;
  }

  /// 构建第二级列（区域）
  Widget _buildLevel2Column() {
    Widget resultWidget = Container(
      width: 150.w,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: DCColors.dcF5F5F5,
            width: 1.w,
          ),
        ),
      ),
      child: ListView.builder(
        itemCount: _data.level2!.length,
        itemBuilder: (context, index) {
          return _buildLevel2Option(_data.level2![index]);
        },
      ),
    );
    return resultWidget;
  }

  /// 构建第二级选项
  Widget _buildLevel2Option(DCFilterOption option) {
    final isSelected = _data.selectedLevel2Id == option.id;
    Widget resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _data = _data.copyWith(
            selectedLevel2Id: option.id,
            selectedLevel3Id: null,
          );
        });
        widget.onSelected?.call(_data);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 14.w,
        ),
        decoration: BoxDecoration(
          color: isSelected ? DCColors.dcECF3FF : DCColors.dcFFFFFF,
          border: Border(
            left: BorderSide(
              color: isSelected ? DCColors.dc006AFF : Colors.transparent,
              width: 3.w,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isSelected ? DCColors.dc006AFF : DCColors.dc333333,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                size: 16.w,
                color: DCColors.dc006AFF,
              ),
          ],
        ),
      ),
    );
    return resultWidget;
  }

  /// 构建第三级列（生活圈）
  Widget _buildLevel3Column() {
    if (_data.selectedLevel2Id == null) {
      return const SizedBox.shrink();
    }

    final selectedLevel2 = _data.level2!.firstWhere(
      (item) => item.id == _data.selectedLevel2Id,
      orElse: () => _data.level2!.first,
    );

    final level3Options = selectedLevel2.children ?? _data.level3 ?? [];

    Widget resultWidget = ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: level3Options.length,
      itemBuilder: (context, index) {
        return _buildLevel3Option(level3Options[index]);
      },
    );
    return resultWidget;
  }

  /// 构建第三级选项
  Widget _buildLevel3Option(DCFilterOption option) {
    final isSelected = _data.selectedLevel3Id == option.id;
    Widget resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _data = _data.copyWith(
            selectedLevel3Id: option.id,
          );
        });
        widget.onSelected?.call(_data);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.w,
        ),
        margin: EdgeInsets.only(bottom: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? DCColors.dcECF3FF : DCColors.dcF5F5F5,
          border: Border.all(
            color: isSelected ? DCColors.dc006AFF : DCColors.dcF5F5F5,
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isSelected ? DCColors.dc006AFF : DCColors.dc666666,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                size: 16.w,
                color: DCColors.dc006AFF,
              ),
          ],
        ),
      ),
    );
    return resultWidget;
  }
}
