import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/common/widgets/dc_overlay_context_view.dart';
import 'package:ldc_tool/features/home/logic/home_logic.dart';
import 'package:ldc_tool/features/home/header/home_header.dart';
import 'package:ldc_tool/features/home/state/home_state.dart';
import 'package:ldc_tool/features/home/widgets/home_menu_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with HomeLogicPutMixin<HomePage> {
  HomeState get state => logic.state;

  @override
  HomeLogic dcInitLogic() => HomeLogic();

  @override
  void dispose() {
    state.menuController.dispose();
    super.dispose();
  }

  @override
  Widget dcBuildBody(BuildContext context) {
    return GetBuilder<HomeLogic>(
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
        children: [
          // 头部广告
          Container(
            height: 100.w,
            width: double.infinity,
            color: Colors.red,
          ),
          // 菜单栏
          const HomeMenuView(),
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
