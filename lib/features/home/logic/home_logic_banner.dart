import 'package:ldc_tool/features/home/header/home_header.dart';
import 'package:ldc_tool/features/home/logic/home_logic.dart';

extension HomeLogicBanner on HomeLogic {
  /// 切换轮播图
  void handleHomeBannerChange(int index) {
    state.homeBannerActiveIndex = index;
    update([HomeUpdateId.homeBannerIndicator]);
  }
}
