import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat_cook_random/header/eat_cook_random_header.dart';
import 'package:ldc_tool/features/eat_cook_random/logic/eat_cook_random_logic.dart';
import 'package:ldc_tool/features/eat_cook_random/widgets/eat_cook_random_result_view.dart';
import 'package:ldc_tool/features/eat_cook_random/widgets/eat_cook_random_view.dart';

/// 家常菜点菜
class EatCookRandomPage extends StatefulWidget {
  const EatCookRandomPage({super.key});

  @override
  State<EatCookRandomPage> createState() => EatCookRandomPageState();
}

class EatCookRandomPageState extends State<EatCookRandomPage>
    with EatCookRandomLogicPutMixin<EatCookRandomPage> {
  @override
  EatCookRandomLogic dcInitLogic() => EatCookRandomLogic();

  @override
  Widget dcBuildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: DCColors.dcF2F4F7,
      appBar: AppBar(
        title: Text(
          '家常菜',
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
      body: Column(
        children: [
          const EatCookRandomView(),
          SizedBox(height: 36.w),
          const Expanded(
            child: EatCookRandomResultView(),
          ),
        ],
      ),
    );
  }
}
