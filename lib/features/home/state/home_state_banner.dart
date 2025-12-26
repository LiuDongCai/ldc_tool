import 'package:carousel_slider/carousel_slider.dart';
import 'package:ldc_tool/features/home/state/home_state.dart';
import 'package:ldc_tool/gen/assets.gen.dart';

mixin HomeStateBanner on HomeCommonState {
  /// 轮播图控制器
  CarouselSliderController homeBannerController = CarouselSliderController();

  /// 轮播图列表
  List<String> homeBannerList = [
    Assets.image.home.homeBanner1.path,
  ];

  /// 当前轮播图索引
  int homeBannerActiveIndex = 0;
}
