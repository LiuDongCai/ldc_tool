import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/base/filter/dc_filter_dropdown.dart';
import 'package:ldc_tool/base/filter/model/dc_filter_model.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/common/widgets/toast/dc_toast.dart';

/// 价格范围筛选组件
class DCFilterPriceRangeView extends StatefulWidget {
  /// 预设价格范围选项
  final List<DCPriceRangeOption> options;

  /// 当前选中的价格范围
  final DCPriceRangeOption? selectedRange;

  /// 单位
  final String unit;

  /// 一行标签个数
  final int rowCount;

  /// 选择回调
  final ValueChanged<DCPriceRangeOption?>? onConfirm;

  /// 是否显示"不限"选项
  final bool showUnlimited;

  const DCFilterPriceRangeView({
    super.key,
    required this.options,
    this.selectedRange,
    this.unit = '元',
    this.rowCount = 3,
    this.onConfirm,
    this.showUnlimited = true,
  });

  /// 在指定位置下方显示价格范围筛选弹窗
  static Future<DCPriceRangeOption?> showBelow({
    required BuildContext context,
    required RenderBox anchorBox,
    required List<DCPriceRangeOption> options,
    DCPriceRangeOption? selectedRange,
    bool showUnlimited = true,
    String unit = '元',
    int rowCount = 3,
    String? filterType,
  }) async {
    DCPriceRangeOption? result = selectedRange;
    await DCFilterDropdown.showBelow<DCPriceRangeOption>(
      context: context,
      anchorBox: anchorBox,
      filterType: filterType,
      child: DCFilterPriceRangeView(
        options: options,
        selectedRange: selectedRange,
        unit: unit,
        rowCount: rowCount,
        showUnlimited: showUnlimited,
        onConfirm: (range) {
          result = range;
          // 关闭弹窗
          DCFilterDropdown.dismiss();
        },
      ),
    );
    return result;
  }

  @override
  State<DCFilterPriceRangeView> createState() => _DCFilterPriceRangeViewState();
}

class _DCFilterPriceRangeViewState extends State<DCFilterPriceRangeView> {
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  /// 最终选中的价格
  DCPriceRangeOption? _selectedPrice;

  /// 临时选中的价格
  DCPriceRangeOption? _tempSelectedPrice;

  /// 展示数据
  List<DCPriceRangeOption> get optionList {
    if (widget.showUnlimited) {
      // 增加不限选项
      return [
        DCPriceRangeOption(
          id: '0',
          name: '不限',
          range: DCPriceRange(
            minPrice: null,
            maxPrice: null,
            unit: widget.unit,
          ),
        ),
        ...widget.options,
      ];
    }
    return widget.options;
  }

  @override
  void initState() {
    super.initState();
    if (widget.selectedRange != null) {
      _selectedPrice = widget.selectedRange;
      _tempSelectedPrice = widget.selectedRange;
      // 如果是自定义的，填充最低价和最高价
      if (widget.selectedRange?.id == '99') {
        _minController.text =
            widget.selectedRange!.range.minPrice?.toString() ?? '';
        _maxController.text =
            widget.selectedRange!.range.maxPrice?.toString() ?? '';
      }
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
    Widget resultWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPriceOptions(),
        SizedBox(height: 24.w),
        _buildCustomInput(),
      ],
    );
    resultWidget = Container(
      padding: EdgeInsets.all(16.w),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 构建预设选项
  Widget _buildPriceOptions() {
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
        final option = optionList[index];
        return _buildPriceOption(option);
      },
    );
    return resultWidget;
  }

  /// 构建预设选项项
  Widget _buildPriceOption(DCPriceRangeOption option) {
    final isSelected = _tempSelectedPrice?.id == option.id;
    Widget resultWidget = Text(
      option.name,
      style: TextStyle(
        fontSize: 14.sp,
        color: isSelected ? DCColors.dc42CC8F : DCColors.dc666666,
        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
      ),
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
          _tempSelectedPrice = option;
          // 清空自定义输入
          _minController.text = '';
          _maxController.text = '';
        });
      },
      child: resultWidget,
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
            '-',
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
        _buildConfirmButton(),
      ],
    );
    return resultWidget;
  }

  /// 构建最低价输入
  Widget _buildMinInput() {
    Widget resultWidget = TextField(
      controller: _minController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
            color: DCColors.dc42CC8F,
            width: 1.w,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: 14.sp,
        color: DCColors.dc333333,
      ),
      onChanged: (value) {
        // 自定义时，普通选项不选中
        setState(() {
          _tempSelectedPrice = null;
        });
      },
    );
    return resultWidget;
  }

  /// 构建最高价输入
  Widget _buildMaxInput() {
    Widget resultWidget = TextField(
      controller: _maxController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
            color: DCColors.dc42CC8F,
            width: 1.w,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: 14.sp,
        color: DCColors.dc333333,
      ),
      onChanged: (value) {
        // 自定义时，普通选项不选中
        setState(() {
          _tempSelectedPrice = null;
        });
      },
    );
    return resultWidget;
  }

  /// 构建确定按钮
  Widget _buildConfirmButton() {
    Widget resultWidget = Text(
      '确定',
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dcFFFFFF,
        fontWeight: FontWeight.w500,
      ),
    );
    resultWidget = Container(
      width: 100.w,
      height: 44.w,
      margin: EdgeInsets.only(left: 12.w),
      decoration: BoxDecoration(
        color: DCColors.dc42CC8F,
        borderRadius: BorderRadius.circular(8.w),
      ),
      alignment: Alignment.center,
      child: resultWidget,
    );
    resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (_tempSelectedPrice != null) {
          // 选中普通选项
          setState(() {
            _selectedPrice = _tempSelectedPrice;
          });
          widget.onConfirm?.call(_selectedPrice);
        } else {
          // 如果自定义输入，则根据输入的最低价和最高价创建PriceRangeOption
          final minPrice = int.tryParse(_minController.text.trim());
          final maxPrice = int.tryParse(_maxController.text.trim());
          if (minPrice == null && maxPrice == null) {
            DCToast.show(message: '请输入自定义范围');
            return;
          }
          // 如果都有值，则最小值不能大于最大值
          if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
            DCToast.show(message: '自定义范围应该由小到大');
            return;
          }
          _tempSelectedPrice = DCPriceRangeOption(
            id: '99',
            name: '$minPrice-$maxPrice元',
            range: DCPriceRange(
              minPrice: minPrice,
              maxPrice: maxPrice,
              unit: widget.unit,
            ),
          );
        }
      },
      child: resultWidget,
    );
    return resultWidget;
  }
}
