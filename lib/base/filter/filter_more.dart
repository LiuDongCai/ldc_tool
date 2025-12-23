import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/base/filter/filter_dropdown.dart';
import 'package:ldc_tool/base/filter/filter_model.dart';
import 'package:ldc_tool/base/filter/filter_overlay.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';

/// 更多筛选组件（组合多个筛选条件）
class FilterMore extends StatefulWidget {
  /// 筛选组列表
  final List<FilterGroup> groups;

  /// 选择回调
  final ValueChanged<Map<String, List<String>>>? onSelected;

  const FilterMore({
    super.key,
    required this.groups,
    this.onSelected,
  });

  /// 显示更多筛选弹窗（底部弹出）
  static Future<Map<String, List<String>>> show({
    required BuildContext context,
    required List<FilterGroup> groups,
    Map<String, List<String>>? selectedValues,
    String? title,
    ValueChanged<Map<String, List<String>>>? onSelected,
  }) async {
    Map<String, List<String>> result = selectedValues ?? {};
    await FilterOverlay.show(
      context: context,
      title: title,
      onReset: () {
        result = {};
      },
      onConfirm: () {
        Navigator.of(context).pop(result);
      },
      child: FilterMore(
        groups: groups,
        onSelected: (values) {
          result = values;
        },
      ),
    );
    return result;
  }

  /// 在指定位置下方显示更多筛选弹窗
  static Future<Map<String, List<String>>> showBelow({
    required BuildContext context,
    required RenderBox anchorBox,
    required List<FilterGroup> groups,
    Map<String, List<String>>? selectedValues,
    String? title,
    ValueChanged<Map<String, List<String>>>? onSelected,
    String? filterType,
  }) async {
    Map<String, List<String>> result = selectedValues ?? {};
    await FilterDropdown.showBelow<Map<String, List<String>>>(
      context: context,
      anchorBox: anchorBox,
      title: title,
      maxHeight: 400.w,
      filterType: filterType,
      onReset: () {
        result = {};
      },
      onConfirm: () {},
      child: FilterMore(
        groups: groups,
        onSelected: (values) {
          result = values;
        },
      ),
    );
    return result;
  }

  @override
  State<FilterMore> createState() => _FilterMoreState();
}

class _FilterMoreState extends State<FilterMore> {
  final Map<String, Set<String>> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    for (var group in widget.groups) {
      final selectedSet = <String>{};
      for (var option in group.options) {
        if (option.isSelected) {
          selectedSet.add(option.id);
        }
      }
      if (selectedSet.isNotEmpty) {
        _selectedIds[group.title] = selectedSet;
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
      children: group.options.map((option) => _buildOption(group, option)).toList(),
    );
    return resultWidget;
  }

  /// 构建选项
  Widget _buildOption(FilterGroup group, FilterOption option) {
    final selectedSet = _selectedIds[group.title] ?? <String>{};
    final isSelected = selectedSet.contains(option.id);
    Widget resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          final selectedSet = _selectedIds[group.title] ?? <String>{};
          if (isSelected) {
            selectedSet.remove(option.id);
            if (selectedSet.isEmpty) {
              _selectedIds.remove(group.title);
            } else {
              _selectedIds[group.title] = selectedSet;
            }
          } else {
            selectedSet.add(option.id);
            _selectedIds[group.title] = selectedSet;
          }
        });
        _notifySelected();
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

  /// 通知选择变化
  void _notifySelected() {
    final result = <String, List<String>>{};
    for (var entry in _selectedIds.entries) {
      result[entry.key] = entry.value.toList();
    }
    widget.onSelected?.call(result);
  }
}

