import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/logic/eat_logic.dart';

extension EatLogicBanner on EatLogic {
  /// 切换轮播图
  void handleEatBannerChange(int index) {
    state.eatBannerActiveIndex = index;
    update([EatUpdateId.eatBannerIndicator]);
  }
}
