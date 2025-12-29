import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/base/filter/dc_filter_dropdown.dart';
import 'package:ldc_tool/base/filter/model/dc_filter_model.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';

/// 单列表筛选组件
class DCFilterSingleListSelectView extends StatefulWidget {
  /// 选项列表
  final List<DCFilterOption> options;

  /// 当前选中的ID
  final String? selectedId;

  /// 确定回调
  final ValueChanged<String?>? onSelected;

  /// 是否显示不限
  final bool showUnlimited;

  /// 不限文本
  final String unlimitedText;

  const DCFilterSingleListSelectView({
    super.key,
    required this.options,
    this.selectedId,
    this.onSelected,
    this.showUnlimited = false,
    this.unlimitedText = '不限',
  });

  /// 在指定位置下方显示单选筛选弹窗
  static Future<String?> showBelow({
    required BuildContext context,
    required RenderBox anchorBox,
    required List<DCFilterOption> options,
    String? selectedId,
    bool showUnlimited = false,
    String unlimitedText = '不限',
    String? filterType,
  }) async {
    String? result = selectedId;
    await DCFilterDropdown.showBelow<String?>(
      context: context,
      anchorBox: anchorBox,
      filterType: filterType,
      child: DCFilterSingleListSelectView(
        options: options,
        selectedId: selectedId,
        showUnlimited: showUnlimited,
        unlimitedText: unlimitedText,
        onSelected: (value) {
          result = value;
          // 关闭弹窗
          DCFilterDropdown.dismiss();
        },
      ),
    );
    return result;
  }

  @override
  State<DCFilterSingleListSelectView> createState() =>
      _DCFilterSingleListSelectViewState();
}

class _DCFilterSingleListSelectViewState
    extends State<DCFilterSingleListSelectView> {
  /// 最终选中的ID
  String? _selectedId;

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
    _selectedId = widget.selectedId;
  }

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
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
      padding: EdgeInsets.all(8.w),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 构建"不限"选项
  Widget _buildUnlimitedOption() {
    final isSelected = _selectedId == '0';
    Widget resultWidget = Text(
      widget.unlimitedText,
      style: TextStyle(
        fontSize: 14.sp,
        color: isSelected ? DCFilterDropdown.themeColor : DCColors.dc666666,
        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    resultWidget = Container(
      color: DCColors.dcFFFFFF,
      alignment: Alignment.center,
      child: resultWidget,
    );
    resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _selectedId = '0';
          widget.onSelected?.call(_selectedId);
        });
      },
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 构建选项
  Widget _buildOption(DCFilterOption option) {
    final isSelected = _selectedId == option.id;
    Widget resultWidget = Text(
      option.name,
      style: TextStyle(
        fontSize: 14.sp,
        color: isSelected ? DCFilterDropdown.themeColor : DCColors.dc666666,
        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    resultWidget = Container(
      height: 40.w,
      color: DCColors.dcFFFFFF,
      alignment: Alignment.center,
      child: resultWidget,
    );
    resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _selectedId = option.id;
          widget.onSelected?.call(_selectedId);
        });
      },
      child: resultWidget,
    );
    return resultWidget;
  }
}
