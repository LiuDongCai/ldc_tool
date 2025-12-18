import 'package:flutter/material.dart';
import 'package:ldc_tool/base/logic_tag/dc_logic_tag.dart';
import 'package:ldc_tool/features/eat/logic/eat_logic.dart';

typedef EatLogicPutMixin<W extends StatefulWidget>
  = DCLogicPutStateMixin<EatLogic, W>;

typedef EatLogicConsumerMixin<W extends StatefulWidget>
  = DCLogicConsumerStateMixin<EatLogic, W>;
  