import 'package:carousel_slider/carousel_slider.dart';
import 'package:ldc_tool/features/eat/state/eat_state.dart';
import 'package:ldc_tool/gen/assets.gen.dart';

mixin EatStateBanner on EatCommonState {
  /// 轮播图控制器
  CarouselSliderController eatBannerController = CarouselSliderController();

  /// 轮播图列表
  List<String> bannerList = [
    Assets.image.eat.eatBanner1.path,
    Assets.image.eat.eatBanner2.path,
    Assets.image.eat.eatBanner3.path,
  ];

  /// 当前轮播图索引
  int eatBannerActiveIndex = 0;
}
