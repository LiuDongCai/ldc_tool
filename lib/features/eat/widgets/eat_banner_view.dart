import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ldc_tool/common/colors/dc_colors.dart';
import 'package:ldc_tool/features/eat/header/eat_header.dart';
import 'package:ldc_tool/features/eat/logic/eat_logic.dart';
import 'package:ldc_tool/features/eat/logic/eat_logic_banner.dart';
import 'package:ldc_tool/features/eat/state/eat_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// 点餐轮播图
class EatBannerView extends StatefulWidget {
  const EatBannerView({super.key});

  @override
  State<EatBannerView> createState() => _EatBannerViewState();
}

class _EatBannerViewState extends State<EatBannerView>
    with EatLogicConsumerMixin<EatBannerView> {
  EatState get state => logic.state;

  /// 菜单列表数据
  List<String> get bannerList => state.bannerList;

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = CarouselSlider.builder(
      itemCount: bannerList.length,
      itemBuilder: (context, index, realIdx) {
        final url = bannerList[index];
        return _buildBannerWidget(url);
      },
      options: CarouselOptions(
        viewportFraction: 1, // 关键！控制可视区域比例
        padEnds: false,
        height: 210.w,
        autoPlay: bannerList.length > 1,
        autoPlayInterval: const Duration(seconds: 5),
        enableInfiniteScroll: bannerList.length > 1,
        onPageChanged: (index, reason) {
          logic.handleEatBannerChange(index);
        },
      ),
      carouselController: state.eatBannerController,
    );
    resultWidget = Stack(
      children: [
        resultWidget,
        // 轮播图指示器
        if (bannerList.length > 1)
          Positioned(
            right: 23.w,
            bottom: 8.w,
            child: GetBuilder<EatLogic>(
              tag: logicTag,
              id: EatUpdateId.eatBannerIndicator,
              builder: (_) {
                return AnimatedSmoothIndicator(
                  activeIndex: state.eatBannerActiveIndex,
                  count: bannerList.length,
                  effect: ExpandingDotsEffect(
                    expansionFactor: 12.w / 4.w,
                    dotHeight: 5.w,
                    dotWidth: 5.w,
                    offset: 4.w,
                    spacing: 2.w,
                    activeDotColor: DCColors.dc006AFF.withValues(alpha: 0.9),
                    dotColor: DCColors.dc006AFF.withValues(alpha: 0.6),
                  ),
                );
              },
            ),
          ),
      ],
    );
    return resultWidget;
  }

  /// 构建菜单项
  Widget _buildBannerWidget(String imageUrl) {
    Widget resultWidget = Image.asset(
      imageUrl,
      width: double.infinity,
      height: 210.w,
      fit: BoxFit.cover,
    );
    return resultWidget;
  }
}
