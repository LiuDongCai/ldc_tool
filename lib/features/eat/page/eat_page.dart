import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/common/widgets/dc_overlay_context_view.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/logic/eat_logic.dart';
import 'package:ldc_tool/features/eat/state/eat_state.dart';
import 'package:ldc_tool/features/eat/widgets/eat_banner_view.dart';
import 'package:ldc_tool/features/eat/widgets/eat_cook_view.dart';
import 'package:ldc_tool/features/eat/widgets/eat_menu_view.dart';
import 'package:ldc_tool/features/eat/widgets/eat_random_feedback_view.dart';

class EatPage extends StatefulWidget {
  const EatPage({super.key});

  @override
  State<EatPage> createState() => EatPageState();
}

class EatPageState extends State<EatPage> with EatLogicPutMixin<EatPage> {
  EatState get state => logic.state;

  @override
  EatLogic dcInitLogic() => EatLogic();

  @override
  void dispose() {
    state.eatMenuController.dispose();
    super.dispose();
  }

  @override
  Widget dcBuildBody(BuildContext context) {
    return GetBuilder<EatLogic>(
      tag: logicTag,
      builder: (_) {
        Widget resultWidget = Stack(
          children: [
            _buildBody(),
            _buildPageOverlay(),
          ],
        );
        resultWidget = Scaffold(
          body: resultWidget,
        );
        return resultWidget;
      },
    );
  }

  /// 构建主体内容
  Widget _buildBody() {
    Widget resultWidget = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 轮播图
          const EatBannerView(),
          SizedBox(height: 12.w),
          // 外卖
          _buildTitle('外卖专区'),
          // 菜单栏
          const EatMenuView(),
          // 随机点餐和反馈
          const EatRandomFeedbackView(),
          Container(
            height: 10.w,
            color: DCColors.dcCCCCCC,
          ),
          SizedBox(height: 12.w),
          // 家常菜
          _buildTitle('家常菜专区'),
          const EatCookView(),
        ],
      ),
    );
    return resultWidget;
  }

  /// 标题
  Widget _buildTitle(String title) {
    Widget resultWidget = Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        color: DCColors.dc333333,
        fontWeight: FontWeight.w600,
      ),
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

  /// 頁面overlay
  Widget _buildPageOverlay() {
    return DCOverlayContextView(
      contextInitHandler: (context) {
        state.pageOverlayContext = context;
      },
    );
  }
}
