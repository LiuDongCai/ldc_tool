import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat/model/eat_model.dart';
import 'package:ldc_tool/features/eat_list/widgets/eat_list_item_view.dart';

class EatListRandomResultDialog extends StatefulWidget {
  const EatListRandomResultDialog({
    super.key,
    required this.model,
  });

  final EatModel model;

  @override
  State<EatListRandomResultDialog> createState() =>
      _EatListRandomResultDialogState();
}

class _EatListRandomResultDialogState extends State<EatListRandomResultDialog> {
  EatModel get model => widget.model;

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 12.w),
        _buildRandomTitle(),
        SizedBox(height: 8.w),
        _buildRandomInfo(),
        SizedBox(height: 12.w),
        EatListItemView(model: model),
        SizedBox(height: 12.w),
      ],
    );
    resultWidget = Stack(
      children: [
        resultWidget,
        // 关闭按钮
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            color: DCColors.dc42CC8F,
            iconSize: 28.sp,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
        ),
      ],
    );
    resultWidget = Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: DCColors.dcFFFFFF,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: resultWidget,
    );
    resultWidget = Material(
      color: DCColors.dc00000000,
      child: resultWidget,
    );
    resultWidget = Center(
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 随机结果
  Widget _buildRandomTitle() {
    Widget resultWidget = Text(
      '为您推荐',
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dc333333,
        fontWeight: FontWeight.w600,
        height: 26 / 16,
      ),
    );
    return resultWidget;
  }

  /// 随机结果
  Widget _buildRandomInfo() {
    Widget resultWidget = Text(
      '随机选出当前列表中的一家餐馆',
      style: TextStyle(
        fontSize: 14.sp,
        color: DCColors.dc666666,
        height: 20 / 14,
      ),
    );
    return resultWidget;
  }
}
