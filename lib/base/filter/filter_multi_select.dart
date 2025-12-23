import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/base/filter/filter_dropdown.dart';
import 'package:ldc_tool/base/filter/filter_model.dart';
import 'package:ldc_tool/base/filter/filter_overlay.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';

/// 多选筛选组件
class FilterMultiSelect extends StatefulWidget {
  /// 筛选组列表
  final List<FilterGroup> groups;

  /// 选择回调
  final ValueChanged<List<String>>? onSelected;

  const FilterMultiSelect({
    super.key,
    required this.groups,
    this.onSelected,
  });

  /// 显示多选筛选弹窗（底部弹出）
  static Future<List<String>> show({
    required BuildContext context,
    required List<FilterGroup> groups,
    List<String>? selectedIds,
    String? title,
    ValueChanged<List<String>>? onSelected,
  }) async {
    List<String> result = selectedIds ?? [];
    await FilterOverlay.show(
      context: context,
      title: title,
      onReset: () {
        result = [];
      },
      onConfirm: () {
        Navigator.of(context).pop(result);
      },
      child: FilterMultiSelect(
        groups: groups,
        onSelected: (ids) {
          result = ids;
        },
      ),
    );
    return result;
  }

  /// 在指定位置下方显示多选筛选弹窗
  static Future<List<String>> showBelow({
    required BuildContext context,
    required RenderBox anchorBox,
    required List<FilterGroup> groups,
    List<String>? selectedIds,
    String? title,
    ValueChanged<List<String>>? onSelected,
    String? filterType,
  }) async {
    List<String> result = selectedIds ?? [];
    await FilterDropdown.showBelow<List<String>>(
      context: context,
      anchorBox: anchorBox,
      title: title,
      maxHeight: 400.w,
      filterType: filterType,
      onReset: () {
        result = [];
      },
      onConfirm: () {},
      child: FilterMultiSelect(
        groups: groups,
        onSelected: (ids) {
          result = ids;
        },
      ),
    );
    return result;
  }

  @override
  State<FilterMultiSelect> createState() => _FilterMultiSelectState();
}

class _FilterMultiSelectState extends State<FilterMultiSelect> {
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    for (var group in widget.groups) {
      for (var option in group.options) {
        if (option.isSelected) {
          _selectedIds.add(option.id);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.groups.map((group) => _buildGroup(group)).toList(),
      ),
    );
    return resultWidget;
  }

  /// 构建筛选组
  Widget _buildGroup(FilterGroup group) {
    Widget resultWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGroupTitle(group.title),
        SizedBox(height: 12.w),
        _buildGroupOptions(group),
        SizedBox(height: 24.w),
      ],
    );
    return resultWidget;
  }

  /// 构建组标题
  Widget _buildGroupTitle(String title) {
    Widget resultWidget = Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dc333333,
        fontWeight: FontWeight.w500,
      ),
    );
    return resultWidget;
  }

  /// 构建组选项
  Widget _buildGroupOptions(FilterGroup group) {
    Widget resultWidget = Wrap(
      spacing: 12.w,
      runSpacing: 12.w,
      children: group.options.map((option) => _buildOption(option)).toList(),
    );
    return resultWidget;
  }

  /// 构建选项
  Widget _buildOption(FilterOption option) {
    final isSelected = _selectedIds.contains(option.id);
    Widget resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedIds.remove(option.id);
          } else {
            _selectedIds.add(option.id);
          }
        });
        widget.onSelected?.call(_selectedIds.toList());
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 10.w,
        ),
        decoration: BoxDecoration(
          color: isSelected ? DCColors.dcECF3FF : DCColors.dcF5F5F5,
          border: Border.all(
            color: isSelected ? DCColors.dc006AFF : DCColors.dcF5F5F5,
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Text(
          option.name,
          style: TextStyle(
            fontSize: 14.sp,
            color: isSelected ? DCColors.dc006AFF : DCColors.dc666666,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
    return resultWidget;
  }
}
