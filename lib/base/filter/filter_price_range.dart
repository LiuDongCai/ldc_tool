import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/base/filter/filter_model.dart';
import 'package:ldc_tool/base/filter/filter_overlay.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';

/// 价格范围筛选组件
class FilterPriceRange extends StatefulWidget {
  /// 预设价格范围选项
  final List<PriceRangeOption>? presetOptions;

  /// 当前选中的价格范围
  final PriceRange? selectedRange;

  /// 单位
  final String unit;

  /// 选择回调
  final ValueChanged<PriceRange?>? onSelected;

  const FilterPriceRange({
    super.key,
    this.presetOptions,
    this.selectedRange,
    this.unit = '万/坪',
    this.onSelected,
  });

  /// 显示价格范围筛选弹窗
  static Future<PriceRange?> show({
    required BuildContext context,
    List<PriceRangeOption>? presetOptions,
    PriceRange? selectedRange,
    String unit = '万/坪',
    String? title,
    ValueChanged<PriceRange?>? onSelected,
  }) async {
    PriceRange? result;
    await FilterOverlay.show(
      context: context,
      title: title,
      onReset: () {
        result = null;
      },
      onConfirm: () {
        Navigator.of(context).pop(result);
      },
      child: FilterPriceRange(
        presetOptions: presetOptions,
        selectedRange: selectedRange,
        unit: unit,
        onSelected: (range) {
          result = range;
        },
      ),
    );
    return result;
  }

  @override
  State<FilterPriceRange> createState() => _FilterPriceRangeState();
}

class _FilterPriceRangeState extends State<FilterPriceRange> {
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  PriceRangeOption? _selectedPreset;

  @override
  void initState() {
    super.initState();
    if (widget.selectedRange != null) {
      _minController.text = widget.selectedRange!.minPrice?.toString() ?? '';
      _maxController.text = widget.selectedRange!.maxPrice?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.presetOptions != null && widget.presetOptions!.isNotEmpty)
            _buildPresetOptions(),
          if (widget.presetOptions != null && widget.presetOptions!.isNotEmpty)
            SizedBox(height: 24.w),
          _buildCustomInput(),
        ],
      ),
    );
    return resultWidget;
  }

  /// 构建预设选项
  Widget _buildPresetOptions() {
    Widget resultWidget = Wrap(
      spacing: 12.w,
      runSpacing: 12.w,
      children: widget.presetOptions!.map((option) => _buildPresetOption(option)).toList(),
    );
    return resultWidget;
  }

  /// 构建预设选项项
  Widget _buildPresetOption(PriceRangeOption option) {
    final isSelected = _selectedPreset?.id == option.id;
    Widget resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _selectedPreset = option;
          _minController.text = option.range.minPrice?.toString() ?? '';
          _maxController.text = option.range.maxPrice?.toString() ?? '';
        });
        widget.onSelected?.call(option.range);
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

  /// 构建自定义输入
  Widget _buildCustomInput() {
    Widget resultWidget = Row(
      children: [
        Expanded(
          child: _buildMinInput(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            '~',
            style: TextStyle(
              fontSize: 16.sp,
              color: DCColors.dc666666,
            ),
          ),
        ),
        Expanded(
          child: _buildMaxInput(),
        ),
        SizedBox(width: 8.w),
        Text(
          widget.unit,
          style: TextStyle(
            fontSize: 14.sp,
            color: DCColors.dc666666,
          ),
        ),
      ],
    );
    return resultWidget;
  }

  /// 构建最低价输入
  Widget _buildMinInput() {
    Widget resultWidget = TextField(
      controller: _minController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        hintText: '最低价',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: DCColors.dc999999,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 12.w,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.w),
          borderSide: BorderSide(
            color: DCColors.dcF5F5F5,
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.w),
          borderSide: BorderSide(
            color: DCColors.dcF5F5F5,
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.w),
          borderSide: BorderSide(
            color: DCColors.dc006AFF,
            width: 1.w,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: 14.sp,
        color: DCColors.dc333333,
      ),
      onChanged: (value) {
        _selectedPreset = null;
        final minPrice = value.isEmpty ? null : double.tryParse(value);
        final maxPrice = _maxController.text.isEmpty
            ? null
            : double.tryParse(_maxController.text);
        widget.onSelected?.call(
          PriceRange(
            minPrice: minPrice,
            maxPrice: maxPrice,
            unit: widget.unit,
          ),
        );
      },
    );
    return resultWidget;
  }

  /// 构建最高价输入
  Widget _buildMaxInput() {
    Widget resultWidget = TextField(
      controller: _maxController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        hintText: '最高价',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: DCColors.dc999999,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 12.w,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.w),
          borderSide: BorderSide(
            color: DCColors.dcF5F5F5,
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.w),
          borderSide: BorderSide(
            color: DCColors.dcF5F5F5,
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.w),
          borderSide: BorderSide(
            color: DCColors.dc006AFF,
            width: 1.w,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: 14.sp,
        color: DCColors.dc333333,
      ),
      onChanged: (value) {
        _selectedPreset = null;
        final minPrice = _minController.text.isEmpty
            ? null
            : double.tryParse(_minController.text);
        final maxPrice = value.isEmpty ? null : double.tryParse(value);
        widget.onSelected?.call(
          PriceRange(
            minPrice: minPrice,
            maxPrice: maxPrice,
            unit: widget.unit,
          ),
        );
      },
    );
    return resultWidget;
  }
}

/// 价格范围选项
class PriceRangeOption {
  /// 选项ID
  final String id;

  /// 选项名称
  final String name;

  /// 价格范围
  final PriceRange range;

  PriceRangeOption({
    required this.id,
    required this.name,
    required this.range,
  });
}

