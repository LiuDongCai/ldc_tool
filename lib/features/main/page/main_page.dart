import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat/page/eat_page.dart';
import 'package:ldc_tool/features/main/logic/main_logic.dart';
import 'package:ldc_tool/features/main/header/main_header.dart';
import 'package:ldc_tool/features/home/page/home_page.dart';
import 'package:ldc_tool/features/main/state/main_state.dart';
import 'package:ldc_tool/features/main/widgets/main_lazy_load_indexed_stack.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> with MainLogicPutMixin<MainPage> {
  MainState get state => logic.state;

  @override
  MainLogic dcInitLogic() => MainLogic();

  @override
  Widget dcBuildBody(BuildContext context) {
    return GetBuilder<MainLogic>(
      tag: logicTag,
      assignId: true,
      builder: (_) {
        Widget resultWidget = _buildBody();
        resultWidget = Scaffold(
          body: resultWidget,
          bottomNavigationBar: _buildBottomNavigationBar(),
        );
        return resultWidget;
      },
    );
  }

  /// 构建主体内容
  Widget _buildBody() {
    Widget resultWidget = MainLazyLoadIndexedStack(
      key: state.mainKey,
      currentIndex: state.currentIndex,
      children: [
        ...state.bottomNavigationBarTypeList.map(
          (type) {
            final globalKey = state.globalKeys[type];
            Widget resultWidget;
            switch (type) {
              case MainBottomNavigationBarType.home:
                // 首页
                resultWidget = HomePage(key: globalKey);
                break;
              case MainBottomNavigationBarType.eat:
                // 点餐
                resultWidget = EatPage(key: globalKey);
                break;
              case MainBottomNavigationBarType.tool:
                // 工具
                resultWidget = Container();
                break;
              case MainBottomNavigationBarType.mine:
                // 我的
                resultWidget = Container();
                break;
            }
            resultWidget = AnnotatedRegion<SystemUiOverlayStyle>(
              child: resultWidget,
              value: SystemUiOverlayStyle.dark,
            );
            return resultWidget;
          },
        ),
      ],
    );
    return resultWidget;
  }

  /// 构建底部导航栏
  Widget _buildBottomNavigationBar() {
    Widget resultWidget = BottomNavigationBar(
      currentIndex: state.currentIndex,
      onTap: (index) => logic.handleBottomNavTap(index),
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
      selectedIconTheme: IconThemeData(
        color: DCColors.dc42CC8F,
        size: 26.w,
      ),
      unselectedIconTheme: IconThemeData(
        color: DCColors.dc666666,
        size: 24.w,
      ),
      selectedItemColor: DCColors.dc42CC8F,
      unselectedItemColor: DCColors.dc666666,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '首页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          label: '点餐',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.build),
          label: '工具',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '我的',
        ),
      ],
    );
    return resultWidget;
  }
}
