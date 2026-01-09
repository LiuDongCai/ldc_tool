import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/common/widgets/image/dc_cached_image.dart';
import 'package:ldc_tool/features/eat_cook_random/header/eat_cook_random_header.dart';
import 'package:ldc_tool/features/eat_cook_random/model/eat_model.dart';
import 'package:ldc_tool/features/eat_cook_random/state/eat_cook_random_state.dart';

/// 随机点餐结果视图
class EatCookRandomResultItemView extends StatefulWidget {
  final EatCookModel model;

  const EatCookRandomResultItemView({
    super.key,
    required this.model,
  });

  @override
  State<EatCookRandomResultItemView> createState() =>
      EatCookRandomResultItemViewState();
}

class EatCookRandomResultItemViewState
    extends State<EatCookRandomResultItemView>
    with EatCookRandomLogicConsumerMixin<EatCookRandomResultItemView> {
  EatCookRandomState get state => logic.state;

  /// 菜单item
  EatCookModel get model => widget.model;

  @override
  Widget build(BuildContext context) {
    return _buildItemWidget();
  }

  /// 构建结果视图
  Widget _buildItemWidget() {
    Widget resultWidget = _buildCookItem();
    // 卡片布局
    resultWidget = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: DCColors.dcFFFFFF,
        borderRadius: BorderRadius.circular(8.w),
        boxShadow: [
          BoxShadow(
            color: DCColors.dc516263.withAlpha(10),
            offset: Offset(0, 1.w), // 阴影xy轴偏移量
            blurRadius: 5.w, // 阴影模糊程度
            spreadRadius: -1.w, // 阴影扩散程度
          )
        ],
      ),
      child: resultWidget,
    );
    resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        logic.handleCookDetailClick(model);
      },
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 菜单item
  Widget _buildCookItem() {
    Widget resultWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCover(),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildInfo(),
        ),
      ],
    );
    resultWidget = Container(
      padding: EdgeInsets.all(10.w),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 封面
  Widget _buildCover() {
    Widget resultWidget = DCCachedImage(
      model.image ?? '',
      width: 90.w,
      height: 90.w,
    );
    resultWidget = ClipRRect(
      borderRadius: BorderRadius.circular(8.w),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 信息
  Widget _buildInfo() {
    Widget resultWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.name ?? '',
          style: TextStyle(
            fontSize: 16.sp,
            color: DCColors.dc333333,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.w),
        Text(
          model.description ?? '',
          style: TextStyle(
            fontSize: 14.sp,
            color: DCColors.dc666666,
          ),
        ),
      ],
    );
    return resultWidget;
  }
}
