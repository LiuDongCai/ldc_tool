import 'package:flutter/material.dart';
import 'package:ldc_tool/base/logic_tag/dc_logic_tag.dart';
import 'package:ldc_tool/features/game/logic/game_logic.dart';

typedef GameLogicPutMixin<W extends StatefulWidget>
    = DCLogicPutStateMixin<GameLogic, W>;

typedef GameLogicConsumerMixin<W extends StatefulWidget>
    = DCLogicConsumerStateMixin<GameLogic, W>;
