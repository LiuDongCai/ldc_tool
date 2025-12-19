import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/common/widgets/image/dc_cached_image.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/model/eat_model.dart';
import 'package:ldc_tool/features/eat_list/header/eat_list_header.dart';
import 'package:ldc_tool/features/eat_list/state/eat_list_state.dart';

class EatListItemView extends StatefulWidget {
  const EatListItemView({
    super.key,
    required this.model,
  });

  final EatModel model;

  @override
  State<EatListItemView> createState() => _EatListItemViewState();
}

class _EatListItemViewState extends State<EatListItemView>
    with EatListLogicConsumerMixin<EatListItemView> {
  EatListState get state => logic.state;

  EatModel get model => widget.model;

  @override
  Widget build(BuildContext context) {
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
        _buildName(),
        SizedBox(height: 2.w),
        _buildSection(),
        SizedBox(height: 2.w),
        _buildCashback(),
        SizedBox(height: 2.w),
        _buildPrice(),
      ],
    );
    return resultWidget;
  }

  /// 名称
  Widget _buildName() {
    Widget resultWidget = Text(
      model.name ?? '',
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dc333333,
        fontWeight: FontWeight.w600,
        height: 26 / 16,
      ),
    );
    resultWidget = Row(
      children: [
        resultWidget,
        SizedBox(width: 4.w),
        _buildType(),
      ],
    );
    return resultWidget;
  }

  /// 区域
  Widget _buildSection() {
    return Text(
      model.section
              ?.map((e) => SectionType.values
                  .firstWhere((element) => element.type == e)
                  .name)
              .join('、') ??
          '不限区域',
      style: TextStyle(
        fontSize: 11.sp,
        color: DCColors.dc666666,
        height: 18 / 11,
      ),
    );
  }

  /// 类型
  Widget _buildType() {
    // 每个类型单独一个标签包裹，间隔4.w
    List<Widget> typeWidgets = model.type?.map((e) {
          Widget resultWidget = Container(
            margin: EdgeInsets.only(left: 4.w),
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.w,
            ),
            decoration: BoxDecoration(
              color: DCColors.dcECF3FF,
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: Text(
              FoodType.values.firstWhere((element) => element.type == e).name,
              style: TextStyle(
                fontSize: 11.sp,
                color: DCColors.dc666666,
              ),
            ),
          );
          return resultWidget;
        }).toList() ??
        <Widget>[];
    return Row(
      children: typeWidgets,
    );
  }

  /// 价格
  Widget _buildPrice() {
    return Text(
      model.price ?? '',
      style: TextStyle(
        fontSize: 14.sp,
        color: DCColors.dcF01800,
        height: 22 / 14,
      ),
    );
  }

  /// 返现
  Widget _buildCashback() {
    return Text(
      model.cashback
              ?.map((e) => CashbackPlatform.values
                  .firstWhere((element) => element.platform == e)
                  .name)
              .join('、') ??
          '无返现',
      style: TextStyle(
        fontSize: 11.sp,
        color: DCColors.dc666666,
        height: 18 / 11,
      ),
    );
  }
}
