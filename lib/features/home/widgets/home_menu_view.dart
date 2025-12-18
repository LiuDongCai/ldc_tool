import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/home/header/home_header.dart';
import 'package:ldc_tool/features/home/logic/home_logic_menu.dart';
import 'package:ldc_tool/features/home/model/home_menu_model.dart';
import 'package:ldc_tool/features/home/state/home_state.dart';

/// 首页菜单栏
class HomeMenuView extends StatefulWidget {
  const HomeMenuView({super.key});

  @override
  State<HomeMenuView> createState() => _HomeMenuViewState();
}

class _HomeMenuViewState extends State<HomeMenuView>
    with HomeLogicConsumerMixin<HomeMenuView> {
  HomeState get state => logic.state;

  /// 菜单列表数据
  List<HomeMenuModel> get menuList => state.menuList;

  @override
  Widget build(BuildContext context) {
    // 网格菜单
    Widget resultWidget = GridView.builder(
      controller: state.menuController,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (context, index) {
        final model = menuList[index];
        return _buildMenuWidget(model);
      },
      itemCount: menuList.length,
    );
    resultWidget = Container(
      margin: EdgeInsets.only(top: 16.w),
      child: resultWidget,
    );
    return resultWidget;
  }

  /// 构建菜单项
  Widget _buildMenuWidget(HomeMenuModel model) {
    Widget resultWidget = Column(
      children: [
        Image.asset(
          model.icon,
          width: 45.w,
          height: 45.w,
        ),
        SizedBox(height: 8.w),
        Text(
          model.title,
          style: TextStyle(
            fontSize: 14.sp,
            color: DCColors.dc333333,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
    // 点击菜单项
    resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        logic.handleMenuClick(model);
      },
      child: resultWidget,
    );
    return resultWidget;
  }
}
