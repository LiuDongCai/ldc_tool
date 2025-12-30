import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/features/common/router/dc_router_config.dart';
import 'package:ldc_tool/features/home/helper/main_logic_helper.dart';
import 'package:ldc_tool/features/home/logic/home_logic.dart';
import 'package:ldc_tool/features/common/model/dc_menu_model.dart';
import 'package:ldc_tool/features/main/header/main_header.dart';

extension HomeLogicMenu on HomeLogic {
  /// 点击菜单项
  void handleMenuClick(DCMenuModel model) {
    // 如果是点餐页，跳转到主页的点餐tab
    if (model.page == DCPages.eat) {
      MainLogicHelper.instance.logic.handleBottomNavTapByType(
        MainBottomNavigationBarType.eat,
      );
      return;
    }
    DCRouter.open(
      model.page,
    );
  }
}
