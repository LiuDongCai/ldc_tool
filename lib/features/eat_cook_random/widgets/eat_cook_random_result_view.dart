import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat_cook_random/header/eat_cook_random_header.dart';
import 'package:ldc_tool/features/eat_cook_random/model/eat_model.dart';
import 'package:ldc_tool/features/eat_cook_random/logic/eat_cook_random_logic.dart';
import 'package:ldc_tool/features/eat_cook_random/state/eat_cook_random_state.dart';
import 'package:ldc_tool/features/eat_cook_random/widgets/eat_cook_random_result_item_view.dart';

/// 随机点餐结果视图
class EatCookRandomResultView extends StatefulWidget {
  const EatCookRandomResultView({super.key});

  @override
  State<EatCookRandomResultView> createState() =>
      EatCookRandomResultViewState();
}

class EatCookRandomResultViewState extends State<EatCookRandomResultView>
    with EatCookRandomLogicConsumerMixin<EatCookRandomResultView> {
  EatCookRandomState get state => logic.state;

  /// 励志话语
  List<String> get motivationalWords => state.motivationalWords;

  /// 随机结果
  List<EatCookModel> get randomResultList => state.randomResultList ?? [];

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = GetBuilder<EatCookRandomLogic>(
      tag: logicTag,
      id: EatCookRandomUpdateId.randomResult,
      builder: (_) {
        if (randomResultList.isEmpty) {
          return const SizedBox.shrink();
        }
        return _buildResultWidget();
      },
    );
    return resultWidget;
  }

  /// 构建结果视图
  Widget _buildResultWidget() {
    Widget resultWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildResultType(),
        SizedBox(height: 10.w),
        Expanded(
          child: _buildCookListWidget(),
        ),
      ],
    );
    resultWidget = Container(
      margin: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
      ),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 构建结果类型
  Widget _buildResultType() {
    Widget resultWidget = Text(
      '今日菜单：',
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dc42CC8F,
        fontWeight: FontWeight.w600,
      ),
    );
    return resultWidget;
  }

  /// 菜单列表
  Widget _buildCookListWidget() {
    Widget resultWidget = ListView.separated(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      separatorBuilder: (context, index) => SizedBox(height: 10.w),
      itemCount: randomResultList.length,
      itemBuilder: (context, index) {
        final model = randomResultList[index];
        return EatCookRandomResultItemView(model: model);
      },
    );
    return resultWidget;
  }
}
