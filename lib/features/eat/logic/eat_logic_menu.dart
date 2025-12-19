import 'package:ldc_tool/base/router/dc_router.dart';
import 'package:ldc_tool/features/common/model/dc_menu_model.dart';
import 'package:ldc_tool/features/eat/logic/eat_logic.dart';

extension EatLogicMenu on EatLogic {
  /// 点击菜单
  void handleMenuClick(DCMenuModel model) {
    DCRouter.open(
      model.page,
      arguments: model.params,
    );
  }
}
