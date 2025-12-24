import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/base/filter/dc_filter_bottom_buttons.dart';
import 'package:ldc_tool/base/filter/dc_filter_dropdown.dart';
import 'package:ldc_tool/base/filter/model/dc_filter_model.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';

/// 通用筛选组件（单选、多选等）
class DCFilterNormalSelectView extends StatefulWidget {
  /// 选项列表
  final List<DCFilterOption> options;

  /// 当前选中的ID集合
  final List<String>? selectedIds;

  /// 是否显示"不限"选项
  final bool showUnlimited;

  /// "不限"选项文本
  final String unlimitedText;

  /// 一行标签个数
  final int rowCount;

  /// 是否显示重置按钮
  final bool showReset;

  /// 是否显示确定按钮
  final bool showConfirm;

  /// 重置按钮文本
  final String resetText;

  /// 确定按钮文本
  final String confirmText;

  /// 确定回调
  final ValueChanged<List<String>?>? onConfirm;

  /// 是否多选
  final bool isMultiSelect;

  const DCFilterNormalSelectView({
    super.key,
    required this.options,
    this.selectedIds,
    this.showUnlimited = true,
    this.unlimitedText = '不限',
    this.rowCount = 4,
    this.showReset = true,
    this.showConfirm = true,
    this.resetText = '重置',
    this.confirmText = '确定',
    this.onConfirm,
    this.isMultiSelect = false,
  });

  /// 在指定位置下方显示单选筛选弹窗
  static Future<List<String>?> showBelow({
    required BuildContext context,
    required RenderBox anchorBox,
    required List<DCFilterOption> options,
    List<String>? selectedIds,
    bool showUnlimited = true,
    String unlimitedText = '不限',
    bool showReset = true,
    bool showConfirm = true,
    String resetText = '重置',
    String confirmText = '确定',
    bool isMultiSelect = false,
    String? filterType,
    int rowCount = 4,
  }) async {
    List<String>? result = selectedIds;
    await DCFilterDropdown.showBelow<String?>(
      context: context,
      anchorBox: anchorBox,
      filterType: filterType,
      child: DCFilterNormalSelectView(
        options: options,
        selectedIds: selectedIds,
        showUnlimited: showUnlimited,
        unlimitedText: unlimitedText,
        showReset: showReset,
        showConfirm: showConfirm,
        onConfirm: (value) {
          result = value;
          // 关闭弹窗
          DCFilterDropdown.dismiss();
        },
        resetText: resetText,
        confirmText: confirmText,
        isMultiSelect: isMultiSelect,
        rowCount: rowCount,
      ),
    );
    return result;
  }

  @override
  State<DCFilterNormalSelectView> createState() =>
      _DCFilterNormalSelectViewState();
}

class _DCFilterNormalSelectViewState extends State<DCFilterNormalSelectView> {
  /// 最终选中的ID
  List<String> _selectedIds = [];

  /// 临时选中的ID
  List<String> _tempSelectedIds = [];

  /// 展示数据
  List<DCFilterOption> get optionList {
    if (widget.showUnlimited) {
      // 增加不限选项
      return [
        DCFilterOption(
          id: '0',
          name: widget.unlimitedText,
        ),
        ...widget.options,
      ];
    }
    return widget.options;
  }

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.selectedIds ?? [];
    _tempSelectedIds.addAll(_selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    // 网格布局，一行默认4个标签
    Widget resultWidget = GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.rowCount,
        crossAxisSpacing: 10.w, // 水平间距
        mainAxisSpacing: 10.w, // 垂直间距
        // rowCount为4时，宽高比2.2 rowCount为3时，宽高比3.2 rowCount为2时，宽高比4.2
        childAspectRatio: 6.2 - widget.rowCount, // 宽高比（宽度/高度），可以控制高度
      ),
      itemCount: optionList.length,
      itemBuilder: (context, index) {
        if (widget.showUnlimited && index == 0) {
          return _buildUnlimitedOption();
        }
        final option = optionList[index];
        return _buildOption(option);
      },
    );
    resultWidget = Container(
      padding: EdgeInsets.all(16.w),
      child: resultWidget,
    );
    resultWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        resultWidget,
        if (widget.showReset || widget.showConfirm)
          DCFilterBottomButtons(
            showReset: widget.showReset,
            showConfirm: widget.showConfirm,
            resetText: widget.resetText,
            confirmText: widget.confirmText,
            onReset: () {
              // 重置为不限
              setState(() {
                _tempSelectedIds = ['0'];
              });
            },
            onConfirm: () {
              // 确定选中
              setState(() {
                _selectedIds = _tempSelectedIds;
              });
              // 回传给外部
              widget.onConfirm?.call(_selectedIds);
            },
          ),
      ],
    );
    return resultWidget;
  }

  /// 构建"不限"选项
  Widget _buildUnlimitedOption() {
    final isSelected = _tempSelectedIds.contains('0');
    Widget resultWidget = Text(
      widget.unlimitedText,
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
          _tempSelectedIds = ['0'];
        });
      },
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 构建选项
  Widget _buildOption(DCFilterOption option) {
    final isSelected = _tempSelectedIds.contains(option.id);
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
          // 如果已经选中，则移除（限多选模式）
          if (widget.isMultiSelect && isSelected) {
            _tempSelectedIds.remove(option.id);
          } else {
            // 移除不限
            if (_tempSelectedIds.contains('0')) {
              _tempSelectedIds.remove('0');
            }
            // 单选还是多选
            if (widget.isMultiSelect) {
              _tempSelectedIds.add(option.id);
            } else {
              _tempSelectedIds = [option.id];
            }
          }
        });
      },
      child: resultWidget,
    );
    return resultWidget;
  }
}
