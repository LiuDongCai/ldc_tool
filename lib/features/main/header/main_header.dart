import 'package:flutter/material.dart';
import 'package:ldc_tool/base/logic_tag/dc_logic_tag.dart';
import 'package:ldc_tool/features/main/logic/main_logic.dart';

typedef MainLogicPutMixin<W extends StatefulWidget>
    = DCLogicPutStateMixin<MainLogic, W>;

typedef MainLogicConsumerMixin<W extends StatefulWidget>
    = DCLogicConsumerStateMixin<MainLogic, W>;

/// 主页底部导航栏类型枚举
enum MainBottomNavigationBarType {
  home,
  search,
  tool,
  mine,
}
