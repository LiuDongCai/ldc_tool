import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat_list/logic/eat_list_logic.dart';
import 'package:ldc_tool/features/eat_list/header/eat_list_header.dart';
import 'package:ldc_tool/features/eat_list/logic/eat_list_logic_filter.dart';
import 'package:ldc_tool/features/eat_list/state/eat_list_state.dart';
import 'package:ldc_tool/features/eat_list/widgets/eat_list_view.dart';
import 'package:ldc_tool/features/eat_list/widgets/eat_list_filter_bar.dart';
import 'package:ldc_tool/gen/assets.gen.dart';

class EatListPage extends StatefulWidget {
  const EatListPage({super.key});

  @override
  State<EatListPage> createState() => EatListPageState();
}

class EatListPageState extends State<EatListPage>
    with EatListLogicPutMixin<EatListPage> {
  EatListState get state => logic.state;

  @override
  EatListLogic dcInitLogic() => EatListLogic();

  @override
  void dispose() {
    // 关闭筛选弹窗
    logic.dismissFilterDropdown();
    state.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget dcBuildBody(BuildContext context) {
    Widget resultWidget = GetBuilder<EatListLogic>(
      tag: logicTag,
      builder: (_) {
        Widget resultWidget = Scaffold(
          backgroundColor: DCColors.dcF2F4F7,
          appBar: AppBar(
            title: Text(
              '餐馆',
              style: TextStyle(
                fontSize: 18.sp,
                color: DCColors.dc333333,
                height: 28 / 18,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  logic.handleRandomEatClick();
                },
                child: Text(
                  '帮我选择',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: DCColors.dc42CC8F,
                  ),
                ),
              ),
            ],
            centerTitle: true,
            backgroundColor: DCColors.dcFFFFFF,
            elevation: 0,
            scrolledUnderElevation: 0, //滚动时也保持无阴影（Flutter 3.x+）
          ),
          body: Column(
            children: [
              const EatListFilterBar(),
              Expanded(
                child: EatListView(),
              ),
            ],
          ),
          // 右下角悬浮按钮,随机选择当前列表的餐馆
          floatingActionButton: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              logic.handleRandomCurrentEatList(context);
            },
            child: Image.asset(
              Assets.image.eatList.eatListRandom.path,
              width: 45.w,
              height: 45.w,
            ),
          ),
        );
        return resultWidget;
      },
    );
    resultWidget = PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          logic.dismissFilterDropdown();
        }
      },
      child: resultWidget,
    );
    return resultWidget;
  }
}
