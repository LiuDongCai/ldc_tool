import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/features/eat/logic/eat_logic.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';

class EatPage extends StatefulWidget {
  const EatPage({super.key});

  @override
  State<EatPage> createState() => EatPageState();
}

class EatPageState extends State<EatPage> with EatLogicPutMixin<EatPage> {
  @override
  EatLogic dcInitLogic() => EatLogic();

  @override
  Widget dcBuildBody(BuildContext context) {
    return GetBuilder<EatLogic>(
      tag: logicTag,
      builder: (_) {
        return Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              DCRouter.close();
            },
            child: Center(
              child: Container(
                color: Colors.red,
                width: 100.w,
                height: 100.w,
                alignment: Alignment.center,
                child: const Text(
                  '关闭',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
