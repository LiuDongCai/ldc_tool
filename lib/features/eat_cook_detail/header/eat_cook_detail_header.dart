import 'package:flutter/material.dart';
import 'package:ldc_tool/base/logic_tag/dc_logic_tag.dart';
import 'package:ldc_tool/features/eat_cook_detail/logic/eat_cook_detail_logic.dart';

typedef EatCookDetailLogicPutMixin<W extends StatefulWidget>
    = DCLogicPutStateMixin<EatCookDetailLogic, W>;

typedef EatCookDetailLogicConsumerMixin<W extends StatefulWidget>
    = DCLogicConsumerStateMixin<EatCookDetailLogic, W>;
