import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/common/widgets/dc_overlay_context_view.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/logic/eat_logic.dart';
import 'package:ldc_tool/features/eat/state/eat_state.dart';
import 'package:ldc_tool/features/eat/widgets/eat_banner_view.dart';
import 'package:ldc_tool/features/eat/widgets/eat_menu_view.dart';
import 'package:ldc_tool/features/eat/widgets/eat_random_view.dart';

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
    Widget resultWidget = const SingleChildScrollView(
      child: Column(
        children: [
          // 轮播图
          EatBannerView(),
          // 菜单栏
          EatMenuView(),
          // 帮我选择
          EatRandomView(),
        ],
      ),
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
