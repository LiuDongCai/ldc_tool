import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat_cook_detail/header/eat_cook_detail_header.dart';
import 'package:ldc_tool/features/eat_cook_detail/state/eat_cook_detail_state.dart';
import 'package:ldc_tool/features/eat_cook_random/model/eat_model.dart';

/// 家常菜详情-配料表
class EatCookDetailIngredientsView extends StatefulWidget {
  const EatCookDetailIngredientsView({super.key});

  @override
  State<EatCookDetailIngredientsView> createState() =>
      _EatCookDetailIngredientsViewState();
}

class _EatCookDetailIngredientsViewState
    extends State<EatCookDetailIngredientsView>
    with EatCookDetailLogicConsumerMixin<EatCookDetailIngredientsView> {
  EatCookDetailState get state => logic.state;

  /// 配料表数据
  List<Ingredients> get ingredients => state.cookModel?.ingredients ?? [];

  @override
  Widget build(BuildContext context) {
    if (ingredients.isEmpty) return const SizedBox.shrink();

    Widget resultWidget = Table(
      border: TableBorder.all(
        color: DCColors.dc666666,
        width: 0.5.w,
      ),
      children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '配料',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: DCColors.dc000000,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '用量',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: DCColors.dc000000,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ] +
          ingredients
              .map(
                (e) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        e.name ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: DCColors.dc000000,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        e.amount ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: DCColors.dc000000,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
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
}
