import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/logic/eat_logic_menu.dart';
import 'package:ldc_tool/features/eat/state/eat_state.dart';
import 'package:ldc_tool/features/common/model/dc_menu_model.dart';

/// 点餐菜单栏
class EatMenuView extends StatefulWidget {
  const EatMenuView({super.key});

  @override
  State<EatMenuView> createState() => _EatMenuViewState();
}

class _EatMenuViewState extends State<EatMenuView>
    with EatLogicConsumerMixin<EatMenuView> {
  EatState get state => logic.state;

  /// 菜单列表数据
  List<DCMenuModel> get menuList => state.eatMenuList;

  @override
  Widget build(BuildContext context) {
    // 网格菜单
    Widget resultWidget = GridView.builder(
      controller: state.eatMenuController,
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
  Widget _buildMenuWidget(DCMenuModel model) {
    Widget resultWidget = Column(
      children: [
        Image.asset(
          model.icon,
          width: 40.w,
          height: 40.w,
        ),
        SizedBox(height: 6.w),
        Text(
          model.title,
          style: TextStyle(
            fontSize: 14.sp,
            color: DCColors.dc333333,
            fontWeight: FontWeight.w600,
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
