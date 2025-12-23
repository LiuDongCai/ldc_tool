import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/base/filter/dc_filter_bottom_buttons.dart';
import 'package:ldc_tool/base/filter/dc_filter_dropdown.dart';
import 'package:ldc_tool/base/filter/filter_model.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';

/// 更多筛选组件（组合多个筛选条件）
class DCFilterMoreSelectView extends StatefulWidget {
  /// 筛选组列表
  final List<FilterGroup> groups;

  /// 确定回调
  final ValueChanged<Map<String, List<String>>>? onConfirm;

  const DCFilterMoreSelectView({
    super.key,
    required this.groups,
    this.onConfirm,
  });

  /// 在指定位置下方显示更多筛选弹窗
  static Future<Map<String, List<String>>> showBelow({
    required BuildContext context,
    required RenderBox anchorBox,
    required List<FilterGroup> groups,
    Map<String, List<String>>? selectedValues,
    String? filterType,
  }) async {
    Map<String, List<String>> result = selectedValues ?? {};
    await DCFilterDropdown.showBelow<Map<String, List<String>>>(
      context: context,
      anchorBox: anchorBox,
      filterType: filterType,
      child: DCFilterMoreSelectView(
        groups: groups,
        onConfirm: (values) {
          result = values;
          // 关闭弹窗
          DCFilterDropdown.dismiss();
        },
      ),
    );
    return result;
  }

  @override
  State<DCFilterMoreSelectView> createState() => _DCFilterMoreSelectViewState();
}

class _DCFilterMoreSelectViewState extends State<DCFilterMoreSelectView> {
  /// 最终选中的id
  final Map<String, Set<String>> _selectedIds = {};

  /// 临时选中的id
  final Map<String, Set<String>> _tempSelectedIds = {};

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
        _tempSelectedIds[group.title] = selectedSet;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.groups.map((group) => _buildGroup(group)).toList(),
    );
    resultWidget = SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: resultWidget,
    );
    resultWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        resultWidget,
        DCFilterBottomButtons(
          onReset: () {
            // 重置
            setState(() {
              _tempSelectedIds.clear();
            });
          },
          onConfirm: () {
            // 确定选中
            setState(() {
              _selectedIds.clear();
              _selectedIds.addAll(_tempSelectedIds);
            });
            // 回传给外部
            final result = <String, List<String>>{};
            for (var entry in _selectedIds.entries) {
              result[entry.key] = entry.value.toList();
            }
            widget.onConfirm?.call(result);
          },
        ),
      ],
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
        SizedBox(height: 12.w),
      ],
    );
    resultWidget = SizedBox(
      width: double.infinity,
      child: resultWidget,
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
    Widget resultWidget = GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10.w, // 水平间距
        mainAxisSpacing: 10.w, // 垂直间距

        childAspectRatio: 2.2, // 宽高比（宽度/高度），可以控制高度
      ),
      itemCount: group.options.length,
      itemBuilder: (context, index) {
        final option = group.options[index];
        return _buildOption(
          group,
          option,
        );
      },
    );
    return resultWidget;
  }

  /// 构建选项
  Widget _buildOption(FilterGroup group, FilterOption option) {
    final selectedSet = _tempSelectedIds[group.title] ?? <String>{};
    final isSelected = selectedSet.contains(option.id);
    Widget resultWidget = Text(
      option.name,
      style: TextStyle(
        fontSize: 14.sp,
        color: isSelected ? DCColors.dc42CC8F : DCColors.dc666666,
        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    resultWidget = Container(
      decoration: BoxDecoration(
        color: isSelected
            ? DCColors.dc42CC8F.withValues(alpha: 0.1)
            : DCColors.dcF5F5F5,
        border: Border.all(
          color: isSelected ? DCColors.dc42CC8F : DCColors.dcF5F5F5,
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(4.w),
      ),
      alignment: Alignment.center,
      child: resultWidget,
    );
    resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          final selectedSet = _tempSelectedIds[group.title] ?? <String>{};
          if (group.isMultiSelect) {
            // 多选模式
            if (isSelected) {
              selectedSet.remove(option.id);
              if (selectedSet.isEmpty) {
                _tempSelectedIds.remove(group.title);
              } else {
                _tempSelectedIds[group.title] = selectedSet;
              }
            } else {
              selectedSet.add(option.id);
              _tempSelectedIds[group.title] = selectedSet;
            }
          } else {
            // 单选模式
            _tempSelectedIds.clear();
            selectedSet.clear();
            selectedSet.add(option.id);
            _tempSelectedIds[group.title] = selectedSet;
          }
        });
      },
      child: resultWidget,
    );
    return resultWidget;
  }
}
