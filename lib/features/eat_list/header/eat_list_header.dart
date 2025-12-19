import 'package:flutter/material.dart';
import 'package:ldc_tool/base/logic_tag/dc_logic_tag.dart';
import 'package:ldc_tool/features/eat_list/logic/eat_list_logic.dart';

typedef EatListLogicPutMixin<W extends StatefulWidget>
    = DCLogicPutStateMixin<EatListLogic, W>;

typedef EatListLogicConsumerMixin<W extends StatefulWidget>
    = DCLogicConsumerStateMixin<EatListLogic, W>;
