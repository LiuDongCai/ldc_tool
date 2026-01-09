import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/common/widgets/image/dc_cached_image.dart';
import 'package:ldc_tool/features/eat_cook_detail/header/eat_cook_detail_header.dart';
import 'package:ldc_tool/features/eat_cook_detail/state/eat_cook_detail_state.dart';
import 'package:ldc_tool/features/eat_cook_random/model/eat_model.dart';

/// 家常菜详情-步骤
class EatCookDetailStepView extends StatefulWidget {
  const EatCookDetailStepView({super.key});

  @override
  State<EatCookDetailStepView> createState() => _EatCookDetailStepViewState();
}

class _EatCookDetailStepViewState extends State<EatCookDetailStepView>
    with EatCookDetailLogicConsumerMixin<EatCookDetailStepView> {
  EatCookDetailState get state => logic.state;

  /// 配料表数据
  List<CookStep> get stepList => state.cookModel?.step ?? [];

  @override
  Widget build(BuildContext context) {
    if (stepList.isEmpty) return const SizedBox.shrink();

    Widget resultWidget = ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: stepList.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final step = stepList[index];
        return _buildStep(
          index,
          step,
        );
      },
    );
    resultWidget = Container(
      margin: EdgeInsets.only(
        left: 10.w,
        right: 10.w,
        top: 16.w,
      ),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 步骤
  Widget _buildStep(
    int index,
    CookStep step,
  ) {
    Widget resultWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepDes(index, step),
        SizedBox(height: 10.w),
        _buildStepImage(step),
        SizedBox(height: 10.w),
      ],
    );
    return resultWidget;
  }

  /// 步骤描述
  Widget _buildStepDes(
    int index,
    CookStep step,
  ) {
    return Text(
      '${index + 1}：${step.description}',
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dc333333,
      ),
    );
  }

  /// 步骤图片
  Widget _buildStepImage(CookStep step) {
    Widget resultWidget = DCCachedImage(
      step.image ?? '',
      width: double.infinity,
    );
    resultWidget = ClipRRect(
      borderRadius: BorderRadius.circular(4.w),
      child: resultWidget,
    );
    return resultWidget;
  }
}
