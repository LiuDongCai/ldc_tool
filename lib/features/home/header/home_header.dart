import 'package:flutter/material.dart';
import 'package:ldc_tool/base/logic_tag/dc_logic_tag.dart';
import 'package:ldc_tool/features/home/logic/home_logic.dart';

typedef HomeLogicPutMixin<W extends StatefulWidget>
    = DCLogicPutStateMixin<HomeLogic, W>;

typedef HomeLogicConsumerMixin<W extends StatefulWidget>
    = DCLogicConsumerStateMixin<HomeLogic, W>;

/// 更新类型
enum HomeUpdateId {
  /// 轮播图指示器
  homeBannerIndicator,
}
