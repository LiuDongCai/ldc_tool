import 'package:flutter/material.dart';
import 'package:ldc_tool/base/logic_tag/dc_logic_tag.dart';
import 'package:ldc_tool/features/eat_cook_random/logic/eat_cook_random_logic.dart';

typedef EatCookRandomLogicPutMixin<W extends StatefulWidget>
    = DCLogicPutStateMixin<EatCookRandomLogic, W>;

typedef EatCookRandomLogicConsumerMixin<W extends StatefulWidget>
    = DCLogicConsumerStateMixin<EatCookRandomLogic, W>;

/// 更新类型
enum EatCookRandomUpdateId {
  /// 几菜
  cookCount,

  /// 几汤
  soupCount,

  /// 随机结果
  randomResult,
}

/// 家常菜大类选择
enum EatCookMainType {
  /// 全部
  all,

  /// 主菜
  main,

  /// 汤
  soup,
}
