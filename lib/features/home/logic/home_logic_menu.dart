import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/features/home/logic/home_logic.dart';
import 'package:ldc_tool/features/common/model/dc_menu_model.dart';

extension HomeLogicMenu on HomeLogic {
  /// 点击菜单项
  void handleMenuClick(DCMenuModel model) {
    DCRouter.open(
      model.router,
    );
  }
}
