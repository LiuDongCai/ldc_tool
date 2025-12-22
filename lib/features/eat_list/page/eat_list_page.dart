import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat_list/logic/eat_list_logic.dart';
import 'package:ldc_tool/features/eat_list/header/eat_list_header.dart';
import 'package:ldc_tool/features/eat_list/state/eat_list_state.dart';
import 'package:ldc_tool/features/eat_list/widgets/eat_list_view.dart';

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
              state.eatMainTypeName,
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
          body: EatListView(),
        );
        return resultWidget;
      },
    );
    return resultWidget;
  }
}
