import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/common/widgets/image/dc_image.dart';
import 'package:ldc_tool/features/home/logic/home_logic.dart';
import 'package:ldc_tool/features/home/header/home_header.dart';
import 'package:ldc_tool/gen/assets.gen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with HomeLogicPutMixin<HomePage> {
  @override
  HomeLogic dcInitLogic() => HomeLogic();

  @override
  Widget dcBuildBody(BuildContext context) {
    return GetBuilder<HomeLogic>(
      tag: logicTag,
      builder: (_) {
        Widget resultWidget = _buildBody();
        resultWidget = Scaffold(
          body: resultWidget,
        );
        return resultWidget;
      },
    );
  }

  /// 构建主体内容
  Widget _buildBody() {
    Widget resultWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DCImage.asset(
          Assets.image.common.dcCommonError.path,
          width: 100.w,
          height: 100.h,
        ),
        Text(
          'HomePage2',
          style: TextStyle(
            fontSize: 20.sp,
          ),
        ),
      ],
    );
    return resultWidget;
  }
}
