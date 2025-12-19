import 'package:flutter/material.dart';
import 'package:ldc_tool/base/logic_tag/dc_logic_tag.dart';
import 'package:ldc_tool/features/eat_random/logic/eat_random_logic.dart';

typedef EatRandomLogicPutMixin<W extends StatefulWidget>
    = DCLogicPutStateMixin<EatRandomLogic, W>;

typedef EatRandomLogicConsumerMixin<W extends StatefulWidget>
    = DCLogicConsumerStateMixin<EatRandomLogic, W>;

/// 更新类型
enum EatRandomUpdateId {
  /// 大类选择
  mainType,

  /// 区域选择
  section,

  /// 随机结果
  randomResult,
}
