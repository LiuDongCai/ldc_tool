import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat_random/logic/eat_random_logic.dart';
import 'package:ldc_tool/features/eat_random/header/eat_random_header.dart';
import 'package:ldc_tool/features/eat_random/widgets/eat_random_result_view.dart';
import 'package:ldc_tool/features/eat_random/widgets/eat_random_view.dart';

class EatRandomPage extends StatefulWidget {
  const EatRandomPage({super.key});

  @override
  State<EatRandomPage> createState() => EatRandomPageState();
}

class EatRandomPageState extends State<EatRandomPage>
    with EatRandomLogicPutMixin<EatRandomPage> {
  @override
  EatRandomLogic dcInitLogic() => EatRandomLogic();

  @override
  Widget dcBuildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: DCColors.dcF2F4F7,
      appBar: AppBar(
        title: Text(
          '随机点餐',
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
          const EatRandomView(),
          SizedBox(height: 36.w),
          const EatRandomResultView(),
        ],
      ),
    );
  }
}
