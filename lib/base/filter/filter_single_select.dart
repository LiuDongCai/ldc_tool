import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/base/filter/filter_dropdown.dart';
import 'package:ldc_tool/base/filter/filter_model.dart';
import 'package:ldc_tool/base/filter/filter_overlay.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';

/// 单选筛选组件
class FilterSingleSelect extends StatefulWidget {
  /// 选项列表
  final List<FilterOption> options;

  /// 当前选中的ID
  final String? selectedId;

  /// 选择回调
  final ValueChanged<String?>? onSelected;

  /// 是否显示"不限"选项
  final bool showUnlimited;

  /// "不限"选项文本
  final String unlimitedText;

  const FilterSingleSelect({
    super.key,
    required this.options,
    this.selectedId,
    this.onSelected,
    this.showUnlimited = true,
    this.unlimitedText = '不限',
  });

  /// 显示单选筛选弹窗（底部弹出）
  static Future<String?> show({
    required BuildContext context,
    required List<FilterOption> options,
    String? selectedId,
    bool showUnlimited = true,
    String unlimitedText = '不限',
    String? title,
    ValueChanged<String?>? onSelected,
  }) async {
    String? result;
    await FilterOverlay.show(
      context: context,
      title: title,
      onConfirm: () {
        Navigator.of(context).pop(result);
      },
      child: FilterSingleSelect(
        options: options,
        selectedId: selectedId,
        showUnlimited: showUnlimited,
        unlimitedText: unlimitedText,
        onSelected: (id) {
          result = id;
        },
      ),
    );
    return result;
  }

  /// 在指定位置下方显示单选筛选弹窗
  static Future<String?> showBelow({
    required BuildContext context,
    required RenderBox anchorBox,
    required List<FilterOption> options,
    String? selectedId,
    bool showUnlimited = true,
    String unlimitedText = '不限',
    String? title,
    ValueChanged<String?>? onSelected,
    String? filterType,
  }) async {
    String? result;
    await FilterDropdown.showBelow<String?>(
      context: context,
      anchorBox: anchorBox,
      title: title,
      maxHeight: 400.w,
      filterType: filterType,
      onConfirm: () {},
      child: FilterSingleSelect(
        options: options,
        selectedId: selectedId,
        showUnlimited: showUnlimited,
        unlimitedText: unlimitedText,
        onSelected: (id) {
          result = id;
        },
      ),
    );
    return result;
  }

  @override
  State<FilterSingleSelect> createState() => _FilterSingleSelectState();
}

class _FilterSingleSelectState extends State<FilterSingleSelect> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedId;
  }

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Wrap(
        spacing: 12.w,
        runSpacing: 12.w,
        children: [
          if (widget.showUnlimited) _buildUnlimitedOption(),
          ...widget.options.map((option) => _buildOption(option)),
        ],
      ),
    );
    return resultWidget;
  }

  /// 构建"不限"选项
  Widget _buildUnlimitedOption() {
    final isSelected = _selectedId == '0';
    Widget resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _selectedId = '0';
        });
        widget.onSelected?.call('0');
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
          widget.unlimitedText,
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

  /// 构建选项
  Widget _buildOption(FilterOption option) {
    final isSelected = _selectedId == option.id;
    Widget resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _selectedId = option.id;
        });
        widget.onSelected?.call(option.id);
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
