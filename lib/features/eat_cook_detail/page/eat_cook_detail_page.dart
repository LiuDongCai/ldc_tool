import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/common/widgets/loading/tw_loading_widget.dart';
import 'package:ldc_tool/features/eat_cook_detail/logic/eat_cook_detail_logic.dart';
import 'package:ldc_tool/features/eat_cook_detail/header/eat_cook_detail_header.dart';
import 'package:ldc_tool/features/eat_cook_detail/state/eat_cook_detail_state.dart';
import 'package:ldc_tool/features/eat_cook_detail/widgets/eat_cook_detail_ingredients_view.dart';
import 'package:ldc_tool/features/eat_cook_detail/widgets/eat_cook_detail_step_view.dart';
import 'package:ldc_tool/features/eat_cook_random/model/eat_model.dart';

class EatCookDetailPage extends StatefulWidget {
  const EatCookDetailPage({super.key});

  @override
  State<EatCookDetailPage> createState() => EatCookDetailPageState();
}

class EatCookDetailPageState extends State<EatCookDetailPage>
    with EatCookDetailLogicPutMixin<EatCookDetailPage> {
  EatCookDetailState get state => logic.state;

  @override
  EatCookDetailLogic dcInitLogic() => EatCookDetailLogic();

  EatCookModel? get cookModel => state.cookModel;

  @override
  Widget dcBuildBody(BuildContext context) {
    return GetBuilder<EatCookDetailLogic>(
      tag: logicTag,
      builder: (_) {
        if (state.cookModel == null) {
          return const DCLoadingWidget();
        }
        Widget resultWidget = Scaffold(
          backgroundColor: DCColors.dcF2F4F7,
          appBar: AppBar(
            title: Text(
              cookModel?.name ?? '',
              style: TextStyle(
                fontSize: 18.sp,
                color: DCColors.dc333333,
                height: 28 / 18,
              ),
            ),
            centerTitle: true,
            backgroundColor: DCColors.dcFFFFFF,
            elevation: 0,
            scrolledUnderElevation: 0, //滚动时也保持无阴影（Flutter 3.x+）
          ),
          body: const SingleChildScrollView(
            child: Column(
              children: [
                // 配料表
                EatCookDetailIngredientsView(),
                // 步骤
                EatCookDetailStepView(),
              ],
            ),
          ),
        );
        return resultWidget;
      },
    );
  }
}
